//
//  APIService.swift
//  Sesi6FirstAPI
//
//  Created by MACBOOK PRO on 19/04/24.
//

import Foundation

// menggunakan class karena:
// untuk memastikan bahwa hanya ada satu objek (instance) bersama yang akan digunakan di seluruh aplikasi. Konsep ini disebut dengan singleton
class APIService {
    static let shared = APIService()
    
    private init() {} // untuk mencegah agar class tidak bisa di re-create
    
    func fetchJokeServices() async throws -> Joke {
        // tampung url yang berbentuk string kedalam variabel dengan bentuk URL
        let urlFromString = URL(string: Constants.jokeApiUrl)
        
        // guard akan menlanjutkan code setelahnya jika tidak terjadi error, jika error akan eksekusi else
        // memastikan bahwa url valid
        guard let url = urlFromString else {
            print("Error: Could not convert \(String(describing:urlFromString)) to a URL")
            throw URLError(.badURL)
        }
        
        print("We are accessing the url \(url)")
        
        // ambil data dan response, simpan dalam variabel data dan response
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // cek apakah ada response dari server
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // cek apakah response code berhasil
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        // tampung data response
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
    }
}

