import SwiftUI
import Combine

class PhaseViewModel : ViewModel {
    
    private var timer : ExerciseTimer
    private var pauses = [String]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var observations = [GridSubsection : [GridObservation : String]]()
    @Published var phaseNotes = ""
    @Published var timerPaused = false
    @Published var pauseReason = ""
    
    init(timer: ExerciseTimer) {
        self.timer = timer
        timer.$isPaused
            .map { isPaused -> Bool in
                return isPaused && timer.elapsed > 0.0
            }
            .assign(to: \.timerPaused, on: self)
            .store(in: &cancellables)
    }
    
    func compileNotes() -> String {
        if pauses.isEmpty { return phaseNotes }
        return pauses.reduce("\(phaseNotes)\n\nPauses:") { $0 + "\n" + $1 }
    }
    
    func resumeTimer() {
        let reason = pauseReason.isEmpty ? "No reason specified" : pauseReason
        pauses.append("\(timer.timestamp) - \(reason)")
        pauseReason = ""
        timer.start()
    }
    
    func setPhase(_ phase: GridPhase) {
        observations = phase.sections.reduce(into: [:]) { dictionary, section in
            section.subsections.forEach { dictionary[$0] = [:] }
        }
        pauses = []
    }
    
    func record(_ observation: GridObservation, for subsection: GridSubsection) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.observations[subsection]?.keys.contains(observation) ?? false },
            set: { value in
                if value {
                    self.observations[subsection]?[observation] = self.timer.timestamp
                }
                else {
                    self.observations[subsection]?.removeValue(forKey: observation)
                }
            }
        )
    }
}
