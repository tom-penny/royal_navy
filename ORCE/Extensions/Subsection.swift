import Foundation

extension Subsection {
    
    func getObservations() -> [Observation] {
        Array(observations as? Set<Observation> ?? [])
    }
}
