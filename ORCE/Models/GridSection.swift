import Foundation

struct GridSection : Identifiable, Codable, Hashable {
    var id = UUID()
    var name : String
    var descriptor : String
    var subsections : [GridSubsection]
    
    private enum CodingKeys : String, CodingKey { case name, descriptor, subsections }
}
