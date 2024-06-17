import Foundation

extension Exercise {
    
    func getPhases() -> [Phase] {
        Array(phases as? Set<Phase> ?? [])
    }
}
