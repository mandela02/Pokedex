//
//  VoiceHelper.swift
//  Pokedex
//
//  Created by TriBQ on 12/10/2020.
//

import Foundation
import AVFoundation
import SwiftUI

class VoiceHelper: NSObject, ObservableObject {
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            lineToSpeak  = pokemon.name + ", pokemon no \(pokemon.pokeId)"
        }
    }
    @Published var species: Species = Species()
    
    @Published var begunSpeak = false {
        didSet {
            if begunSpeak {
                speak(text: lineToSpeak)
                lineToSpeak = StringHelper.getRandomEnglishText(from: species.flavorTextEntries ?? [])
            } else {
                if speechSynthesizer.isSpeaking {
                    speechSynthesizer.stopSpeaking(at: .immediate)
                }
            }
        }
    }
    
    var lineToSpeak = ""
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    override init () {
        super.init()
        speechSynthesizer.delegate = self
    }
    
    private func speak(text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        speechSynthesizer.speak(utterance)
    }
    
    func refresh() {
        begunSpeak = false
    }
}

extension VoiceHelper: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        withAnimation(.spring()) {
            begunSpeak = false
        }
    }
}
