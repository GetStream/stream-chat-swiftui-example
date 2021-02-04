//
//  ChatView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/11/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChat

struct ChatView: View {
    @StateObject var channel = ChatClient.shared.channelController(
        for: ChannelId(
            type: .messaging,
            id: "general"
        )
    ).observableObject
    
    @State
    var text: String = ""
    
    var body: some View {
        VStack {
            List(channel.messages, id: \.self) {
                MessageView(message: $0)
                    .scaleEffect(x: 1, y: -1, anchor: .center)
            }
            .scaleEffect(x: 1, y: -1, anchor: .center)
            .offset(x: 0, y: 2)
            
            HStack {
                TextField("Type a message", text: $text)
                Button(action: self.send) {
                    Text("Send")
                }
            }.padding()
        }
        .navigationBarTitle("General")
        .onAppear(perform: { self.channel.controller.synchronize() })
    }
    
    func send() {
        channel.controller.createNewMessage(text: text) {
            switch $0 {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
        
        self.text = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

