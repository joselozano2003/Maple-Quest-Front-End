//
//  ProfileView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 12) {
                        // Avatar
                    Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue.opacity(0.7))
                            .background(Circle().fill(Color(.systemGray6)))
                            .padding(.top, 16)
                        
                        // Name & Email
                        Text("Leonardo")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("leonardo@gmail.com")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileField(title: "First Name", value: user.firstName)
                        ProfileField(title: "Last Name", value: user.lastName)
                        ProfileField(title: "Location", value: user.location)
                        ProfileField(title: "Mobile Number", value: user.formattedPhone)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Edit")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct ProfileField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("", text: .constant(value))
                .disabled(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        }
    }
}

#Preview {
    ProfileView(user: .sample)
}
