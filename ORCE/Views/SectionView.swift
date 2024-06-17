import SwiftUI

struct SectionView: View {
    
    var section : GridSection
    
    var body: some View {
        TabView {
            List {
                ForEach(section.subsections) { subsection in
                    ObservationView(subsection: subsection, observations: subsection.positives)
                }
            }
            .tabItem {
                Label("POSITIVE", systemImage: "checkmark.seal.fill")
                    .symbolRenderingMode(.palette).foregroundColor(.green)
            }
            List {
                ForEach(section.subsections) { subsection in
                    ObservationView(subsection: subsection, observations: subsection.negatives)
                }
            }
            .tabItem {
                Label("NEGATIVE", systemImage: "wrongwaysign.fill").symbolRenderingMode(.palette).foregroundColor(.red)
            }
        }
        .navigationTitle(section.name)
    }
}
