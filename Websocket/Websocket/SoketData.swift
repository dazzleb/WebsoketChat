//
//  SoketData.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/17.
//

import Foundation
struct SoketData: Decodable {
    let id: String
    let username: String
    let profileImage: String
    let message: String
    let createdAt: String
}
