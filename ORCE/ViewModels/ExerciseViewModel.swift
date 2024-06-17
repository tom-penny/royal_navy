import Foundation

class ExerciseViewModel : ViewModel {
    
    private var grid : Grid?
    private var exercise : Exercise?
    private var phaseIndex = 0
    private var repository = ExerciseRepository()
    
    @Published var report : Exercise?
    @Published var currentPhase : GridPhase?
        
    var timer : ExerciseTimer?
        
    func createExercise(student: String, instructor: String, course: String, grid: Grid) {
        if let exercise = repository.createExercise(student: student, instructor: instructor, course: course, grid: grid.accronym) {
            self.grid = grid
            self.exercise = exercise
            currentPhase = grid.phases[phaseIndex]
        }
        timer = ExerciseTimer(totalMins: grid.totalMins, alertMins: grid.alertMins)
    }
    
    func recordPhase(with observations: [GridSubsection: [GridObservation : String]], and notes: String) {
        guard let exercise = exercise else { return }
        repository.addPhase(currentPhase!, for: exercise, with: observations, and: notes)
        nextPhase()
    }
    
    func reset() {
        timer = nil
        currentPhase = nil
        grid = nil
        exercise = nil
        phaseIndex = 0
        report = nil
    }
    
    private func nextPhase() {
        phaseIndex += 1
        guard let grid, grid.phases.indices.contains(phaseIndex) else {
            exerciseComplete()
            return
        }
        currentPhase = grid.phases[phaseIndex]
    }
    
    private func exerciseComplete() {
        report = exercise
    }
    
    func reduce(action: Action) {
        switch action {
        case let .createExercise(student, instructor, course, grid):
            createExercise(student: student, instructor: instructor, course: course, grid: grid)
        case let .recordPhase(observations, notes):
            recordPhase(with: observations, and: notes)
        }
    }
    
    enum Action {
        case createExercise(student: String, instructor: String, course: String, grid: Grid)
        case recordPhase(with: [GridSubsection: [GridObservation : String]], and: String)
    }
}
