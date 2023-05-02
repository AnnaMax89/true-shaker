//
//  ContentView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
//

import SwiftUI
import WebKit

struct ApproveView: View {
    @AppStorage("showApprove") var showApprove = true
   
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let bkColor : Color = Color(red: 36/255, green: 32/255, blue: 81/255)
        let bkColor2 = Color(UIColor(named: "BackgroundColor2")!)
        let butColor = Color(UIColor(named: "ButtonColor")!)
        
        ZStack{
            let color = Gradient(colors: [bkColor])
            LinearGradient(gradient: color,
                           startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
            
            VStack{
                Spacer()
                gifview(name: "Glass")
                    .frame(width:299, height:370)
                    .cornerRadius(30)
                    .background(Color.clear)
                Spacer()
                
                ZStack{
                    let color = Gradient(colors: [bkColor,bkColor,bkColor2])
                    LinearGradient(gradient: color,
                                   startPoint: .topLeading, endPoint: .bottomLeading).ignoresSafeArea(.all, edges: .all)
                    
                    VStack{
                        Text("Please, approve your age")
                            .font(Font.title.italic())
                        
                        Button(action: {
                            showApprove = false
                            dismiss()
                        }) {
                            Text("YES, I am 20 or older")
                                .padding()
                                .font(.body.italic().bold())
                                .background(butColor.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(height: 50)
                        }
                        .padding()
                        .shadow(radius: 5)
                        
                        HStack {
                            VStack{ Divider().overlay(.white).padding()}
                            Text("or")
                                .font(Font.title.italic())
                            VStack{ Divider().overlay(.white).padding()}
                        }
                        .padding(.top, 50.0)
                        
                        Text("Close the App")
                            .font(.largeTitle.italic())
                            .padding(.bottom)
                    }
                }
                .foregroundColor(Color.white)
            }
        }
       
    }
}
struct ApproveView_Previews: PreviewProvider {
    static var previews: some View {
        ApproveView()
        
    }
}
