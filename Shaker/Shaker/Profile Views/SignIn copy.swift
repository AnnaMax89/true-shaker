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

struct SignInCopy: View {

    @EnvironmentObject var userAcc: UserModel
    
    @State var useremail = ""
    @State var userpass = ""
    @State private var bkColor: Color = Color(red: 42/255, green: 35/255, blue: 89/255)
    
    let butColor : Color = Color(red: 217/255, green: 115/255, blue: 26/255)
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing: 15)
            {
                Image("logo-no-background").resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).aspectRatio(contentMode: .fit).padding(.top)
                
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
                HStack {
                    Text("Manage your True Shaker profile")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                }
    
//                HStack {
//                    NavigationLink(destination: {
//                        SignUp().environmentObject(userAcc)
//                        }, label: {
//                        Text("Sign Up   ")
//                    })
//                    .padding()
//                    .background(butColor)
//                    .foregroundColor(Color.white)
//                    .font(Font.body.italic().bold())
//                    .cornerRadius(20)
////                    .frame(maxWidth: .infinity)
//
//                    Spacer()
//
//                    Button("Reset Pass", action: {
//
//                    })
//                    .padding()
//                    .background(butColor)
//                    .foregroundColor(Color.white)
//                    .font(Font.body.italic().bold())
////                    .frame(maxWidth: .infinity)
//                    .cornerRadius(20)

//                }
                
            }
            .background(bkColor)
//            .background(Image("logo-no-background").resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).aspectRatio(contentMode: .fit).padding(.top)
//                .resizable()
//                .padding(.top, -20.0)
//                .edgesIgnoringSafeArea(.all)
//                .frame(width:UIScreen.main.bounds.width + 5,height:UIScreen.main.bounds.height + 150))
            .navigationBarItems(
                    leading: NavigationLink(destination: {
                        SignUp().environmentObject(userAcc)
                        }, label: {
                            Text("Sign Up Now")
                        })
                    .navigationBarTitle("Sign In")
                        ,
                    trailing:
                        Button(action: { print("Edit button pressed...") })
                    {
                        Text("Reset Password")
                    }
                )
        }
    }
}
struct SignInCopy_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInCopy()
                .environmentObject(UserModel())
        }
    }
}
