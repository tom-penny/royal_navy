import Foundation
import CoreData

class ExerciseRepository {

    private let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        self.container = Self.createContainer()
    }
    
    func createExercise(student: String, instructor: String, course: String, grid: String) -> Exercise? {
        let exercise = Exercise(context: viewContext)
        exercise.studentID = student
        exercise.instructorID = instructor
        exercise.course = course
        exercise.grid = grid
        exercise.date = Date()
        
        do { try viewContext.save() }
        catch { print(error) }
        
        return exercise
    }
    
    func addPhase(_ gridPhase: GridPhase, for exercise: Exercise, with observations: [GridSubsection : [GridObservation : String]], and notes: String) {
        
            let phase = Phase(context: viewContext)
            phase.name = gridPhase.name
            phase.notes = notes
            phase.exercise = exercise
            
            mapSections(gridPhase.sections, to: phase, context: viewContext) { gridSection, section in
                mapSubsections(gridSection.subsections, to: section, context: viewContext) { gridSubsection, subsection in
                    let subObservations = observations[gridSubsection] ?? [:]
                    subsection.result = calculateResult(from: Array(subObservations.keys))
                    mapObservations(subObservations, to: subsection, context: viewContext)
                }
            }
            
            do { try viewContext.save() }
            catch { print(error) }
    }
    
    private func mapSections(_ sections: [GridSection], to phase: Phase, context: NSManagedObjectContext, completion: (GridSection, Section) -> Void) {
        sections.forEach { gridSection in
            let section = Section(context: context)
            section.name = gridSection.name
            section.phase = phase
            completion(gridSection, section)
        }
    }
    
    private func mapSubsections(_ subsections: [GridSubsection], to section: Section, context: NSManagedObjectContext, completion: (GridSubsection, Subsection) -> Void) {
        subsections.forEach { gridSubsection in
            let subsection = Subsection(context: context)
            subsection.section = section
            completion(gridSubsection, subsection)
        }
    }
    
    private func mapObservations(_ observations: [GridObservation : String], to subsection: Subsection, context: NSManagedObjectContext) {
        observations.forEach { (gridObservation, timestamp) in
            let observation = Observation(context: context)
            observation.behaviour = gridObservation.behaviour
            observation.isPositive = gridObservation.isPositive
            observation.timestamp = timestamp
            observation.subsection = subsection
        }
    }
    
    private func calculateResult(from observations: [GridObservation]) -> Int64 {
        let totalCount = observations.count
        let positives = observations.filter { $0.isPositive }.count
        let negatives = totalCount - positives
        
        if positives == negatives { return 2 }
        if positives == totalCount { return 4 }
        if negatives == totalCount { return 0 }
        if positives < negatives { return 1 }
        if positives > negatives { return 3 }
        return 2
    }

    private static func createContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ORCE")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? { print(error) }
        }
        return container
    }
}
