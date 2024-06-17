import SwiftUI

struct ExerciseView: View {
    
    @State var displayPrompt = true
    @State var currentPhase : GridPhase?
    @StateObject var viewModel = ExerciseViewModel()
        
    var body: some View {
        VStack {
            if let _ = currentPhase, let timer = viewModel.timer {
                VStack {
                    TimerView(timer: timer).padding(.top, 20)
                    PhaseView(phase: $currentPhase, handleComplete: viewModel.reduce, timer: timer)
                }
                .overlay(PromptView(isPresented: $displayPrompt, prompt: "Start Exercise"))
                .onChange(of: displayPrompt) { _ in
                    viewModel.timer!.start()
                }
                .sheet(item: $viewModel.report) {
                    viewModel.reset()
                    displayPrompt = true
                } content: { exercise in
                    if let exercise {
                        ReportView(exercise: exercise)
                    }
                }
            }
            else {
                FormView(handleSubmit: viewModel.reduce)
            }
        }
        .onChange(of: viewModel.currentPhase) { _ in
            currentPhase = viewModel.currentPhase
        }
    }
    
//    func displayReport(_ exercise: Exercise) -> some View {
//
//        //
//        //Text(String(describing: exercise))
//        VStack {
//            Text("\(exercise.grid!) Assessment Report").foregroundColor(Color("Primary"))
//            Text("Instructor Notes")
//            var phaseList = exercise.getPhases()
//            ForEach(phaseList) { phase in
//                    Text(phase.notes!)
//                }
//            Text("Final Score")
//            List(exercise.getPhases()) { phase in
//                HStack{
//                    Text(phase.name!)
//                    Text(String(phase.calculatePhasescore()))
//                }
//            }
//            HStack {
//                Text("Total")
//                Text(String(exercise.getTotalScore()))
//            }
//        }
//    }
}


//struct ExerciseView_Previews: PreviewProvider {
//    static var grid : Grid
//
//    static var previews: some View {
//        ExerciseView(grid: Self.grid)
//    }
//}
