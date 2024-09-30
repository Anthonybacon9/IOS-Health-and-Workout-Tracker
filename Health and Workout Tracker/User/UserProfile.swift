import SwiftUI
import FirebaseAuth

struct UserProfile: View {
    @Binding var username: String
    @Binding var authenticated: Bool
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String? = nil
    @State private var showUpdatePassword = false

    var body: some View {
        List {
            // Profile Section
            Section() {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\(username)")
                }
            }

            // Authentication Status Section
            Section() {
                if authenticated == false {
                    NavigationLink(
                        destination: SignIn(username: $username, authenticated: $authenticated)
                    ) {
                        HStack {
                            Spacer()
                            Text("Sign in")
                                .foregroundStyle(.orange)
                            Spacer()
                        }
                    }
                } else {
                    Button {
                        signOut()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }

            // Password Update Section
            if authenticated {
                Section(header: Text("Password \(Image(systemName: "lock.fill"))")) {
                    if showUpdatePassword {
                        SecureField("New Password", text: $newPassword)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                            )

                        SecureField("Confirm New Password", text: $confirmPassword)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                            )

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }

                        Button {
                            updatePassword()
                        } label: {
                            Text("Update Password")
                                .foregroundColor(.orange)
                        }
                    } else {
                        Button {
                            withAnimation {
                                showUpdatePassword.toggle()
                            }
                        } label: {
                            Text("Change Password")
                        }
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }

    // Sign Out Function
    private func signOut() {
        do {
            try Auth.auth().signOut()
            authenticated = false
            username = ""
        } catch let signOutError as NSError {
            errorMessage = "Error signing out: \(signOutError.localizedDescription)"
        }
    }

    // Update Password Function
    private func updatePassword() {
        guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in both fields."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error as NSError? {
                errorMessage = "Error updating password: \(error.localizedDescription)"
            } else {
                errorMessage = "Password updated successfully."
                newPassword = ""
                confirmPassword = ""
                showUpdatePassword = false
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(username: .constant("JohnDoe"), authenticated: .constant(true))
    }
}
