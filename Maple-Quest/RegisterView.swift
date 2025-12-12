//
//  RegisterView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import SwiftUI

struct RegisterView: View {
    @Binding var showSignup: Bool
    @EnvironmentObject private var authService: AuthService

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showingPasswordMismatch = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // HEADER
            VStack(spacing: 6) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 48))
                    .foregroundColor(.red)

                Text("Create Account")
                    .font(.title2.bold())
                    .foregroundColor(.black)

                Text("Join the adventure!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)

            // FORM
            VStack(spacing: 14) {
                inputField(text: $firstName, placeholder: "First Name (Optional)")
                inputField(text: $lastName, placeholder: "Last Name (Optional)")
                inputField(text: $email, placeholder: "Email")
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                inputField(text: $phoneNumber, placeholder: "Phone Number (Optional)")
                    .keyboardType(.phonePad)

                passwordField(
                    text: $password,
                    placeholder: "Password",
                    show: $showPassword
                )

                passwordField(
                    text: $confirmPassword,
                    placeholder: "Confirm Password",
                    show: $showConfirmPassword
                )

                // Error Messages
                if showingPasswordMismatch {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                if let error = authService.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // CREATE ACCOUNT BUTTON
                Button(action: createAccount) {
                    HStack {
                        if authService.isLoading {
                            ProgressView().scaleEffect(0.8)
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
                .padding(.top, 4)

                // BACK TO LOGIN LINK
                Button(action: { showSignup = false }) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)

                        Text("Log in")
                            .underline()
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .padding(.top, 2)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .onChange(of: authService.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                showSignup = false
            }
        }
    }

    // Actions
    private func createAccount() {
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
    }

    // UI Components
    private func inputField(text: Binding<String>, placeholder: String) -> some View {
        TextField("", text: text, prompt: Text(placeholder).foregroundColor(.gray))
            .padding(12)
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal)
    }

    private func passwordField(text: Binding<String>, placeholder: String, show: Binding<Bool>) -> some View {
        ZStack(alignment: .trailing) {
            Group {
                if show.wrappedValue {
                    TextField("", text: text, prompt: Text(placeholder).foregroundColor(.gray))
                } else {
                    SecureField("", text: text, prompt: Text(placeholder).foregroundColor(.gray))
                }
            }
            .padding(12)
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal)

            Button(action: { show.wrappedValue.toggle() }) {
                Image(systemName: show.wrappedValue ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
                    .padding(.trailing, 30)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    RegisterView(showSignup: .constant(true))
        .environmentObject(AuthService.shared)
}
