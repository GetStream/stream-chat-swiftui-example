//
//  LoginView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/11/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChatClient

struct LoginView: View {
    @State
    private var username: String = ""
    @State
    private var success: Bool?
    
    var body: some View {
        VStack {
            TextField("Type username", text: $username).padding()
            NavigationLink(destination: ChannelsView(), tag: true, selection: $success) {
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
        Client.shared.set(user: User(id: username), token: .development) { result in
            switch result {
            case .success:
                self.success = true
            case .failure:
                self.success = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
