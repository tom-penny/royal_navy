import Foundation

struct GridObservation : Identifiable, Codable, Hashable {
    var id = UUID()
    var behaviour : String
    var isPositive : Bool
    
    private enum CodingKeys : String, CodingKey { case behaviour, isPositive }
}
