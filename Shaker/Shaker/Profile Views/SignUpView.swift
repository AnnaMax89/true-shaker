//
//  Entre.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
//

import SwiftUI


struct SignUp: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userAcc: UserClass

    @State var useremail = ""
    @State var userpass = ""
    @State var confirmpass = ""
    @State private var bkColor = Color(UIColor(named: "BackgroundColor")!)
    @State private var bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
    let butColor = Color(UIColor(named: "ButtonColor")!)
    
    var body: some View {
        NavigationStack{
            VStack()
            {
                Spacer()
                Image("logo-no-background").resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).padding(20)
                Spacer()
                
                Text("Enter E-mail").font(.title2).foregroundColor(.white).padding(.leading)
                TextField("E-mail",text: $userAcc.email)
                    .keyboardType(.emailAddress)
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
                    Button("Sign Up  ", action: {
                        userAcc.signUpWithEmailPassword()
                        dismiss()
                    })
                    .padding()
                    .foregroundColor(Color.white)
                    .background(butColor)
                    .cornerRadius(15)
                    .font(Font.body.italic().bold())
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(bkColor)
            
        }
        .navigationBarTitle("Sign Up",displayMode: .inline)
    }
}
                            
struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUp()
                .environmentObject(UserClass())
        }
    }
}
