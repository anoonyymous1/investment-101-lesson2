//
//  ContentView.swift
//  investment 101
//
//  Created by Celine Tsai on 24/7/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var titleText = ""
    @State private var navigationSelection: NavigationDestination?
    let originalText = "Investment 101"
    
    enum NavigationDestination {
        case register
        case login
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text(titleText)
                    .font(.custom("Kefa Regular", size: 50))
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .onAppear {
                        animateTitleText()
                    }
                
                Spacer()
                
                NavigationLink(
                    destination: RegisterView(),
                    tag: .register,
                    selection: $navigationSelection,
                    label: { EmptyView() }
                )
                
                Button(action: {
                    navigationSelection = .register
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.title)
                        .frame(height: 70)
                        .frame(maxWidth: 370)
                        .background(Color(hex: "576CBC"))
                        .cornerRadius(10)
                        .padding(.bottom)
                }
                
                NavigationLink(
                    destination: LoginView(),
                    tag: .login,
                    selection: $navigationSelection,
                    label: { EmptyView() }
                )
                
                Button(action: {
                    navigationSelection = .login
                }) {
                    Text("Log in")
                        .foregroundColor(.black)
                        .font(.title)
                        .frame(height: 70)
                        .frame(maxWidth: 370)
                        .background(Color(hex: "A5D7E8"))
                        .cornerRadius(10)
                        .padding(.top)
                    
                }
                
                Spacer()
                    .frame(height: 10)
            }
            .padding()
            .background(Color(hex: "0B2447").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    func animateTitleText() {
        for (index, letter) in originalText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                titleText.append(letter)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
