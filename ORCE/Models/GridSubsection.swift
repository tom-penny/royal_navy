import Foundation

struct GridSubsection : Identifiable, Codable, Hashable {
    var id = UUID()
    var positives : [GridObservation]
    var negatives : [GridObservation]
    
    private enum CodingKeys : String, CodingKey { case positives, negatives }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.positives = try container.decode([String].self, forKey: .positives).map { behaviour in
            GridObservation(behaviour: behaviour, isPositive: true)
        }
        self.negatives = try container.decode([String].self, forKey: .negatives).map { behaviour in
            GridObservation(behaviour: behaviour, isPositive: false)
        }
    }
}
