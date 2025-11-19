import SwiftUI

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchType: SearchType = .email
    @State private var input = ""
    @State private var isLoading = false
    @State private var statusMessage: String?
    @State private var isSuccess: Bool = false
    
    // Closure to notify parent view to refresh list
    var onFriendAdded: () -> Void

    enum SearchType: String, CaseIterable, Identifiable {
        case email, phone
        var id: String { self.rawValue }
        var placeholder: String { self == .email ? "Friend's Email" : "Friend's Phone Number (e.g., +11234567890)" }
        var keyboardType: UIKeyboardType { self == .email ? .emailAddress : .phonePad }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Search for a friend by their registered Email or Phone Number.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Picker("Search By", selection: $searchType) {
                    Text("Email").tag(SearchType.email)
                    Text("Phone Number").tag(SearchType.phone)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                TextField(searchType.placeholder, text: $input)
                    .keyboardType(searchType.keyboardType)
                    .autocapitalization(searchType == .email ? .none : .words)
                    .disableAutocorrection(searchType == .email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendRequest) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        }
                        Text("Send Friend Request")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isLoading || input.isEmpty)
                .padding(.horizontal)
                
                if let message = statusMessage {
                    Text(message)
                        .foregroundColor(isSuccess ? .green : .red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    func sendRequest() {
        isLoading = true
        statusMessage = nil
        isSuccess = false

        Task {
            do {
                if searchType == .email {
                    let response = try await APIService.shared.addFriend(email: input)
                    statusMessage = response.message
                } else {
                    let processedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
                    let response = try await APIService.shared.addFriend(phoneNumber: processedInput)
                    statusMessage = response.message
                }
                
                isSuccess = true
                // Notify FriendsView to reload data
                onFriendAdded()
                
                // Optional: Auto-dismiss after delay if successful
                // try? await Task.sleep(nanoseconds: 1_500_000_000)
                // dismiss()
                
            } catch {
                statusMessage = "Failed to send request: \(error.localizedDescription)"
                isSuccess = false
            }
            isLoading = false
        }
    }
}

#Preview {
    AddFriendView(onFriendAdded: {})
}
