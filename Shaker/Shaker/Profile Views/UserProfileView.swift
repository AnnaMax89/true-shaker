//
//  RegistrationView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-24.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAuth

private enum FocusableField: Hashable {
  case email
  case password
}

struct UserProfileView: View {
    @AppStorage("showApprove") var showApprove = true
    
    @EnvironmentObject var userAcc: UserClass
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    @State private var confirmationShown = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(bkColor)
    }

    
    var body: some View {
        NavigationView{
            ZStack{
                let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                
                LinearGradient(gradient: color,
                               startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 200 , height: 200)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .clipped()
                            .padding(4)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        Spacer()
                    }
                    .padding()
                    
//                    Button(action: {}) {
//                        Text("edit")
//                    }
                    
                    Spacer()
                    
                    Section("Your Email:") {
                        Text(userAcc.email).font(.title2)
                    }.font(.title.bold())
                    
                    Spacer()
                    Divider().overlay(.white).padding()
                    Spacer()
                    
                    Button("Sign out", action: {
                        showApprove = true
                        userAcc.signOut()
                    })
                    .font(.title2)
                    .padding()
                    
//                    Button(action: { print("Reset Pass") }) {
//                        HStack {
//                            Spacer()
//                            Text("Reset Password (not working)")
//                            Spacer()
//                        }
//                    }
//                    .padding()
                    
                    Button("Remove Account") {
                        confirmationShown = true
                    }
                    .font(.title2)
                    .confirmationDialog("Are you sure?",
                                        isPresented: $confirmationShown) {
                        Button("Yes", role: .destructive) {
                            userAcc.deleteAccount()
                        }
                    } message: {
                        Text("You cannot undo this action")
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Profile")
        .foregroundColor(.white)
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserProfileView()
                .environmentObject(UserClass())
        }
    }
}
