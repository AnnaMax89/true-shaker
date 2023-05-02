//
//  CPCTAILS.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-12.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Cocktail: Codable, Identifiable {
    
    @DocumentID var id: String?
    var name, color: String
    var ingredients: [Ingredient]
    var imageURL, cocktailDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name, color, ingredients
        case cocktailDescription = "description"
        case imageURL = "image"
    }
    
    init() {
        self.id = "UilNOZaW0qZbpfyKMW8S"
        self.name = "NAME001"
        self.color = "BLUE"
        self.ingredients = [Ingredient(name: "NAMEING001", amount: 2, unit: "p"),Ingredient(name: "NAMEING002", amount: 15, unit: "ml")]
        self.imageURL = "UilNOZaW0qZbpfyKMW8S"
        self.cocktailDescription = "BlaBlaBla"
    }
}

struct Ingredient: Codable, Hashable {
    var name: String
    var amount: Int
    var unit: String
}



enum Unit: String, Codable {
    case ml = "ml"
    case p = "p"
}

struct User2: Identifiable {
    let id = UUID().uuidString
    var favoriteCocktails: [Cocktail]
}

struct Response: Codable {
    var cocktails: [Cocktail]

    enum CodingKeys: String, CodingKey {
        case cocktails = "Cocktails"
    }
}
