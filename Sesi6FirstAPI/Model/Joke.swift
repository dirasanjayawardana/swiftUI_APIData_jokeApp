//
//  Joke.swift
//  Sesi6FirstAPI
//
//  Created by MACBOOK PRO on 19/04/24.
//

import Foundation

// codable --> untuk decode dan encode data dari api
struct Joke: Codable, Identifiable {
    var id: Int
    var type: String
    var setup: String
    var punchline: String
}
