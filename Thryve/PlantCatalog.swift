import SwiftUI
import Combine

// Catalog of available plants
class PlantCatalog: ObservableObject {
    static let shared = PlantCatalog()
    
    // Published property to store the selected region
    @Published var selectedRegion: String?
    
    var allPlants: [Plant] = [
        // North America: Corn, Soybeans
        Plant(
            id: UUID(),
            name: "Corn",
            description: "Sweet golden kernels on a cob. Popular for grilling and roasting.",
            careInstructions: "Plant in blocks for pollination, water deeply, harvest when silks turn brown.",
            price: 25,
            imageName: "corn",
            growthTime: 5,
            waterNeeds: "High",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 45
        ),
        Plant(
            id: UUID(),
            name: "Soybeans",
            description: "Versatile legume used for oil, tofu, and many other food products.",
            careInstructions: "Plant in warm soil, keep consistently moist, harvest when pods are plump and green.",
            price: 20,
            imageName: "soybeans",
            growthTime: 4,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 40
        ),
        
        // South America: Wheat, Sorghum
        Plant(
            id: UUID(),
            name: "Wheat",
            description: "Cereal grain used primarily for flour production.",
            careInstructions: "Plant in well-drained soil, moderate watering, harvest when stalks turn golden.",
            price: 15,
            imageName: "wheat",
            growthTime: 4,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 30
        ),
        Plant(
            id: UUID(),
            name: "Sorghum",
            description: "Drought-resistant grain used for food, animal feed, and biofuel.",
            careInstructions: "Plant in warm soil, minimal watering needed, harvest when seeds are hard.",
            price: 18,
            imageName: "sorghum",
            growthTime: 5,
            waterNeeds: "Low",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 35
        ),
        
        // Europe: Barley, Oats
        Plant(
            id: UUID(),
            name: "Barley",
            description: "Cereal grain used in beer production, soups, and breads.",
            careInstructions: "Plant in cool weather, moderate water, harvest when stalks turn yellow.",
            price: 16,
            imageName: "barley",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 32
        ),
        Plant(
            id: UUID(),
            name: "Oats",
            description: "Nutritious grain commonly used for breakfast cereals and baked goods.",
            careInstructions: "Plant in cool soil, water regularly, harvest when panicles turn golden.",
            price: 14,
            imageName: "oats",
            growthTime: 4,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 28
        ),
        
        // Africa: Sweet Potatoes, Beans
        Plant(
            id: UUID(),
            name: "Sweet Potatoes",
            description: "Nutritious root vegetable with orange flesh and sweet flavor.",
            careInstructions: "Plant in loose, well-drained soil, moderate watering, harvest after vines yellow.",
            price: 22,
            imageName: "sweetpotato",
            growthTime: 5,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 44
        ),
        Plant(
            id: UUID(),
            name: "Beans",
            description: "Protein-rich legume with many varieties, easy to grow.",
            careInstructions: "Plant in warm soil after frost, water consistently, harvest when pods are firm.",
            price: 12,
            imageName: "beans",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 25
        ),
        
        // South Asia: Rice, Millets
        Plant(
            id: UUID(),
            name: "Rice",
            description: "Staple grain for more than half the world's population.",
            careInstructions: "Plant in flooded paddies, maintain water level, harvest when grains are golden.",
            price: 20,
            imageName: "rice",
            growthTime: 6,
            waterNeeds: "High",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 40
        ),
        Plant(
            id: UUID(),
            name: "Millets",
            description: "Small-seeded grasses grown as cereal crops, highly nutritious.",
            careInstructions: "Plant in warm soil, minimal watering needed, harvest when seeds are hard.",
            price: 15,
            imageName: "millets",
            growthTime: 3,
            waterNeeds: "Low",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 30
        ),
        
        // East Asia: Sugar Beets, Oilseeds
        Plant(
            id: UUID(),
            name: "Sugar Beets",
            description: "Root crop used for sugar production, with high sucrose content.",
            careInstructions: "Plant in deep, loose soil, consistent moisture, harvest when roots are mature.",
            price: 18,
            imageName: "sugarbeet",
            growthTime: 5,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 36
        ),
        Plant(
            id: UUID(),
            name: "Oilseeds",
            description: "Crops grown for oil extraction, including rapeseed and sesame.",
            careInstructions: "Plant in well-drained soil, moderate watering, harvest when seeds mature.",
            price: 16,
            imageName: "oilseed",
            growthTime: 4,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Grain",
            harvestValue: 32
        ),
        
        // Australia: Apples, Grapes
        Plant(
            id: UUID(),
            name: "Apples",
            description: "Sweet, crisp fruit available in many varieties.",
            careInstructions: "Plant in full sun, regular watering, prune annually, harvest when fruit is firm.",
            price: 30,
            imageName: "apple",
            growthTime: 8,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Fruit",
            harvestValue: 60
        ),
        Plant(
            id: UUID(),
            name: "Grapes",
            description: "Juicy berries grown in clusters, used for wine, juice, and eating fresh.",
            careInstructions: "Plant in well-drained soil, provide support, prune yearly, harvest when sweet.",
            price: 35,
            imageName: "grape",
            growthTime: 6,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Fruit",
            harvestValue: 70
        ),
        
        // Additional plants (available in all regions)
        Plant(
            id: UUID(),
            name: "Tomato",
            description: "Red, juicy fruit that's technically a berry. Great for salads and sauces.",
            careInstructions: "Water regularly, provide support for vines, and harvest when fully red.",
            price: 20,
            imageName: "tomato",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 40
        ),
        Plant(
            id: UUID(),
            name: "Carrot",
            description: "Orange root vegetable, sweet and crunchy. Good source of vitamins.",
            careInstructions: "Grow in loose soil, thin seedlings, keep soil consistently moist.",
            price: 15,
            imageName: "carrot",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 30
        ),
        Plant(
            id: UUID(),
            name: "Strawberry",
            description: "Sweet red berries with tiny seeds. Perfect for desserts.",
            careInstructions: "Keep soil moist but not wet, remove runners, harvest when fully red.",
            price: 30,
            imageName: "strawberry",
            growthTime: 4,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Fruit",
            harvestValue: 50
        ),
        Plant(
            id: UUID(),
            name: "Sunflower",
            description: "Tall flower with large yellow petals and edible seeds.",
            careInstructions: "Plant in well-drained soil, water regularly until established.",
            price: 15,
            imageName: "sunflower",
            growthTime: 7,
            waterNeeds: "Low",
            sunNeeds: "Full sun",
            category: "Flower",
            harvestValue: 35
        ),
        Plant(
            id: UUID(),
            name: "Basil",
            description: "Aromatic herb used in Italian and Asian cuisines.",
            careInstructions: "Pinch flowers to encourage leaf growth, harvest leaves regularly.",
            price: 10,
            imageName: "basil",
            growthTime: 2,
            waterNeeds: "Medium",
            sunNeeds: "Partial shade",
            category: "Herb",
            harvestValue: 20
        ),
        Plant(
            id: UUID(),
            name: "Watermelon",
            description: "Large refreshing fruit with sweet red flesh and black seeds.",
            careInstructions: "Needs lots of space, water deeply but infrequently.",
            price: 40,
            imageName: "watermelon",
            growthTime: 10,
            waterNeeds: "High",
            sunNeeds: "Full sun",
            category: "Fruit",
            harvestValue: 80
        ),
        Plant(
            id: UUID(),
            name: "Rose",
            description: "Classic flower known for its beauty and fragrance.",
            careInstructions: "Prune regularly, water at base, watch for pests.",
            price: 35,
            imageName: "rose",
            growthTime: 8,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Flower",
            harvestValue: 60
        )
    ]
    
