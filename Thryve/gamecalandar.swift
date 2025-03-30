import SwiftUI

// Weather types
enum WeatherType: String, Codable, CaseIterable {
    case sunny
    case hot
    case rainy
    case storm
    
    // Weather effect on growth
    var growthMultiplier: Double {
        switch self {
        case .sunny: return 1.0  // Normal growth
        case .hot: return 0.8    // Slower growth due to heat stress
        case .rainy: return 1.3  // Faster growth due to abundant water
        case .storm: return 0.5  // Much slower growth due to harsh conditions
        }
    }
    
    // Weather icon
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .hot: return "sun.max.fill"
        case .rainy: return "cloud.rain.fill"
        case .storm: return "cloud.bolt.rain.fill"
        }
    }
    
    // Weather color
    var color: Color {
        switch self {
        case .sunny: return .yellow
        case .hot: return .orange
        case .rainy: return .blue
        case .storm: return .purple
        }
    }
    
    // Random weather generator
    static func random() -> WeatherType {
        return WeatherType.allCases.randomElement() ?? .sunny
    }
}

// Season types
enum Season: String, Codable, CaseIterable {
    case spring
    case summer
    case fall
    case winter
    
    // Season effect on plants
    var growthMultiplier: Double {
        switch self {
        case .spring: return 1.2
        case .summer: return 1.5
        case .fall: return 1.0
        case .winter: return 0.7
        }
    }
    
    // Season icon
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .fall: return "leaf.arrow.triangle.circlepath"
        case .winter: return "snow"
        }
    }
    
    // Season color
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .fall: return .orange
        case .winter: return .blue
        }
    }
    
    // Next season
    var next: Season {
        switch self {
        case .spring: return .summer
        case .summer: return .fall
        case .fall: return .winter
        case .winter: return .spring
        }
    }
}

// Game calendar
class GameCalendar: ObservableObject {
    static let shared = GameCalendar()
    
    @Published var currentDay: Int = 1 {
        didSet {
            saveCalendarData()
        }
    }
    
    @Published var currentSeason: Season = .spring {
        didSet {
            saveCalendarData()
        }
    }
    
    @Published var currentWeather: WeatherType = .sunny {
        didSet {
            saveCalendarData()
        }
    }
    
    let daysInSeason: Int = 28
    
    // Initialize with saved calendar data if available
    private init() {
        loadCalendarData()
    }
    
    // Save calendar data
    private func saveCalendarData() {
        UserDefaults.standard.set(currentDay, forKey: "gameDay")
        UserDefaults.standard.set(currentSeason.rawValue, forKey: "gameSeason")
        UserDefaults.standard.set(currentWeather.rawValue, forKey: "gameWeather")
    }
    
    // Load calendar data
    private func loadCalendarData() {
        if let day = UserDefaults.standard.object(forKey: "gameDay") as? Int {
            currentDay = day
        } else {
            // Default to day 1 if no saved data
            currentDay = 1
        }
        
        if let seasonRaw = UserDefaults.standard.string(forKey: "gameSeason"),
           let season = Season(rawValue: seasonRaw) {
            currentSeason = season
        } else {
            // Default to spring if no saved data
            currentSeason = .spring
        }
        
        if let weatherRaw = UserDefaults.standard.string(forKey: "gameWeather"),
           let weather = WeatherType(rawValue: weatherRaw) {
            currentWeather = weather
        } else {
            // Default to sunny if no saved data
            currentWeather = .sunny
        }
    }
    
    // Advance to next day
    func advanceDay() {
        currentDay += 1
        
        // Random chance to change weather
        if Double.random(in: 0...1) < 0.3 {
            currentWeather = WeatherType.random()
        }
        
        // Check if season changes
        if currentDay > daysInSeason {
            currentDay = 1
            currentSeason = currentSeason.next
        }
    }
    
    // Get combined growth multiplier from current weather and season
    var growthMultiplier: Double {
        return currentWeather.growthMultiplier * currentSeason.growthMultiplier
    }
    
    // For plants, calculate how much it will grow today based on its properties
    func calculateDailyGrowth(for plant: Plant) -> Double {
        // Base growth rate is 1/growthTime (e.g., 1/3 = 0.333 for a 3-day plant)
        let baseGrowth = 1.0 / Double(plant.growthTime)
        
        // Apply weather and season effects
        let adjustedGrowth = baseGrowth * growthMultiplier
        
        // Additional plant-specific adjustments
        var plantSpecificMultiplier = 1.0
        
        // Plants respond differently to weather
        if plant.waterNeeds == "High" && currentWeather == .rainy {
            plantSpecificMultiplier *= 1.2 // Water-loving plants grow better in rain
        } else if plant.waterNeeds == "Low" && currentWeather == .hot {
            plantSpecificMultiplier *= 1.1 // Drought-resistant plants handle heat better
        }
        
        // Final growth calculation
        return adjustedGrowth * plantSpecificMultiplier
    }
    
    // Reset calendar (for testing or starting a new game)
    func resetCalendar() {
        currentDay = 1
        currentSeason = .spring
        currentWeather = .sunny
        saveCalendarData()
    }
}
