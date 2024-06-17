import SwiftUI

struct ObservationView: View {
    
    @EnvironmentObject var viewModel : PhaseViewModel
    
    var subsection : GridSubsection
    var observations : [GridObservation]
    
    var body: some View {
        SwiftUI.Section {
            ForEach(observations) { observation in
                Toggle(isOn: viewModel.record(observation, for: subsection)) {
                    Text(observation.behaviour)
                }
            }
        }
    }

}
