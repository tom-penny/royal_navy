import Foundation

extension Phase {
    
    func getSections() -> [Section] {
        Array(sections as? Set<Section> ?? [])
    }
}
