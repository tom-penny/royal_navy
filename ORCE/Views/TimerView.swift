import SwiftUI

struct TimerView: View {
    
    @State private var color : Color = .black
    @State private var animate = false
    
    @ObservedObject var timer : ExerciseTimer
    
    init(timer: ExerciseTimer) {
        self.timer = timer
    }
    
    var body: some View {
        HStack {
            Text(timer.timestamp)
                .foregroundColor(color)
                .opacity(animate ? 0.25 : 1)
            if (timer.isPaused) {
                Image(systemName: "play.fill")
            }
            else {
                Button {
                    timer.pause()
                } label: {
                    Image(systemName: "pause.fill")
                }
            }
        }
        .onReceive(timer.$alerted) { alerted in
            if alerted {
                color = .orange
                triggerAnimation()
            }
        }
        .onReceive(timer.$expired) { expired in
            if expired {
                color = .red
                triggerAnimation()
            }
        }
    }
    
    func triggerAnimation() {
        animate = true
        withAnimation(.easeInOut(duration: 1)) {
            animate = false
        }
    }
}

struct TimerView_Previews: PreviewProvider {
        
    static var previews: some View {
        TimerView(timer: ExerciseTimer(totalMins: 1.00, alertMins: 0.50))
    }
}
