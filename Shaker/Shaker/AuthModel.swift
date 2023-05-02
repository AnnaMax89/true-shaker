//
//  AuthModel.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-05.
//

import Foundation
import FirebaseAuth

enum AuthState {
  case unauthenticated
  case authenticating
  case authenticated
}

//enum AuthFlow {
//  case signIn
//  case signUp
//}

@MainActor
class AuthModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""

//  @Published var flow: AuthFlow = .signIn

  @Published var isValid  = false
  @Published var authenticationState: AuthState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""

    private var authStateHandler: AuthStateDidChangeListenerHandle?

  init() {
    registerAuthStateHandler()

//    $flow
//      .combineLatest($email, $password, $confirmPassword)
//      .map { flow, email, password, confirmPassword in
//        flow == .signIn
//          ? !(email.isEmpty || password.isEmpty)
//          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
//      }
//      .assign(to: &$isValid)
  }



  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.email ?? "(unknown)"
      }
    } else {
        print("User is not signed in")
    }
  }

//  func switchFlow() {
//    flow = flow == .signIn ? .signUp : .signIn
//    errorMessage = ""
//  }
//
//  private func wait() async {
//    do {
//      print("Wait")
//      try await Task.sleep(nanoseconds: 1_000_000_000)
//      print("Done")
//    }
//    catch {
//      print(error.localizedDescription)
//    }
//  }

  func reset() {
//    flow = .signIn
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Email and Password Authentication
extension AuthModel {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
        let authResult = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        user = authResult.user
        print("User \(authResult.user.uid) signed in")
        authenticationState = .authenticated
        
        return true
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        user = authResult.user
        print("User \(authResult.user.uid) signed in")
        authenticationState = .authenticated
        
        return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}
