//
//  ContentView.swift
//  Sesi6FirstAPI
//
//  Created by Hidayat Abisena on 28/01/24.
//

import SwiftUI

struct CardView: View {
    @State private var fadeIn: Bool = false
    @State private var moveDownward: Bool = false
    @State private var moveUpward: Bool = false
    @State private var soundNumber: Int = 7
    @State private var showPunchline: Bool = false
    
    @StateObject private var jokeViewModel = JokeViewModel()
    
    let totalSound = 25
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text(Constants.setupText)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 30))
                    
                    Text(jokeViewModel.joke?.setup ?? Constants.noJokeText)
                        .foregroundStyle(.white)
                        .fontWeight(.light)
                        .italic()
                }
                .offset(y: moveDownward ? -218 : -300)
                
                // MARK: Punchline
                if showPunchline {
                    Text(jokeViewModel.joke?.punchline ?? Constants.noJokeText)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 35))
                        .multilineTextAlignment(.center)
                }
                
                // MARK: Button punchline
                Button {
                   handleClickPuncline()
                } label: {
                    HStack {
                        Text("Punchline".uppercased())
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                        
                        Image(systemName: "arrow.right.circle")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 24)
                    .background(showPunchline ? 
                                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.white]), startPoint: .top, endPoint: .bottom)
                                :
                                LinearGradient(gradient: Gradient(colors: [Color.color07, Color.color08]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: Color("ColorShadow"), radius: 6, x: 0, y: 3)
                }
                .offset(y: moveUpward ? 210 : 300)
                .disabled(showPunchline)
                
            }
            // MARK: Refresh setup punchline
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await handleClickRefresh()
                        }
                    }
                    label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.white)
                            .padding()
                            .background(LinearGradient(gradient:Gradient(colors: [Color.color07, Color.color08]), startPoint: .leading, endPoint: .trailing))
                            .clipShape(Circle())
                    }
                }
            }
            .task {
                await jokeViewModel.fetchJoke()
            }
            .frame(width: 335, height: 545)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.color07, Color.color08]), startPoint: .top, endPoint: .bottom)
            )
            .opacity(fadeIn ? 1.0 : 0.0)
            .onAppear() {
              withAnimation(.linear(duration: 1.2)) {
                self.fadeIn.toggle()
              }
                
              withAnimation(.linear(duration: 0.6)) {
                self.moveDownward.toggle()
                self.moveUpward.toggle()
              }
            }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CardView()
}

extension CardView {
    func handleClickPuncline() {
        playSound(soundName: "\(soundNumber)")
        soundNumber += 1
        if soundNumber > totalSound {
            soundNumber = 0
        }
        showPunchline.toggle()
    }
    
    func handleClickRefresh() async {
        await jokeViewModel.fetchJoke()
        showPunchline = false
    }
}
