//
//  UserProfile.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI

struct UserProfile: View {
    //@AppStorage("username") var username : String?
    @Binding var username: String
    @Binding var authenticated: Bool
    
    var body: some View {
        List {
            Section(header: Text("Profile \(Image(systemName: "person.fill"))")) {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\(username)" )
                }
            }
            Section(
                header: Text("Status \(Image(systemName: "person.fill"))")) {
                    NavigationLink(
                        destination: SignIn(username: $username, authenticated: $authenticated)
                    ) {
                        HStack {
                            Spacer()
                            Text("Sign in")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                    }
                    
                }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(username: .constant("JohnDoe"), authenticated: .constant(false))
    }
}
