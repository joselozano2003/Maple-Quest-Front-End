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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
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
                        Text(user.firstName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(user.email)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    
                    // --- UPDATED SECTION ---
                    VStack(spacing: 12) {
                        // Edit Profile Row
                        Button(action: { isEditing = true }) {
                            HStack {
                                Label("Edit Profile", systemImage: "pencil")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                        
                        // NEW: Friends Row
                        NavigationLink {
                            // This goes to the new view
                            FriendsView()
                        } label: {
                            HStack {
                                Label("Friends", systemImage: "person.2.fill")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                    }
                    .padding(.horizontal)
                    // --- END UPDATED SECTION ---
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileField(title: "First Name", value: $user.firstName)
                        ProfileField(title: "Last Name", value: $user.lastName)
                        ProfileField(title: "Email", value: $user.email)
                        ProfileField(title: "Location", value: $user.location)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mobile Number")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                Text(user.phoneCode)
                                    .fontWeight(.medium)
                                Text(user.phoneNumber)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { isEditing = true }
                }
            }
            .sheet(isPresented: $isEditing) {
                EditProfileView(user: $user)
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
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        }
    }
}

struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    
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
                                .background(Circle().fill(Color(.systemGray5)))
                        }
                    }
                    .padding(.top, 16)
                    .onChange(of: photoItem) { newItem in
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        EditableField(title: "First Name", text: $user.firstName)
                        EditableField(title: "Last Name", text: $user.lastName)
                        EditableField(title: "Email", text: $user.email)
                        EditableField(title: "Location", text: $user.location)
                        
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

                                TextField("Phone Number", text: $user.phoneNumber)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 2)
                            }
                            .frame(height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
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
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        }
    }
}

#Preview {
    // Wrap in NavigationStack to preview the new link
    NavigationStack {
        ProfileView(user: .constant(User.sample))
    }
}
