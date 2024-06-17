import SwiftUI

class FormViewModel : ViewModel {
    
    var grids : [Grid]
    
    private let repository = GridRepository()
    
    init() {
        self.grids = repository.loadGrids()
    }
}
