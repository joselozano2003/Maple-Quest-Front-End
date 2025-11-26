//
//  RegisterView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var authService = AuthService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var showingPasswordMismatch = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Join the adventure!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 30)
                
                // Registration Form
                VStack(spacing: 16) {
                    TextField("", text: $firstName, prompt: Text("First Name (Optional)").foregroundColor(.gray))
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .padding(.horizontal)
                    
                    TextField("", text: $lastName, prompt: Text("Last Name (Optional)").foregroundColor(.gray))
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .padding(.horizontal)
                    
                    TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray))
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .padding(.horizontal)
                    
                    TextField("", text: $phoneNumber, prompt: Text("Phone Number (Optional)").foregroundColor(.gray))
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .keyboardType(.phonePad)
                        .padding(.horizontal)
                    
                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                            } else {
                                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .padding(.horizontal)
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(.trailing, 30)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    ZStack(alignment: .trailing) {
                        Group {
                            if showConfirmPassword {
                                TextField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.gray))
                            } else {
                                SecureField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.gray))
                            }
                            
                        }
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accentColor(.black)
                        .padding(.horizontal)
                        
                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(.trailing, 30)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if showingPasswordMismatch {
                        Text("Passwords do not match")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        if password != confirmPassword {
                            showingPasswordMismatch = true
                            return
                        }
                        showingPasswordMismatch = false
                        
                        Task {
                            await authService.register(
                                email: email,
                                password: password,
                                firstName: firstName.isEmpty ? nil : firstName,
                                lastName: lastName.isEmpty ? nil : lastName,
                                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber
                            )
                        }
                    }) {
                        HStack {
                            if authService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text("Create Account")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(authService.isLoading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        
        .onChange(of: authService.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
}
