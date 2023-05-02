//
//  shortCocktailView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct CocktailCardView: View {
    
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @StateObject var userAcc = UserClass()
    @State var image: UIImage? = nil
    @State private var isFavoriteFlag = Bool()
    
    var cocktail: Cocktail
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                
                //AsyncImage
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                        .padding(.bottom,20)
                        .shadow(radius: 10)
                }
                HStack {
                    NavigationLink {
                        CocktailDetailView(cocktail: cocktail)
                            .environmentObject(FirebaseManager())
                    } label: {
                        HStack {
                            Text(cocktail.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(10)
                                .background(.ultraThinMaterial)
                        }
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 15)
                    .shadow(radius: 5)
                }
            }
            .frame(height: 350)
            
            if userAcc.userState == .authenticated {
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
                        Image(systemName: "heart").imageScale(.medium)
                    } else {
                        Image(systemName: "heart.fill").imageScale(.medium)
                    }
                }
                .padding(10)
                .foregroundColor(.black)
                .background(.gray)
                .cornerRadius(70)
                .padding()
                .onAppear{
                    if userAcc.userState == .authenticated { checkIsFavorite() } else { isFavoriteFlag = false }
                }
            }
        }
        .onAppear(perform: getImgage)
    }
}

extension CocktailCardView {
    
    private func getImgage() {
        firebaseManager.getImagefrDB(cocktail: cocktail) { im in
            image = im
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
        collectionRef.whereField("id", isEqualTo: cocktail.id!).getDocuments { snapshot, error in
            
            if let error = error {
                print("Error getting documents: \(error)")
                isFavoriteFlag = false
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    isFavoriteFlag = true
                } else {
                    isFavoriteFlag = false
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

struct CocktailCardView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailCardView(cocktail: Cocktail())
            .environmentObject(FirebaseManager.init())
    }
}
