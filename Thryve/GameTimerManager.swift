import SwiftUI

// Timer manager to handle automatic day advancement
class GameTimerManager: ObservableObject {
    static let shared = GameTimerManager()
    
    // Published properties to track timer state
    @Published var isTimerRunning = false
    @Published var timeRemaining: TimeInterval = 180 // 3 minutes in seconds
    @Published var daysSinceStart = 0
    
    // Timer instance
    private var timer: Timer?
    private let dayDuration: TimeInterval = 180 // 3 minutes
    
    private init() {
        // Load saved state if any
        loadTimerState()
    }
    
    // Start the timer when first crop is planted
    func startTimer() {
        guard !isTimerRunning else { return }
        
        isTimerRunning = true
        timeRemaining = dayDuration
        
        // Create and schedule the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
        
        // Save timer state
        saveTimerState()
    }
    
    // Timer tick handler
    private func timerTick() {
        timeRemaining -= 1
        
        // When timer reaches zero, advance a day
        if timeRemaining <= 0 {
            advanceDay()
            timeRemaining = dayDuration
        }
        
        // Save state occasionally (not every tick to avoid excessive writes)
        if Int(timeRemaining) % 10 == 0 {
            saveTimerState()
        }
    }
    
    // Advance the game day
    private func advanceDay() {
        daysSinceStart += 1
        
        // Call the farm manager to advance the day
        DispatchQueue.main.async {
            FarmMapManager.shared.advanceDay()
        }
    }
    
    // Save timer state to UserDefaults
    private func saveTimerState() {
        UserDefaults.standard.set(isTimerRunning, forKey: "gameTimerRunning")
        UserDefaults.standard.set(timeRemaining, forKey: "gameTimeRemaining")
        UserDefaults.standard.set(daysSinceStart, forKey: "gameDaysSinceStart")
    }
    
    // Load timer state from UserDefaults
    private func loadTimerState() {
        isTimerRunning = UserDefaults.standard.bool(forKey: "gameTimerRunning")
        timeRemaining = UserDefaults.standard.double(forKey: "gameTimeRemaining")
        if timeRemaining <= 0 || timeRemaining > dayDuration {
            timeRemaining = dayDuration
        }
        daysSinceStart = UserDefaults.standard.integer(forKey: "gameDaysSinceStart")
        
        // If timer was running when app closed, restart it
        if isTimerRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.timerTick()
            }
        }
    }
    
    // Pause timer (for game pausing)
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        saveTimerState()
    }
    
    // Resume timer (after pausing)
    func resumeTimer() {
        guard isTimerRunning else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    // Reset the timer completely (for starting a new game)
    func resetTimer() {
        // Stop any running timer
        pauseTimer()
        
        // Reset properties
        isTimerRunning = false
        timeRemaining = dayDuration
        daysSinceStart = 0
        
        // Clear saved timer state
        UserDefaults.standard.removeObject(forKey: "gameTimerRunning")
        UserDefaults.standard.removeObject(forKey: "gameTimeRemaining")
        UserDefaults.standard.removeObject(forKey: "gameDaysSinceStart")
    }
    
    // Format remaining time as a string (MM:SS)
    var formattedTimeRemaining: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Clean up when deinitializing
    deinit {
        timer?.invalidate()
    }
}
