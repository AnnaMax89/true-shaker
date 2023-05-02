//
//  PartyView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-28.
//

import SwiftUI
import FirebaseFirestore

struct PartyView: View {
    
    @State private var personQuantity = 0
    @State private var cocktails: [Cocktail] = []
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    @State private var selectedCocktails = [Cocktail]()
    
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
                VStack() {
                    ScrollView {
                        HStack(){
                            Image("logo-no-background")
                                .resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).padding(20)
                        }
                        
                        HStack{
                            Text("Persons")
                                .padding(.leading, 30)
                            Spacer()
                            
                            Button {
                                personQuantity = personQuantity + 1
                            } label:{
                                Image(systemName: "plus")
                            }
                            .padding(.trailing, 10)
                            
                            Text("\(personQuantity)")
                            
                            Button {
                                if personQuantity >= 1 {
                                    personQuantity = personQuantity - 1
                                }
                            } label:{
                                Image(systemName: "minus")
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 40)
                            
                        }
                        .foregroundColor(.white)
                        .font(.title)
                        
                        Spacer()
                        
                        HStack(){
                            Text("Choose cocktails:")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(30)
                            Spacer()
                        }
                        
                        if firebaseManager.cocktails.isEmpty {
                            Text("No cocktails yet.")
                        } else {
                            ForEach(firebaseManager.cocktails.sorted(by: { $0.name < $1.name }), id: \.name) { item in
                                HStack{
                                    if(selectedCocktails.contains(where: { $0.name == item.name }))
                                    {
                                        Text(item.name)
                                            .padding(.leading, 20)
                                        
                                        Spacer()
                                        Image(systemName: "plus.diamond.fill")
                                            .foregroundColor(.orange).opacity(70)
                                            .padding(.trailing, 40)
                                            .onTapGesture {
                                                selectedCocktails.removeAll(where: { $0.name == item.name })
                                                
//                                            filteredCocktails = doFilterCocktails()
                                                
                                            }
                                    } else {
                                        
                                        Text(item.name)
                                            .padding(.leading, 20)
                                        Spacer()
                                        Image(systemName: "plus.diamond")
                                            .padding(.trailing, 40)
                                            .onTapGesture {
                                                selectedCocktails.append(item)
//                                            filteredCocktails = doFilterCocktails()
                                            }
                                    }
                                }
                                .padding(.bottom)
                                .foregroundColor(.white)
                                .font(.title)

                            }
                        }
                    }
                    .onAppear(perform: getAllCocktails)
                    
                    NavigationLink {
                            PartyResultView(foundCocktails: selectedCocktails, persons: personQuantity)
                        
                    } label: {
                        HStack {
                            Label("SHOPPING LIST", systemImage:"party.popper")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                                .padding(.horizontal)
                                .padding(.bottom,20)
                            
                        }
                    }
                }
            }
            .navigationTitle("Party Adviser")
        }
    }
}

extension PartyView {
    
    func getAllCocktails() {
        firebaseManager.getAllCocktails(){
            
        }
    }
}

struct PartyView_Previews: PreviewProvider {
    static var previews: some View {
        PartyView()
    }
}
