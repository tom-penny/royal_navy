import Foundation

extension Section {
    
    func getSubsections() -> [Subsection] {
        Array(subsections as? Set<Subsection> ?? [])
    }
    
    func getObservations() -> [Observation] {
        Array(getSubsections().flatMap { $0.getObservations() })
    }
}
