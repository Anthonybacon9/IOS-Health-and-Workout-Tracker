//
//  SignIn.swift
//  Health and Workout Tracker
//
//  Created by Anthony Bacon on 26/09/2024.
//

import SwiftUI

struct SignIn: View {
    @Environment(\.dismiss) var dismiss
    @Binding var username: String
    @State var name = ""
    @State var password = ""
    @State var acceptedTerms = false
    @Binding var authenticated: Bool
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(.title)
                .bold()
            
            TextField("Username", text: $name)
                .padding()
                .autocapitalization(.none)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
//            TextField("Password", text: $password)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke()
//                )
            
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
                    
                    Text("By checking you agree to enter have your data shown on leaderboards")
                }
            }
                
            
            Button {
                if acceptedTerms && name.count > 2 {
                    username = name
                    authenticated = true
                    dismiss()
                }
            } label: {
                Text("Sign In")
                    .foregroundStyle(.orange)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
            }.buttonStyle(.plain)

        }.padding(.horizontal)
    }
}

//#Preview {
//    SignIn(username: "Text")
//}
