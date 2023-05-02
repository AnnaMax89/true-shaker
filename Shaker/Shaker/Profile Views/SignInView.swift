//
//  Entre.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
//

import SwiftUI

private enum FocusableField: Hashable {
  case email
  case password
}

struct SignIn: View {

    @EnvironmentObject var userAcc: UserClass
    
    @State var useremail = ""
    @State var userpass = ""
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    
    let butColor = Color(UIColor(named: "ButtonColor")!)
    let navigationBarAppearance = UINavigationBarAppearance()

    init(){
//        UITabBar.appearance().barTintColor  = UIColor.white
//        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        

//        navigationItem.standardAppearance = navigationBarAppearance
//        navigationItem.compactAppearance = navigationBarAppearance
//        navigationItem.scrollEdgeAppearance = navigationBarAppearance

    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing: 15)
            {
                Spacer()
                Image("logo-no-background").resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).aspectRatio(contentMode: .fit).padding(20)
                Spacer()
                
                Text("Enter E-mail").font(.title2).foregroundColor(.white).padding(.leading)
                TextField("E-mail",text: $userAcc.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.orange)
                    .opacity(0.8)
                    .cornerRadius(10)

                Text("Enter password").font(.title2).foregroundColor(.white).padding([.top, .leading])
                SecureField("Password",text: $userAcc.password)
                    .padding()
                    .background(Color.orange)
                    .opacity(0.8)
                    .cornerRadius(10)
                
                HStack {
                    Button("Sign In", action: {
                        userAcc.signInWithEmailPassword()
                        UserProfileView().environmentObject(userAcc)
                    })
                    .padding()
                    .foregroundColor(Color.white)
                    .background(butColor)
                    .cornerRadius(15)
                    .font(Font.body.italic().bold())
                    .frame(maxWidth: .infinity)
                }
//                HStack {
//                    Text("Manage your True Shaker profile")
//                        .foregroundColor(Color.white)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                }
            }
            .background(bkColor)
            .navigationBarItems(
                    trailing: NavigationLink(destination: {
                        SignUp().environmentObject(userAcc)
                        }, label: {
                            Text("Sign Up Now")
                        })
//                    .navigationBarTitle("Sign In")
                )
        }
        .navigationTitle("Sign In")
//        .navigationBarTitleDisplayMode(.inline)
    }
}
struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignIn()
                .environmentObject(UserClass())
        }
    }
}
