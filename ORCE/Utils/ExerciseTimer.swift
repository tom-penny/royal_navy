import Foundation

class ExerciseTimer : ObservableObject {
    
    private var timer : Timer?
    private var totalMins : Double
    private var alertMins : Double
    
    @Published var timestamp : String = "00:00:00"
    @Published var alerted = false
    @Published var expired = false
    @Published var isPaused = true
    
    var elapsed = 0.0 {
        willSet(time) {
            if time >= (alertMins * 60) && !alerted { alerted.toggle() }
            if time >= (totalMins * 60) && !expired { expired.toggle() }
        }
        didSet {
            let hrs = Int(elapsed) / 3600
            let mins = Int(elapsed) / 60
            let secs = Int(elapsed) % 60
            timestamp = String(format: "%02d:%02d:%02d", hrs, mins, secs)
        }
    }
    
    init(totalMins: Double = 0.0, alertMins: Double = 0.0) {
        self.totalMins = totalMins > 0.0 ? totalMins : .infinity
        self.alertMins = alertMins
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsed += 1.0
        }
        isPaused = false
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
}
