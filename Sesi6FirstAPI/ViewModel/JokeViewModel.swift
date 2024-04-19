//
//  JokeViewModel.swift
//  Sesi6FirstAPI
//
//  Created by MACBOOK PRO on 19/04/24.
//

import Foundation

// ObsevableObject --> untuk memastikan class berubah ketika ada perubahan objek
@MainActor // memastikan perubahan UI dijalankan pada thread terpisah agar UI tidak freeze
class JokeViewModel: ObservableObject {
    @Published var joke: Joke?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchJoke() async {
        isLoading = true
        errorMessage = nil
        
        do {
            joke = try await APIService.shared.fetchJokeServices()
            print("Setup: \(joke?.setup ?? "No Setup")")
            print("PUnchline: \(joke?.punchline ?? "No Punchline")")
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            print("ERROR: Could not get data from URL: \(Constants.jokeApiUrl). \(error.localizedDescription)")
            isLoading = false
        }
    }
}
