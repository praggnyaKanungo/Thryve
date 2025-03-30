import SwiftUI

class AppStateManager {
    static let shared = AppStateManager()
    
    private init() {}
    
    func resetAppState() {
        FarmMapManager.shared.resetFarm()
        
        InventoryManager.shared.clearInventory()
        
        GameCalendar.shared.resetCalendar()
        
        CoinsManager.shared.resetCoins()
        
        stopAndResetGameTimer()
        
        clearAllGameData()
    }
    
    private func stopAndResetGameTimer() {
        GameTimerManager.shared.pauseTimer()
        
        UserDefaults.standard.removeObject(forKey: "gameTimerRunning")
        UserDefaults.standard.removeObject(forKey: "gameTimeRemaining")
        UserDefaults.standard.removeObject(forKey: "gameDaysSinceStart")
        
        GameTimerManager.shared.isTimerRunning = false
        GameTimerManager.shared.timeRemaining = 180 
        GameTimerManager.shared.daysSinceStart = 0
    }
    
    private func clearAllGameData() {
        UserDefaults.standard.removeObject(forKey: "farmPlots")
        UserDefaults.standard.removeObject(forKey: "gameDay")
        UserDefaults.standard.removeObject(forKey: "gameSeason")
        UserDefaults.standard.removeObject(forKey: "gameWeather")
        UserDefaults.standard.removeObject(forKey: "totalSuccessfulHarvests")
        UserDefaults.standard.removeObject(forKey: "donations")
    }
}
