//
//  ChannelsView.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/31/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import SwiftUI
import StreamChatClient

struct ChannelsView: View {
    @State
    var channels = [String]()
    @State
    var createTrigger = false
    @State
    var searchTerm = ""
    
    var body: some View {
        VStack {
            createChannelView
            searchView
            List(channels, id: \.self) { channelId in
                NavigationLink(destination: ChatView(id: channelId)) {
                    Text(channelId)
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
    
    func loadChannels() {
        let filter: Filter
        
        if searchTerm.isEmpty {
            filter = .and([.in("members", [Client.shared.user.id]),
                           .equal("type", to: "messaging")])
        } else {
            filter = .and([.equal("type", to: "messaging")])
        }

        Client.shared.queryChannels(query: ChannelsQuery(filter: filter)) { 
            switch $0 {
            case .success(let response):
                self.channels = response
                    .map { $0.channel.id }
                    .filter { 
                        if self.searchTerm.isEmpty { 
                            return true 
                        } else { 
                            return $0.contains(self.searchTerm)
                        } 
                    }
            case .failure(let error):
                print(error)
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
                Button(action: self.createChannel) {
                    Text(self.createChannelName.isEmpty ? "Cancel" : "Submit")
                }
            }.padding())
        }
        
        return AnyView(EmptyView()) // TODO: Add Channel
    }
    
    func createChannel() {
        self.createTrigger = false
        if !self.createChannelName.isEmpty {
            Client.shared.channel(type: .messaging, id: createChannelName).create {
                switch $0 {
                case .success(let response):
                    self.channels = [response.channel.id] + self.channels
                    Client.shared.add(users: [Client.shared.user], to: response.channel, { _ in })
                case .failure(let error):
                    print(error)
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

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
