import SwiftUI

struct PhaseView: View {
    
    @State private var path = NavigationPath()
    @StateObject var viewModel : PhaseViewModel
    @Binding var phase : GridPhase?
    @FocusState var isFocused : Bool
    
    @State var showNotes = false {
        didSet(value) {
            isFocused = value
        }
    }

    var handleComplete: (ExerciseViewModel.Action) -> Void
    
    init(phase: Binding<GridPhase?>, handleComplete: @escaping (ExerciseViewModel.Action) -> Void, timer: ExerciseTimer) {
        self._phase = phase
        self.handleComplete = handleComplete
        let viewModel = PhaseViewModel(timer: timer)
        self._viewModel = StateObject(wrappedValue: viewModel)
        UITabBar.appearance().barTintColor = .white
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(phase!.name)
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                    .foregroundColor(.white)
                    .background(Color("Primary"))
                NavigationStack(path: $path) {
                    List(phase!.sections) { section in
                        NavigationLink(section.name, value: section)
                    }
                    .navigationDestination(for: GridSection.self) { section in
                        SectionView(section: section).environmentObject(viewModel)
                    }
                }
                .scrollContentBackground(.hidden)
                Button {
                    showNotes.toggle()
                } label: {
                    HStack {
                        Text("Notes")
                            .foregroundColor(Color(.systemGray3))
                            .font(.headline)
                        Image(systemName: "arrow.up")
                            .foregroundColor(Color(.systemGray3))
                            .rotationEffect(.degrees((showNotes ? 180 : 0)))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                }
                if showNotes {
                    TextField("Notes", text: $viewModel.phaseNotes, axis: .vertical)
                        .padding()
                        .lineLimit(4...10)
                        .focused($isFocused)
                        .onAppear() {
                            isFocused = true
                        }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color("Primary"), lineWidth: 2)
            )
            Spacer(minLength: 20)
            if !showNotes {
                Button {
                    let notes = viewModel.compileNotes()
                    handleComplete(.recordPhase(with: viewModel.observations, and: notes))
                } label: {
                    Text("COMPLETE PHASE")
                        .padding()
                        .padding(.horizontal)
                        .font(.headline)
                        .background(Color("Primary"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 200)
        .onAppear() {
            if let initial = _phase.wrappedValue {
                viewModel.setPhase(initial)
            }
        }
        .onChange(of: phase) { newPhase in
            if let newPhase {
                viewModel.setPhase(newPhase)
                path.removeLast(path.count)
                viewModel.phaseNotes = ""
            }
        }
        .alert(Text("Exercise Paused"), isPresented: $viewModel.timerPaused) {
            Button("Continue") {
                viewModel.resumeTimer()
            }
            TextField("Reason", text: $viewModel.pauseReason)
        } message: {
            Text("Specify reason")
        }
    }
}
