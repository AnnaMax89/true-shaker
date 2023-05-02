//
//  PartyResultView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-29.
//

import SwiftUI

struct PartyResultView: View {
    
    @State var foundCocktails: [Cocktail]
    @State var persons: Int
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    
    init(foundCocktails: [Cocktail], persons: Int) {
        self.foundCocktails = foundCocktails
        self.persons = persons
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    Grid{
                        Text("Ingredient Shopping List for \(persons) persons")
                            .font(.title.bold())
                            .padding(.vertical, 20)
                            .foregroundColor(Color.white)
                        
                        if !sortIngredients().isEmpty {
                            
                            ForEach(sortIngredients(), id: \.self) { ingredient in
                                GridRow{
                                    Text(ingredient.name)
                                        .gridColumnAlignment(.leading)
                                        .multilineTextAlignment(.leading)
                                        .scaledToFill()
                                        .padding(.leading, 10)
                                    let sum = ingredient.amount * persons
                                    Text(String(sum))
                                    Text(ingredient.unit)
                                        .gridColumnAlignment(.trailing)
                                }
                                .font(.title2)
                                .foregroundColor(Color.white)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Shopping List")
        }
        
    }
}

extension PartyResultView {
    
    func sortIngredients() -> [Ingredient] {
        
        var ingredients = [Ingredient]()
        
            
        for cocktail in foundCocktails {
            for itemIng in cocktail.ingredients {
                var ingredientAlreadyExist = false
                
                
                for (index, existIng) in ingredients.enumerated() {
                    if(existIng.name == itemIng.name)
                    {
                        ingredientAlreadyExist = true
                        ingredients[index].amount = ingredients[index].amount + itemIng.amount
                    }
                }
                
                if(ingredientAlreadyExist == false)
                {
                    ingredients.append(itemIng)
                }
                
            }
        }
        
        return ingredients.sorted(by: { $0.name < $1.name })
    }
}

struct PartyResultView_Previews: PreviewProvider {
    static var previews: some View {
        PartyResultView(foundCocktails: [Cocktail](), persons: 3)
    }
}
