//
//  fonUIView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-22.
//

import SwiftUI
import FirebaseFirestore
//import FirebaseCore

struct HomeView: View {
    
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    @State private var cocktails = [Cocktail]()
    @StateObject var userAcc = UserClass()
    @EnvironmentObject private var firebaseManager: FirebaseManager
    
//    private let db = Firestore.firestore()
    @State private var favoriteShown = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(bkColor)
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                VStack{
                    ScrollView() {
                        HStack{
                            Image("logo-no-background")
                                .resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).padding(20)
                        }
                        Divider()
                            .background(Color.white).padding(.horizontal, 40)
                        Grid{
                            if firebaseManager.cocktails.isEmpty {
                                Text("No cocktails yet.")
                            } else {
                                if favoriteShown == false {
                                    ForEach(firebaseManager.cocktails) { item in
                                        GridRow{
                                            CocktailCardView(cocktail: item)
                                        }
                                    }
                                } else {
                                    ForEach(cocktails.sorted(by: {$0.name < $1.name})) { item in
                                        GridRow{
                                            CocktailCardView(cocktail: item)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Home")
            .toolbar {
                if userAcc.userState == .authenticated {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if favoriteShown == false {
                                favoriteShown = true
                                collectAllFavorites()
                            } else {
                                favoriteShown = false
                            }
                        } label: {
                            if favoriteShown == false {
                                Label("Show Favorite", systemImage: "star")
                            } else {
                                Label("Show Favorite", systemImage: "star.fill")
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: getAllCocktailsModernApproach)
    }
}

extension HomeView {
    private func getAllCocktailsModernApproach() {
        firebaseManager.getAllCocktails() { }
    }
    
    func collectAllFavorites(){
        
        struct favoriteData: Codable, Hashable {
            var id, name: String
        }
        
        self.cocktails.removeAll()
        
        let collectionRef = Firestore.firestore().collection("Users").document(userAcc.uid).collection("favorites")
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                favoriteShown = false
            } else {
                for document in snapshot!.documents {
                    if let res = try? document.data(as: favoriteData.self) {
                        let matchedCocktails = firebaseManager.cocktails
                            .filter{ $0.id == res.id }
                            .map{ $0 }
                        cocktails.append(contentsOf: matchedCocktails)
                    }
                }
            }
        }
//        print(cocktails)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirebaseManager.init())
    }
}



