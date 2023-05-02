//
//  MainPageView.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-24.
//

import SwiftUI
enum CustomTab: String {
    case home
    case party
    case reciepes
    case login
}

struct MainPageView: View {
    
    @StateObject var userAcc = UserClass()
    
    @AppStorage("showApprove") var showApprove = true
    @State private var loginImage = "person"
    @State private var selectedTab: CustomTab = .home
    
    init() {
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "TabBarUnselected")
    }
    
    
    var body: some View {
        NavigationStack{
            TabView(selection:$selectedTab){
                HomeView()
                    .tabItem{ Label("Home", systemImage:"house") }
                    .tag(CustomTab.home)
                PartyView()
                    .tabItem{ Label("Party", systemImage:"party.popper") }
                    .tag(CustomTab.party)
                RecipesView()
                    .tabItem{ Label("Reciepes", systemImage:"list.bullet.clipboard") }
                    .tag(CustomTab.reciepes)
                Group{
                    if userAcc.userState == .authenticated {
                        UserProfileView().environmentObject(userAcc)
                    } else { SignIn().environmentObject(userAcc) }
                }
                .tabItem{ Label("Login", systemImage:loginImage) }
                .toolbarBackground(Color.white)
                .tag(CustomTab.login)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        }
        .fullScreenCover(isPresented: $showApprove, content: ApproveView.init)
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
