import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignIn: View {
    @Environment(\.dismiss) var dismiss
    @Binding var username: String
    @State var name = ""
    @State var password = ""
    @State var publicUsername = ""
    @State var acceptedTerms = false
    @Binding var authenticated: Bool
    @State var showCreateAccount = false
    @State var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text(showCreateAccount ? "Create Account" : "Sign In")
                .font(.title)
                .bold()
            
            TextField(showCreateAccount ? "Email" : "Username", text: $name)
                .padding()
                .autocapitalization(.none)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
            SecureField("Password", text: $password) // SecureField for passwords
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
            if showCreateAccount {
                TextField("Public Username", text: $publicUsername) // Field for public username during account creation
                    .padding()
                    .autocapitalization(.none)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
            }
            
            if !showCreateAccount {
                // Terms and conditions for sign in
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            acceptedTerms.toggle()
                        }
                    } label: {
                        if acceptedTerms {
                            Image(systemName: "checkmark.circle.fill")
                                .padding()
                        } else {
                            Image(systemName: "checkmark.circle")
                                .padding()
                        }
                        
                        Text("By checking, you agree to show your data on leaderboards")
                    }
                }
            }
            
            // Error Message Display
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button {
                if showCreateAccount {
                    // Create account action
                    createAccount()
                } else {
                    // Sign in action
                    signIn()
                }
            } label: {
                Text(showCreateAccount ? "Create Account" : "Sign In")
                    .foregroundStyle(.orange)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
            }.buttonStyle(.plain)
            
            // Toggle between Sign In and Create Account
            Button {
                showCreateAccount.toggle()
            } label: {
                Text(showCreateAccount ? "Already have an account? Sign In" : "Don't have an account? Create One")
                    .foregroundStyle(.blue)
                    .padding(.top)
            }
            
        }.padding(.horizontal)
    }
    
    func getUsernameFromEmail(_ email: String) -> String {
        if let atIndex = email.firstIndex(of: "@") {
            return String(email[..<atIndex])
        }
        return email // If no '@' symbol found, return the whole email (edge case)
    }
    
    // Sign In Function
    private func signIn() {
        guard !name.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in both fields."
            return
        }

        Auth.auth().signIn(withEmail: name, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                // Fetch public username from Firestore using the uid
                let db = Firestore.firestore()
                let usersCollection = db.collection("users")
                
                usersCollection.document(user.uid).getDocument { documentSnapshot, error in
                    if let error = error {
                        errorMessage = "Error fetching user data: \(error.localizedDescription)"
                    } else if let document = documentSnapshot, let data = document.data() {
                        if let publicUsername = data["publicUsername"] as? String {
                            // Set the public username
                            authenticated = true
                            username = publicUsername
                            dismiss()
                        } else {
                            errorMessage = "Public username not found."
                        }
                    }
                }
            }
        }
    }
    
    // Create Account Function
    private func createAccount() {
        guard !name.isEmpty, !password.isEmpty, !publicUsername.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("users")

        // Check if the public username is already taken
        usersCollection.whereField("publicUsername", isEqualTo: publicUsername).getDocuments { snapshot, error in
            if let error = error {
                errorMessage = "Error checking username: \(error.localizedDescription)"
                return
            }

            if let snapshot = snapshot, !snapshot.isEmpty {
                // Username is already taken
                errorMessage = "Username is already taken."
            } else {
                // Proceed with account creation
                Auth.auth().createUser(withEmail: name, password: password) { result, error in
                    if let error = error {
                        errorMessage = "Error creating user: \(error.localizedDescription)"
                    } else if let user = result?.user {
                        // Store public username in Firestore
                        let userData: [String: Any] = [
                            "publicUsername": publicUsername,
                            "email": name,
                            "uid": user.uid // Optionally store uid if needed
                        ]

                        usersCollection.document(user.uid).setData(userData) { error in
                            if let error = error {
                                errorMessage = "Error saving user data: \(error.localizedDescription)"
                            } else {
                                authenticated = true
                                username = publicUsername
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
