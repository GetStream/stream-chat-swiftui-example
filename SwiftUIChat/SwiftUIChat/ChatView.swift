//
//  ChatView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/11/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChatClient

struct ChatView: View {
    let channel = Client.shared.channel(type: .messaging, id: "general")
    
    @State
    var text: String = ""
    @State
    var messages: [Message] = []
    
    var body: some View {
        VStack {
            List(messages.reversed(), id: \.self) {
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
        .onAppear(perform: onAppear)
    }
    
    func send() {
        channel.send(message: .init(text: text)) {
            switch $0 {
            case .success(let response):
                print(response)
                self.text = ""
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func onAppear() {
        channel.watch(options: [.all]) {
            switch $0 {
            case .success(let response):
                self.messages += response.messages
            case .failure(let error):
                break
            }
        }
        
        channel.subscribe(forEvents: [.messageNew]) {
            switch $0 {
            case .messageNew(let message, _, _, _):
                self.messages += [message]
            default:
                break
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

