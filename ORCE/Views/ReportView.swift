import SwiftUI

struct ReportView: View {
    
    @State var currentTab = 0
    
    var exercise : Exercise
    var phases : [Phase]
    
    let formatter = DateFormatter()
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.phases = exercise.getPhases()
        formatter.dateStyle = .short
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("PUID: \(exercise.studentID ?? "")")
                    .frame(minWidth: 200, maxHeight: 50)
                    .padding(10)
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                VStack {
                    HStack {
                        CellView(key: "Exercise", value: exercise.grid ?? "")
                        CellView(key: "Date", value: formatter.string(from: exercise.date ?? Date()))
                    }
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color("Primary"))
                    HStack {
                        CellView(key: "Instructor", value: exercise.instructorID ?? "")
                        CellView(key: "Course", value: exercise.course ?? "")
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Primary"), lineWidth: 2)
            )
            .padding()
            
            TabView(selection: $currentTab) {
                ForEach(phases.indices) { index in
                    PhaseReportView(phase: phases[index]).tabItem {
                        Text(phases[index].name ?? "")
                    }.tag(index)
                }
                ScoreReportView(exercise: exercise).tabItem {
                    Text("Final Score")
                }.tag(phases.count)
            }
//            PageIndexView(selection: $currentTab, pageCount: phases.count)
//                .padding(.bottom, 20)
            
            
        }
    }
}

struct PageIndexView : View {
    
    @Binding var selection : Int
    
    let pageCount : Int
    
    var body: some View {
        HStack {
            ForEach(0..<pageCount) { index in
                Circle()
                    .foregroundColor(selection == index ? Color("Accent") : .gray)
                    .frame(width: 5, height: 5)
            }
        }
    }
}

struct ScoreReportView : View {
    
    var exercise : Exercise
    
    var scores = [(String, String)]()
    
    init(exercise: Exercise) {
        self.exercise = exercise
        exercise.getPhases().forEach { phase in
            let score = "\(phase.score) / \(phase.total)"
            scores.append((phase.name ?? "", score))
        }
        scores.append(("Total", "\(exercise.score) / \(exercise.total)"))
    }
    
    var body: some View {
        VStack {
            Text("Final Score")
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color("Primary"))
                .foregroundColor(.white)
            List(scores, id: \.0) { score in
                HStack {
                    Text(score.0)
                        .frame(maxWidth: 150, alignment: .leading)
                    Text(score.1)
                        .frame(maxWidth: 100, alignment: .leading)
                }
            }
            .listStyle(.plain)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("Primary"), lineWidth: 2)
        )
        .padding()
    }
}

struct PhaseReportView : View {
    
    var phase : Phase
    
    var height : Int {
        let lines = (phase.notes?.components(separatedBy: "\n").count ?? 0) + 1
        let height = lines * 10
        return height <= 80 ? height : 80
    }
    
    var body: some View {
        VStack {
            Text(phase.name ?? "")
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color("Primary"))
                .foregroundColor(.white)
            List(phase.getSections()) { section in
                SectionReportView(section: section)
            }
            .listStyle(.plain)
            .padding()
            noteView
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("Primary"), lineWidth: 2)
        )
        .padding()
    }
    
    var noteView : some View {
        GroupBox {
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    Text(phase.notes ?? "")
                        .font(.footnote)
                    Spacer()
                }
            }
            .frame(maxHeight: CGFloat(height))
        } label: {
            Label("Instructor Notes", systemImage: "square.and.pencil")
        }
    }
}

struct SectionReportView : View {
    
    var section : Section
    var observations : [Observation]
    
    init(section: Section) {
        self.section = section
        self.observations = section.getObservations().sorted { lhs, rhs in
            lhs.timestamp ?? "" < rhs.timestamp ?? ""
        }
    }
    
    var body: some View {
        SwiftUI.Section {
            ForEach(observations) { observation in
                ObservationReportView(observation: observation)
            }
        } header: {
            Text(section.name ?? "")
        }
    }
}

struct ObservationReportView : View {
    
    var observation : Observation
    
    var body: some View {
        HStack {
            Text(observation.timestamp ?? "")
                .frame(maxWidth: 80, alignment: .leading)
            Text(observation.isPositive ? "Positive" : "Negative")
                .frame(maxWidth: 80, alignment: .leading)
            Text(observation.behaviour ?? "")
        }
        .font(.caption)
    }
}

struct CellView : View {
    var key : String
    var value : String
    
    var body: some View {
        HStack {
            Text(key + ":")
                .frame(maxWidth: 100, alignment: .center)
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
//
//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
