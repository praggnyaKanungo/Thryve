import SwiftUI

enum WeatherType: String, Codable, CaseIterable {
    case sunny
    case hot
    case rainy
    case storm
    
    var growthMultiplier: Double {
        switch self {
        case .sunny: return 1.0  
        case .hot: return 0.8    
        case .rainy: return 1.3 
        case .storm: return 0.5 
        }
    }
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .hot: return "sun.max.fill"
        case .rainy: return "cloud.rain.fill"
        case .storm: return "cloud.bolt.rain.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .sunny: return .yellow
        case .hot: return .orange
        case .rainy: return .blue
        case .storm: return .purple
        }
    }
    
    static func random() -> WeatherType {
        return WeatherType.allCases.randomElement() ?? .sunny
    }
}

enum Season: String, Codable, CaseIterable {
    case spring
    case summer
    case fall
    case winter
    
    var growthMultiplier: Double {
        switch self {
        case .spring: return 1.2
        case .summer: return 1.5
        case .fall: return 1.0
        case .winter: return 0.7
        }
    }
    
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .fall: return "leaf.arrow.triangle.circlepath"
        case .winter: return "snow"
        }
    }
    
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .fall: return .orange
        case .winter: return .blue
        }
    }
    
    
    var next: Season {
        switch self {
        case .spring: return .summer
        case .summer: return .fall
        case .fall: return .winter
        case .winter: return .spring
        }
    }
}

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
    
    private init() {
        loadCalendarData()
    }
    
    private func saveCalendarData() {
        UserDefaults.standard.set(currentDay, forKey: "gameDay")
        UserDefaults.standard.set(currentSeason.rawValue, forKey: "gameSeason")
        UserDefaults.standard.set(currentWeather.rawValue, forKey: "gameWeather")
    }
    
    private func loadCalendarData() {
        if let day = UserDefaults.standard.object(forKey: "gameDay") as? Int {
            currentDay = day
        } else {
            currentDay = 1
        }
        
        if let seasonRaw = UserDefaults.standard.string(forKey: "gameSeason"),
           let season = Season(rawValue: seasonRaw) {
            currentSeason = season
        } else {
            currentSeason = .spring
        }
        
        if let weatherRaw = UserDefaults.standard.string(forKey: "gameWeather"),
           let weather = WeatherType(rawValue: weatherRaw) {
            currentWeather = weather
        } else {
            currentWeather = .sunny
        }
    }
    
    func advanceDay() {
        currentDay += 1
        
        if Double.random(in: 0...1) < 0.3 {
            currentWeather = WeatherType.random()
        }
        
        if currentDay > daysInSeason {
            currentDay = 1
            currentSeason = currentSeason.next
        }
    }
    
    var growthMultiplier: Double {
        return currentWeather.growthMultiplier * currentSeason.growthMultiplier
    }
    
    func calculateDailyGrowth(for plant: Plant) -> Double {
        let baseGrowth = 1.0 / Double(plant.growthTime)
        
        let adjustedGrowth = baseGrowth * growthMultiplier
        
        var plantSpecificMultiplier = 1.0
        
        if plant.waterNeeds == "High" && currentWeather == .rainy {
            plantSpecificMultiplier *= 1.2 
        } else if plant.waterNeeds == "Low" && currentWeather == .hot {
            plantSpecificMultiplier *= 1.1 
        }
        
        return adjustedGrowth * plantSpecificMultiplier
    }
    
    func resetCalendar() {
        currentDay = 1
        currentSeason = .spring
        currentWeather = .sunny
        saveCalendarData()
    }
}
