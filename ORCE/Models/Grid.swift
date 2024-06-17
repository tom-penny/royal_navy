import Foundation

struct Grid : Identifiable, Codable, Hashable {
    var id = UUID()
    var name : String
    var accronym: String
    var totalMins : Double
    var alertMins : Double
    var phases : [GridPhase]
    
    private enum CodingKeys : String, CodingKey { case name, accronym, totalMins, alertMins, phases }
}
