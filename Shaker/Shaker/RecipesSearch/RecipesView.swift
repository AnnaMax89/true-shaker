//
//  2View.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-28.
//

import SwiftUI
import FirebaseFirestore

struct RecipesView: View {
    
    @EnvironmentObject var userAcc: UserClass
    @State var ingredients = [Ingredient]()
    @State var filtredIngredients = [Ingredient]()
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    @State var cocktails: [Cocktail] = []
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    @State var selectedIngredients = [Ingredient]()
    @State var filteredCocktails = [Cocktail]()
    @State var allColors = [String]()
    @State var selectedColors = [String]()
    @State private var searchText = ""
    
    @State private var ingredientsShown = false
    @State private var colorsShown = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(bkColor)
        
//        UISearchBar.appearance().backgroundColor = UIColor.orange
        UISearchBar.appearance().tintColor = UIColor.white
        UISearchBar.appearance().barTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                
                VStack() {
                    ScrollView() {
                        HStack{
                            Image("logo-no-background")
                                .resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).padding(20)
                        }
                        
                        Divider()
                            .background(Color.white).padding(.horizontal, 50)
                        
                        //Cocktail filter
                        HStack{
                            Button {
                                if ingredientsShown == false {
                                    ingredientsShown = true
                                    
                                } else {
                                    ingredientsShown = false
                                    //Show all
                                }
                            } label: {
                                if ingredientsShown == false {
                                    Label("Ingredients", systemImage: "arrowtriangle.down.circle").font(.largeTitle)
                                } else {
                                    Label("Ingredients", systemImage: "arrowtriangle.up.circle").font(.largeTitle)
                                }
                            }
                            .padding(.leading, 30.0)
                            
                            Spacer()
                        }
                        if ingredientsShown == true {
                            Spacer()
                            
                            ForEach(filtredIngredients.sorted(by: { $0.name < $1.name }), id: \.name) { itemIng in
                                HStack{
                                    if(selectedIngredients.contains(itemIng))
                                    {
                                        Text(itemIng.name)
                                            .padding(.bottom,5)
                                        Spacer()
                                        Image(systemName: "plus.diamond.fill")
                                            .padding(.trailing, 20)
                                            .foregroundColor(.orange).opacity(70)
                                            .onTapGesture {
                                                selectedIngredients.removeAll(where: { $0.name == itemIng.name })
                                                filteredCocktails = doFilterCocktails()
                                            }
                                    } else {
                                        Text(itemIng.name)
                                            .padding(.bottom,5)
                                        Spacer()
                                        Image(systemName: "plus.diamond")
                                            .padding(.trailing, 20)
                                            .onTapGesture {
                                                selectedIngredients.append(itemIng)
                                                filteredCocktails = doFilterCocktails()
                                            }
                                    }
                                }
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.leading)
                            }
                        }
                        
                        //Color filter
                        HStack{
                            Button {
                                if colorsShown == false {
                                    colorsShown = true
                                } else {
                                    colorsShown = false
                                    //Show all
                                }
                            } label: {
                                if colorsShown == false {
                                    Label("Colors", systemImage: "arrowtriangle.down.circle").font(.largeTitle)
                                } else {
                                    Label("Colors", systemImage: "arrowtriangle.up.circle").font(.largeTitle)
                                }
                            }
                            .padding(.leading, 30.0)
                            .padding(.top, 5)
                            
                            Spacer()
                        }
                        if colorsShown == true {
                            Spacer()
                            
                            //Color filter
                            if !allColors.isEmpty {
                                let strings = allColors.sorted()
                                ForEach(strings, id: \.self) { itemC in
                                    HStack{
                                        if(selectedColors.contains(itemC))
                                        {
                                            Text(itemC)
                                                .padding(.bottom,5)
                                            Spacer()
                                            Image(systemName: "plus.diamond.fill")
                                                .foregroundColor(.orange).opacity(70)
                                                .padding(.trailing, 20)
                                                .onTapGesture {
                                                    selectedColors.removeAll(where: { $0 == itemC })
                                                    filteredCocktails = doFilterCocktails()
                                                }
                                        } else {
                                            Text(itemC)
                                                .padding(.bottom,5)
                                            Spacer()

                                            Image(systemName: "plus.diamond")
                                                .padding(.trailing, 20)
                                                .onTapGesture {
                                                    selectedColors.append(itemC)
                                                    filteredCocktails = doFilterCocktails()
                                                }
                                        }
                                    }
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    NavigationLink {
                        SearchResultView(foundCocktails: filteredCocktails)
                    } label: {
                        HStack {
                            Label("SEARCH", systemImage:"magnifyingglass.circle.fill")
                                .font(.largeTitle)
                            //                            .frame(width: 75, height: 75)
                                .foregroundColor(.orange)
                                .padding(.horizontal)
                                .padding(.bottom,20)
                            
                        }
                    }
                }
                .navigationTitle("Recipes")
            }
        }
        .onAppear(perform: getAllCocktailsModernApproach)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)).foregroundColor(.white)
        .onChange(of: searchText) { searchText in
            if !searchText.isEmpty {
                filtredIngredients = ingredients.filter { $0.name.contains(searchText) }
            } else {
                filtredIngredients = ingredients
            }
        }
    }
}

