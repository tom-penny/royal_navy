import SwiftUI

extension View {
    func prompt(isPresented: Binding<Bool>, prompt: String) -> some View {
        self.overlay {
            PromptView(isPresented: isPresented, prompt: prompt)
        }
    }
}

extension Exercise {

    var score : Int64 {
        var exerciseScore: Int64 = 0
        for phase in self.getPhases() {
            exerciseScore = exerciseScore + phase.score
        }
        return exerciseScore
    }
    
    var total : Int64 {
        var exerciseTotal: Int64 = 0
        for phase in self.getPhases() {
            exerciseTotal = exerciseTotal + phase.total
        }
        return exerciseTotal
    }
}

extension Phase {

    var score : Int64 {
        var phaseScore: Int64 = 0
        for section in self.getSections() {
            phaseScore = phaseScore + section.score
        }
        return phaseScore
    }
    
    var total : Int64 {
        var phaseTotal : Int64 = 0
        for section in self.getSections() {
            phaseTotal = phaseTotal + section.total
        }
        return phaseTotal
    }
}

extension Section {

    var score : Int64 {
        var sectionScore: Int64 = 0
        for subsection in self.getSubsections() {
            sectionScore = sectionScore + subsection.result
        }
        return sectionScore
    }
    
    var total : Int64 {
        Int64(self.getSubsections().count * 4)
    }
}


