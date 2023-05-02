//
//  PartyView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-28.
//

import SwiftUI
import FirebaseFirestore

struct CocktailDetailView: View {
    
    let cocktail: Cocktail
    
    var colors : [String:UIColor] = [
        "": UIColor.orange,
        "none": UIColor.orange,
        "white": UIColor.white,
        "black": UIColor.black,
        "gray": UIColor.gray,
        "pink": UIColor.systemPink,
        "red": UIColor.red,
        "yellow":UIColor.yellow,
        "blue": UIColor.blue,
        "green": UIColor.green]
    
    @StateObject var userAcc = UserClass()
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    @State private var midColor = UIColor.orange
    @State private var isFavoriteFlag = Bool()
    @State var image = UIImage()
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    init(cocktail: Cocktail) {
        
        self.cocktail = cocktail
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        //        NavigationView {
        ZStack{
            if let midColor = colors[cocktail.color.lowercased()] {
                let color = Gradient(colors: [Color(midColor).opacity(0.5),
                                              bkColor,
                                              bkColor,bkColor,bkColor2])
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading)
                .ignoresSafeArea(.all, edges: .all)
            } else {
                let color = Gradient(colors: [bkColor])
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
            }
            
            VStack{
                Spacer()
                Image("logo-no-background")
                    .resizable().aspectRatio(contentMode: .fit).padding(.all, 20.0).opacity(0.4)
            }
            
            VStack{
                ScrollView(.vertical, showsIndicators: true) {
                    //AsyncImage
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .cornerRadius(10)
                            .padding()
                            .shadow(radius: 10)
                    }
                    
                    Text("Ingredient List")
                        .font(.title2)
                        .foregroundColor(.white)
                    ForEach(cocktail.ingredients, id: \.self) { ingredient in
                        HStack{
                            Text(ingredient.name)
                                .foregroundColor(.white)
                                .padding(.leading)
                            Spacer()
                            Text("\(ingredient.amount) \(ingredient.unit)")
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                    }
                    
                    Divider()
                    
                    Text("Description and Recipe")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(cocktail.cocktailDescription)
                        .foregroundColor(.white)
                   
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .navigationTitle(cocktail.name)
        .toolbar {
            if userAcc.userState == .authenticated {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isFavoriteFlag == false {
                            isFavoriteFlag = true
                            saveAsFavorite()
                        } else {
                            isFavoriteFlag = false
                            removeFromFavorite()
                        }
                    } label: {
                        if isFavoriteFlag == false {
                            Label("Show Favorite", systemImage: "heart")
                        } else {
                            Label("Show Favorite", systemImage: "heart.fill")
                        }
                    }
                    .onAppear{
                        checkIsFavorite()
                    }
                }
            }
        }
        .onAppear{
            getImgage()
        }
    }
}

extension CocktailDetailView {
    
    private func getImgage() {
        firebaseManager.getImagefrDB(cocktail: cocktail) { im in
            image = im!
        }
    }
    
    func saveAsFavorite() {
        if isFavoriteFlag {
            let collectionRef = Firestore.firestore().collection("Users").document(userAcc.uid).collection("favorites")
            collectionRef.document().setData(["id": cocktail.id!, "name": cocktail.name]){ error in
                if let error = error {
                    print("DEBUG: Failed to upload try with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func checkIsFavorite(){
        
        let collectionRef = Firestore.firestore().collection("Users").document(userAcc.uid).collection("favorites")
        collectionRef.whereField("id", isEqualTo: cocktail.id!).getDocuments() { snapshot, error in
            
            if let error = error {
                print("Error getting documents: \(error)")
                self.isFavoriteFlag = false
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.isFavoriteFlag = true
//                    print("isFavoriteFlag (true) is \(isFavoriteFlag)")
                } else {
                    self.isFavoriteFlag = false
//                    print("isFavoriteFlag (false) is \(isFavoriteFlag)")
                }
            }
        }
    }
    
    func removeFromFavorite() {
        let collectionRef = Firestore.firestore().collection("Users").document(userAcc.uid).collection("favorites")
        collectionRef.whereField("id", isEqualTo: cocktail.id!).getDocuments() { snapshot, error in
            if let error = error {
                print("Error deleting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                   document.reference.delete()
                 }
            }
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailView(cocktail: Cocktail())
            .environmentObject(FirebaseManager.init())
    }
}