extension RecipesView {
    
    func getAllCocktailsModernApproach() {
        firebaseManager.getAllCocktails() {
            getAllIngredients()
            getAllColors()
            filtredIngredients = ingredients
        }
    }
    
    func getAllIngredients() {
        ingredients = [Ingredient]()
        
        for item in firebaseManager.cocktails {
            for itemIng in item.ingredients {
                var ingredientAlreadyExist = false
                
                for existIng in ingredients {
                    if(existIng.name == itemIng.name)
                    {
                        ingredientAlreadyExist = true
                    }
                }
                
                if(ingredientAlreadyExist == false)
                {
                    ingredients.append(itemIng)
                }
            }
        }
    }
    
    func getAllColors() {
        allColors = [String]()
        
        for item in firebaseManager.cocktails {
            //            for itemC in item.colors {
            var colorAlreadyExist = false
            let itemC = item.color
            
            if !itemC.isEmpty {
                for existC in allColors {
                    if(existC == itemC)
                    {
                        colorAlreadyExist = true
                    }
                }
                if(colorAlreadyExist == false)
                {
                    allColors.append(itemC)
                }
                
            }
        }
    }
    
    func doFilterCocktails() -> [Cocktail]{
        
        filteredCocktails = [Cocktail]()
        
        let newfilteredCocktails = firebaseManager.cocktails.filter { cocktail in
            
            if (!selectedIngredients.isEmpty && selectedColors.isEmpty) {
                for itemIng in cocktail.ingredients {
                    if(selectedIngredients.filter( { $0.name == itemIng.name } ).count > 0)
                    {
                        var cocktailAlreadyExist = false
                        for existCocktail in filteredCocktails {
                            if existCocktail.name == cocktail.name {
                                cocktailAlreadyExist = true
                            }
                        }
                        if(cocktailAlreadyExist == false)
                        {
                            return true
                        }
                    }
                    
                }
            }
            if (selectedIngredients.isEmpty && !selectedColors.isEmpty) {
                    if(selectedColors.filter( { $0.self == cocktail.color } ).count > 0)
                    {
                        var cocktailAlreadyExist = false
                        
                        for existCocktail in filteredCocktails {
                            if existCocktail.name == cocktail.name {
                                cocktailAlreadyExist = true
                            }
                        }
                        if(cocktailAlreadyExist == false)
                        {
                            return true
                        }
                    }
            }
            if (!selectedIngredients.isEmpty && !selectedColors.isEmpty) {
                for itemIng in cocktail.ingredients {
                    if (selectedColors.filter( { $0.self == cocktail.color } ).count > 0) &&
                        (selectedIngredients.filter( { $0.name == itemIng.name } ).count > 0) {
                        
                        var cocktailAlreadyExist = false
                        for existCocktail in filteredCocktails {
                            if existCocktail.name == cocktail.name {
                                cocktailAlreadyExist = true
                            }
                        }
                        if(cocktailAlreadyExist == false)
                        {
                            return true
                        }
                    }
                    
                }
            }
            return false
        }
        return newfilteredCocktails
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
