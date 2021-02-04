//
//  LoginView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/11/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChat

struct LoginView: View {
    @State
    private var username: String = ""
    @State
    private var success: Bool?
    
    var body: some View {
        VStack {
            TextField("Type username", text: $username).padding()
            NavigationLink(destination: ChatView(), tag: true, selection: $success) {
                EmptyView()
            }
            Button(action: logIn) {
                Text("Log in")
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitle("Log in", displayMode: .inline)
    }
    
    func logIn() {
        /// 1: Set the chat client's token provider
        ChatClient.shared.tokenProvider = .development(userId: username)
        
        /// 2: Reload the current user
        ChatClient.shared.currentUserController().reloadUserIfNeeded { error in
            switch error {
            case .none:
                self.success = true
            case .some:
                self.success = false
            }
        }
        
        self.success = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
