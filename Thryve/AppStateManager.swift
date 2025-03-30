import SwiftUI

// This class will manage the app's state resets
class AppStateManager {
    static let shared = AppStateManager()
    
    private init() {}
    
    // Reset all app data when starting a new farm
    func resetAppState() {
        // Reset farm plots
        FarmMapManager.shared.resetFarm()
        
        // Reset inventory
        InventoryManager.shared.clearInventory()
        
        // Reset game calendar to day 1
        GameCalendar.shared.resetCalendar()
        
        // Reset coins (optional - you may want to keep this persistent)
        CoinsManager.shared.resetCoins()
        
        // Stop and reset game timer
        stopAndResetGameTimer()
        
        // Clear other UserDefaults as needed
        clearAllGameData()
    }
    
    // Stop and reset the game timer
    private func stopAndResetGameTimer() {
        // Stop any running timer
        GameTimerManager.shared.pauseTimer()
        
        // Reset timer state in UserDefaults
        UserDefaults.standard.removeObject(forKey: "gameTimerRunning")
        UserDefaults.standard.removeObject(forKey: "gameTimeRemaining")
        UserDefaults.standard.removeObject(forKey: "gameDaysSinceStart")
        
        // Update timer manager properties
        GameTimerManager.shared.isTimerRunning = false
        GameTimerManager.shared.timeRemaining = 180 // 3 minutes default
        GameTimerManager.shared.daysSinceStart = 0
    }
    
    // Clear all game-related UserDefaults
    private func clearAllGameData() {
        // Farm data
        UserDefaults.standard.removeObject(forKey: "farmPlots")
        
        // Game calendar data
        UserDefaults.standard.removeObject(forKey: "gameDay")
        UserDefaults.standard.removeObject(forKey: "gameSeason")
        UserDefaults.standard.removeObject(forKey: "gameWeather")
        
        // Donation data
        UserDefaults.standard.removeObject(forKey: "totalSuccessfulHarvests")
        UserDefaults.standard.removeObject(forKey: "donations")
    }
}
