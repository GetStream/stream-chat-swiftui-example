//
//  MessageView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/18/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChatClient

struct MessageView: View {
    @State
    var message: Message
    
    var background: some View {
        if (message.user.isCurrent) {
            return Color.blue.opacity(0.25)
        } else {
            return Color.gray.opacity(0.25)
        }
    }
    
    var title: some View {
        if message.user.isCurrent {
            return Text("")
        } else {
            return Text(message.user.id).font(.footnote)
        }
    }
    
    var body: some View {
        HStack {
            if message.user.isCurrent { Spacer() }
            VStack(alignment: .leading) {
                title
                Text(message.text)
                .padding(8)
                .background(background)
                .cornerRadius(24)
            }
            if !message.user.isCurrent { Spacer() }
        }.frame(maxWidth: .infinity)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