    // Dictionary to map regions to their plants
    private let regionToPlants: [String: [String]] = [
        "North America": ["Corn", "Soybeans"],
        "South America": ["Wheat", "Sorghum"],
        "Europe": ["Barley", "Oats"],
        "Africa": ["Sweet Potatoes", "Beans"],
        "South Asia": ["Rice", "Millets"],
        "East Asia": ["Sugar Beets", "Oilseeds"],
        "Australia": ["Apples", "Grapes"]
    ]
    
    // Common plants available in all regions
    private let commonPlants = [
        "Tomato", "Carrot", "Strawberry", "Sunflower",
        "Basil", "Watermelon", "Rose"
    ]
    
    // Set the selected region
    func setRegion(_ region: String) {
        selectedRegion = region
        // Notify observers that the region has changed
        objectWillChange.send()
    }
    
    // Get the current selected region
    func getSelectedRegion() -> String? {
        return selectedRegion
    }
    
    // Get plants for the selected region
    func getPlantsForSelectedRegion() -> [Plant] {
        guard let region = selectedRegion else {
            return allPlants // Return all plants if no region is selected
        }
        
        // Get the specific plants for this region
        let regionSpecificPlantNames = regionToPlants[region] ?? []
        
        // Filter plants based on region
        return allPlants.filter { plant in
            // Include plant if it's specific to the region or if it's a common plant
            return regionSpecificPlantNames.contains(plant.name) || commonPlants.contains(plant.name)
        }
    }
    
    // Get plant by ID
    func getPlant(id: UUID) -> Plant? {
        return allPlants.first { $0.id == id }
    }
    
    // Get plant by name
    func getPlant(name: String) -> Plant? {
        return allPlants.first { $0.name == name }
    }
    
    // Get plants by category
    func getPlants(category: String) -> [Plant] {
        return allPlants.filter { $0.category == category }
    }
    
    private init() {}
}
