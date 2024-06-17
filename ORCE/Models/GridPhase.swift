import Foundation

struct GridPhase : Identifiable, Codable, Hashable {
    var id = UUID()
    var name : String
    var sections : [GridSection]
    
    private enum CodingKeys : String, CodingKey { case name, sections }
}
