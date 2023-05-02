//
//  Entre.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
//

import SwiftUI


struct SignUpCopy: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userAcc: UserModel
//        @State var userAcc = UserModel()
    @State var useremail = ""
    @State var userpass = ""
    @State var confirmpass = ""

    @State private var bkColor: Color = Color(red: 42/255, green: 35/255, blue: 89/255)
        
//    let bkColor : Color = Color(red: 36/255, green: 32/255, blue: 81/255)
    let butColor : Color = Color(red: 217/255, green: 115/255, blue: 26/255)
        
    var body: some View {
        
        NavigationStack{
            VStack(alignment:.leading , spacing: 15)
            {
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
                    Button("Sign Up  ", action: {
                        userAcc.signUpWithEmailPassword()
                        dismiss()
                        //UserProfileView().environmentObject(userAcc)
                    })
                    .padding()
                    .foregroundColor(Color.white)
                    .background(butColor)
                    .cornerRadius(20)
                    .font(Font.body.italic().bold())
                    .frame(maxWidth: .infinity)
                }
            }
            .background(
                Image("backgroundTS")
                .resizable()
                .padding(.top, -20.0)
                .edgesIgnoringSafeArea(.all)
                .frame(width:UIScreen.main.bounds.width + 5,height:UIScreen.main.bounds.height + 150)
            )
        }
    }
}
                            
struct SignUpCopy_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpCopy()
                .environmentObject(UserModel())
        }
    }
}
