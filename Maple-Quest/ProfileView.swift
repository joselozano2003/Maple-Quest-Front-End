//
//  ProfileView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import PhotosUI

let phoneCodes = ["+1", "+44", "+49", "+61", "+81", "+91"]

struct ProfileView: View {
    @State private var isEditing = false
    @Binding var user: User
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 35) {
                    
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)

                        if let imageData = user.profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.blue.opacity(0.7))
                        }
                    }
                    .padding(.top, 16)

                    // Name & Email
                    VStack(spacing: 4) {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    
                    // Profile Actions
                    VStack(spacing: 12) {
                        // Friends Row
                        NavigationLink {
                            FriendsView()
                        } label: {
                            HStack {
                                Label("Friends", systemImage: "person.2.fill")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileField(title: "Location", value: $user.location).foregroundColor(.black)
                        ProfileField(title: "Email", value:
                                        $user.email).foregroundColor(.black)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mobile Number")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                Text(user.phoneCode)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                Text(user.phoneNumber)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Profile Actions
                    VStack(spacing: 12) {
                        // Logout Button
                        Button(action: {
                            authService.logout()
                        }) {
                            HStack {
                                Label("Sign Out", systemImage: "arrow.right.square")
                                    .fontWeight(.medium)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { isEditing = true }
                }
            }
            .sheet(isPresented: $isEditing) {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    EditProfileView(user: $user)
                }
            }
        }
    }
}

struct ProfileField: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("", text: $value)
                .disabled(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                )
        }
    }
}

struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    @State private var isSaving = false
    
    init(user: Binding<User>) {
        self._user = user
        if let data = user.wrappedValue.profileImageData,
           let uiImage = UIImage(data: data) {
            self._selectedImage = State(initialValue: uiImage)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)

                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.blue.opacity(0.7))
                        }
                        
                        // Change button
                        PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                            Image(systemName: "camera.fill")
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                                )
                        }
                    }
                    .padding(.top, 16)
                    .onChange(of: photoItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                                user.profileImageData = data
                            }
                        }
                    }
                    
                    Text(user.firstName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        EditableField(title: "First Name", text: $user.firstName).foregroundColor(.black)
                        EditableField(title: "Last Name", text: $user.lastName).foregroundColor(.black)
                        EditableField(title: "Email", text: $user.email).foregroundColor(.black)
                        EditableField(title: "Location", text: $user.location).foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mobile Number")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                Picker("", selection: $user.phoneCode) {
                                    ForEach(phoneCodes, id: \.self) { code in
                                        Text(code).tag(code)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(minWidth: 50, idealWidth: 70, maxWidth: 80)
                                .clipped()
                                .padding(.leading, 4)

                                Divider()
                                    .frame(height: 30)
                                    .padding(.horizontal, 4)

                                TextField("Phone Number", text: $user.phoneNumber).foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 2)
                            }
                            .frame(height: 40)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit Profile")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        Task {
                            isSaving = true
                            // Save profile changes to backend
                            let success = await authService.updateProfile(
                                firstName: user.firstName.isEmpty ? nil : user.firstName,
                                lastName: user.lastName.isEmpty ? nil : user.lastName,
                                phoneNumber: user.phoneNumber.isEmpty ? nil : user.phoneNumber
                            )
                            isSaving = false
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .disabled(isSaving)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .overlay(
                Group {
                    if isSaving {
                        ZStack {
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
            )
        }
    }
}

struct EditableField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(title, text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 242/255, green: 242/255, blue: 247/255))
                )
        }
    }
}

#Preview {
    // Wrap in NavigationStack to preview the new link
    NavigationStack {
        ProfileView(user: .constant(User.sample))
    }
}
