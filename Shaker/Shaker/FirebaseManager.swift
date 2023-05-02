//
//  testView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-18.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
    
class FirebaseManager: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    @Published var cache = NSCache<NSString, UIImage>()
    
    func getAllCocktails(completion: @escaping () -> Void) {
        
        let collectionRef = Firestore.firestore().collection("Cocktails")
        collectionRef.getDocuments { snapshot, error in
            if let error {
                print("Error when getting Cocktails documents. Error: \(error.localizedDescription)")
                return
            }
          
            if let documents = snapshot?.documents {
                let fetchedCocktails = documents.compactMap { document in
                    let data = try? document.data(as: Cocktail.self)
                    return data
            }
            
            DispatchQueue.main.async {
              self.cocktails = fetchedCocktails.sorted(by: {$0.name < $1.name})
                completion()
            }
          }
        }
    }
    
    func getImagefrDB(cocktail: Cocktail, completion: @escaping(UIImage?) -> Void) {
        
        //if let image = cache.object(forKey: "image") {
        if let image = cache.object(forKey: cocktail.imageURL as NSString) {
//            print("Using cache")
            completion(image)
            return
        }
        
        let imageRef = Storage.storage().reference().child("Cocktails/\(cocktail.imageURL).jpg")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
//                print(error!.localizedDescription)
                let image = UIImage(named: "no-image")!
                completion (image)
                return
            } else {
                guard let image = UIImage(data: data!) else {
                    let image = UIImage(named: "no-image")!
                    completion (image)
                    return
                }
//                print("Fetching data")
                self.cache.setObject(image, forKey: cocktail.imageURL as NSString)
                completion(image)
            }
        }
    }
        
//    The next functions NOT in use yet
    
//    func saveAsFavorite() {

//    func checkIsFavorite() {

//    func removefromFavorite() {
        
}
