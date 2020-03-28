//
//  WebsocketModel.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2020/3/28.
//  Copyright © 2020 Yeyongping. All rights reserved.
//

import Foundation

enum ChatMessageType {
    case OneToOne(id: UInt)
    case RoomMessage(name: String)
    case Broadcast
    case Join(name: String)
    case Ack
}

extension ChatMessageType: Codable {
    enum CodaleError: Error {
        case defalut
    }
    
    enum CodingKeys: String, CodingKey {
        case OneToOne
        case RoomMessage
        case Join
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .OneToOne(let id):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .OneToOne)
        case .RoomMessage(let name):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .RoomMessage)
        case .Broadcast:
            var single = encoder.singleValueContainer()
            try single.encode("Broadcast")
        case .Join(let name):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .Join)
        case .Ack:
            var single = encoder.singleValueContainer()
            try single.encode("Ack")
        }
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if let value = try? values.decode(String.self, forKey: .Join) {
                self = .Join(name: value)
                return
            }
            
            if let value = try? values.decode(UInt.self, forKey: .OneToOne) {
                self = .OneToOne(id: value)
                return
            }
            
            if let value = try? values.decode(String.self, forKey: .RoomMessage) {
                self = .RoomMessage(name: value)
                return
            }
            
        } catch DecodingError.typeMismatch(_, _) {
            let single = try decoder.singleValueContainer()
            let value = try single.decode(String.self)
            if value == "Broadcast" {
                self = .Broadcast
                return
            } else if value == "Ack" {
                self = .Ack
                return
            }
        } catch {
            throw error
        }
        throw CodaleError.defalut
    }
}

struct ChatMessage: Codable {
    let from: UInt?
    let style: ChatMessageType
    let content: String?
    let messageId: String?
    
    static func message(style: ChatMessageType, content: String, messageId: String) -> ChatMessage {
        return ChatMessage(from: nil, style: style, content: content, messageId: messageId)
    }
}

