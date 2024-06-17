import SwiftUI

struct PromptView: View {
        
    @Binding var isPresented : Bool
    
    var prompt : String
        
    init(isPresented: Binding<Bool>, prompt: String) {
        self._isPresented = isPresented
        self.prompt = prompt
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.gray.opacity(0.5)
                    .ignoresSafeArea()
                    .blur(radius: 5)
                VStack {
                    Button(prompt) {
                        isPresented = false
                    }
                    .buttonStyle(ORCEButtonStyle())
                }
            }
        }
    }
}
