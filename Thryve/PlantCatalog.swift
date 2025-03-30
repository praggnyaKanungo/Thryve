import SwiftUI

// Catalog of available plants
class PlantCatalog {
    static let shared = PlantCatalog()
    
    var allPlants: [Plant] = [
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
            name: "Corn",
            description: "Sweet golden kernels on a cob. Popular for grilling and roasting.",
            careInstructions: "Plant in blocks for pollination, water deeply, harvest when silks turn brown.",
            price: 25,
            imageName: "corn",
            growthTime: 5,
            waterNeeds: "High",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 45
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
