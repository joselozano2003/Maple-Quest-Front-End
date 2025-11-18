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
            SignupView(showSignup: $showSignup)
        } else {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Maple Quest")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Login")
                        .font(.title2)
                        .padding(.top, 10)

                    TextField("Email", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal)

                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
        }
    }
}

struct SignupView: View {
    @Binding var showSignup: Bool
    @StateObject private var authService = AuthService.shared
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneCode = "+1"
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var location = ""
    @State private var password = ""
    @State private var showPassword = false
    
    let phoneCodes = ["+1", "+44", "+49", "+61", "+81", "+91"]
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Maple Quest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text("Sign Up")
                    .font(.title2)
                    .padding(.top, 10)
                
                Group {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    
                    HStack {
                        Menu {
                            ForEach(phoneCodes, id: \.self) { code in
                                Button(code) {
                                    phoneCode = code
                                }
                            }
                        } label: {
                            HStack {
                                Text(phoneCode)
                                    .foregroundColor(.red)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                        }
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Location", text: $location)
                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                        }
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                if let errorMessage = authService.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button("Create Account") {
                    Task {
                        await authService.register(
                            email: email,
                            password: password,
                            firstName: firstName.isEmpty ? nil : firstName,
                            lastName: lastName.isEmpty ? nil : lastName,
                            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber
                        )
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(authService.isLoading ? Color.gray : Color.red)
                .cornerRadius(8)
                .padding(.horizontal)
                .disabled(authService.isLoading || email.isEmpty || password.isEmpty)
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
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button(action: { showSignup = false }) {
                        Text("Log in")
                            .underline()
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)
            }
            
            Spacer()
        }
        .onChange(of: authService.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                showSignup = false
            }
        }
    }
}

#Preview {
    LoginView()
}