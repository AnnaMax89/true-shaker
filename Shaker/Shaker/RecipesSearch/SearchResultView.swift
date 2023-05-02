//
//  fonUIView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-22.
//

import SwiftUI
//import FirebaseFirestore
//import FirebaseCore

struct SearchResultView: View {
    
    @State var foundCocktails: [Cocktail]
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    
    init(foundCocktails: [Cocktail]) {
        
        self.foundCocktails = foundCocktails
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                
                VStack{
                    HStack{
                        Image("logo-no-background")
                            .resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).padding(20)
                    }
                    List {
                        ForEach(foundCocktails) { item in
                            HStack {
                                NavigationLink {
                                    CocktailDetailView(cocktail: item)
                                } label: {
                                    HStack {
                                        Text(item.name)
                                            .font(.headline)
                                    }
                                }
                            }
                        }
                    }
                    .opacity(0.6)
                    .scrollContentBackground(.hidden)
                    .padding()
                }
                .navigationTitle("Search Result")
//                .background(bkColor)
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(foundCocktails: [Cocktail]())
    }
}



