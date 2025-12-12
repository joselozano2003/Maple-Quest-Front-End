//
//  LoginView.swift
//  Maple-Quest
//
//  Created by Eugene Lee on 2025-10-16.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authService = AuthService.shared
    @State private var username = ""
    @State private var password = ""
    @State private var showSignup = false
    @State private var showPassword = false
    
    var body: some View {
        if authService.isAuthenticated {
            ContentView()
                .environmentObject(authService)
        } else if showSignup {
            RegisterView(showSignup: $showSignup)
                .environmentObject(authService)
        } else {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    VStack{
                        Text("Maple")
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(x: -40)
                            .foregroundColor(.black)
                        Text("Quest")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .offset(x: 25)
                    }
                    .padding(.bottom, -150)
                    
                    Image("splashIcon")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.55)
                        .offset(x: 10, y: -90)
                        .padding(.bottom, -160)
                
                    Text("Sign in").bold()
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))

                    TextField("", text: $username, prompt: Text("Email").foregroundColor(.gray))
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal)

                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                            } else {
                                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                            }
                        }
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(.trailing, 30)
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                    }

                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("Login") {
                        Task {
                            await authService.login(email: username, password: password)
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(authService.isLoading ? Color.gray : Color.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .disabled(authService.isLoading || username.isEmpty || password.isEmpty)
                    .overlay(
                        Group {
                            if authService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    )
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button(action: { showSignup = true }) {
                            Text("Sign up")
                                .underline()
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.footnote)
                }
                
                Spacer()
            }
            .background(.white)
        }
    }
}

#Preview {
    LoginView()
}
