//
//  Cocktailsextentions.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-15.
//

import Foundation

extension Cocktail {
  func toJson() -> Data? {
    do {
      let data = try JSONEncoder().encode(self)
      return data
    } catch {
      print("Failed to encode Cocktail.")
      return nil
    }
  }
  
  static func fromJson(data: Data) -> Cocktail? {
    do {
      let decodedCocktail = try JSONDecoder().decode(Cocktail.self, from: data)
      return decodedCocktail
    } catch {
      print("Failed to decode Cocktail")
      return nil
    }
  }
}
