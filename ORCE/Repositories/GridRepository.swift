import Foundation

class GridRepository {
    
    func loadGrids() -> [Grid] {
        guard let url = Bundle.main.url(forResource: "grids", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Grid].self, from: data)
        }
        catch {
            print(error)
            return []
        }
    }
}
    
