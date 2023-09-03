//
//  LoginView.swift
//  investment 101
//
//  Created by Celine Tsai on 25/7/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigationSelection: NavigationDestination?
    @State private var email = "Testing@gmail.com"
    @State private var password = "123456"
    @State private var userIsLoggedIn = false
    
    enum NavigationDestination {
        case mainMenu
    }
    var body: some View {
        if userIsLoggedIn {
            MainMenuView()
        } else {
            content
        }
    }
    var content: some View {
        ZStack {
            Color(hexString: "A5D7EB").ignoresSafeArea()
            
            VStack(spacing: -60) {
                // Email TextField
                TextField("Email", text: $email)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .multilineTextAlignment(.center)
                    .frame(width: 360, height: 90)
                    .padding(.top, -30)
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .frame(width: 360, height: 200)
                    .multilineTextAlignment(.center)
                
                // Register Button and NavigationLink
                Group {
                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .foregroundColor(.black)
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(Color.clear)
                    }
                    
                    NavigationLink(
                        destination: MainMenuView()
                            .navigationBarBackButtonHidden(true),
                        tag: .mainMenu,
                        selection: $navigationSelection,
                        label: { EmptyView() }
                    )
                }
                
                Spacer()
            }
            .padding()
            .onAppear{
                Auth.auth().addStateDidChangeListener{
                    auth,user in
                    if user != nil{
                        userIsLoggedIn = true
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: backButton) // Set custom back button
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.white) // Change color to white
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            print(e)
                        } else {
                            navigationSelection = .mainMenu
                        }
                    }
    }
}

extension Color {
    init(hexString1: String) {
        let scanner = Scanner(string: hexString1)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
