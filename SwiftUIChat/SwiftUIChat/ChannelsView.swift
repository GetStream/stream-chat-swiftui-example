//
//  ChannelsView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/31/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChat

struct ChannelsView: View {
    @State
    var channels: [ChatChannel] = []
    @State
    var createTrigger = false
    @State
    var searchTerm = ""
    
    var body: some View {
        VStack {
            createChannelView
            searchView
            List(channels, id: \.self) { channel in
                NavigationLink(destination: chatView(id: channel.cid)) {
                    Text(channel.name ?? channel.cid.id)
                }
            }.onAppear(perform: loadChannels)
        }
        .navigationBarItems(trailing: 
            Button(action: { self.createTrigger = true }) { 
                Text("Create") 
            }.disabled(self.createTrigger || !self.searchTerm.isEmpty)
        )
        .navigationBarTitle("Channels")
    }
    
    func chatView(id: ChannelId) -> ChatView {
        return ChatView(
            channel: ChatClient.shared.channelController(
                for: id
            ).observableObject
        )
    }
    
    func loadChannels() {
        let filter: Filter<ChannelListFilterScope>
        
        if searchTerm.isEmpty {
            filter = .and([.in("members", values: [ChatClient.shared.currentUserId!]),
                           .equal("type", to: "messaging")])
        } else {
            filter = .and([.equal("type", to: "messaging")])
        }
        
        let controller = ChatClient.shared.channelListController(query: .init(filter: filter))
        
        controller.synchronize { error in
            if let error = error {
                print(error)
                return
            }
            
            self.channels = controller.channels
                .filter {
                    if self.searchTerm.isEmpty {
                        return true
                    } else {
                        return $0.cid.id.contains(self.searchTerm)
                    }
                }
        }
    }
    
    // - MARK: Create Channel
    
    @State
    var createChannelName = ""
    
    var createChannelView: some View {
        if(createTrigger) {
            return AnyView(HStack {
                TextField("Channel name", text: $createChannelName)
                Button(action: { try? self.createChannel() }) {
                    Text(self.createChannelName.isEmpty ? "Cancel" : "Submit")
                }
            }.padding())
        }
        
        return AnyView(EmptyView()) // TODO: Add Channel
    }
    
    func createChannel() throws {
        self.createTrigger = false
        if !self.createChannelName.isEmpty {
            let cid = ChannelId(type: .messaging, id: createChannelName)
            let controller = try ChatClient.shared.channelController(
                createChannelWithId: cid,
                name: nil,
                imageURL: nil,
                isCurrentUserMember: true,
                extraData: .defaultValue
            )
            controller.synchronize { error in
                if let error = error {
                    print(error)
                } else if let channel = controller.channel {
                    channels.append(channel)
                }
            }
        }
        self.createChannelName = ""
    }
    
    // - MARK: Search
    
    var searchView: some View {
        if(createTrigger) {
            return AnyView(EmptyView())
        } else {
            let binding = Binding<String>(get: {
                self.searchTerm
            }, set: {
                self.searchTerm = $0
                self.loadChannels()
            })
            
            return AnyView(HStack {
                TextField("Search channels", text: binding)
                    if !searchTerm.isEmpty {
                        Button(action: clearPressed) {
                            Text("Clear")
                        }
                    }
                }
                .padding()
                .onDisappear(perform: {
                    if !self.searchTerm.isEmpty {
                        self.clearPressed()
                    }
                })
            )
        }
    }
    
    func clearPressed() {
        self.searchTerm = ""
        self.loadChannels() 
    }
}
