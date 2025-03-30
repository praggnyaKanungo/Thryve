import SwiftUI

class GameTimerManager: ObservableObject {
    static let shared = GameTimerManager()
    
    @Published var isTimerRunning = false
    @Published var timeRemaining: TimeInterval = 180 
    @Published var daysSinceStart = 0
    
    private var timer: Timer?
    private let dayDuration: TimeInterval = 180 
    
    private init() {
        loadTimerState()
    }
    
    func startTimer() {
        guard !isTimerRunning else { return }
        
        isTimerRunning = true
        timeRemaining = dayDuration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
        
        saveTimerState()
    }
    
    private func timerTick() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            advanceDay()
            timeRemaining = dayDuration
        }
        
        if Int(timeRemaining) % 10 == 0 {
            saveTimerState()
        }
    }
    
    private func advanceDay() {
        daysSinceStart += 1
        
        DispatchQueue.main.async {
            FarmMapManager.shared.advanceDay()
        }
    }
    
    private func saveTimerState() {
        UserDefaults.standard.set(isTimerRunning, forKey: "gameTimerRunning")
        UserDefaults.standard.set(timeRemaining, forKey: "gameTimeRemaining")
        UserDefaults.standard.set(daysSinceStart, forKey: "gameDaysSinceStart")
    }
    
    private func loadTimerState() {
        isTimerRunning = UserDefaults.standard.bool(forKey: "gameTimerRunning")
        timeRemaining = UserDefaults.standard.double(forKey: "gameTimeRemaining")
        if timeRemaining <= 0 || timeRemaining > dayDuration {
            timeRemaining = dayDuration
        }
        daysSinceStart = UserDefaults.standard.integer(forKey: "gameDaysSinceStart")
        
        if isTimerRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.timerTick()
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        saveTimerState()
    }
    
    func resumeTimer() {
        guard isTimerRunning else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    func resetTimer() {
        pauseTimer()
        
        isTimerRunning = false
        timeRemaining = dayDuration
        daysSinceStart = 0
        
        UserDefaults.standard.removeObject(forKey: "gameTimerRunning")
        UserDefaults.standard.removeObject(forKey: "gameTimeRemaining")
        UserDefaults.standard.removeObject(forKey: "gameDaysSinceStart")
    }
    
    var formattedTimeRemaining: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        timer?.invalidate()
    }
}
