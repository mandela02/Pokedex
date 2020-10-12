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
    @Published var pokemon: Pokemon = Pokemon()
    @Published var species: Species = Species()

    private var isFirstTime = true
    
    @Published var isSpeaking = false {
        didSet {

            if isSpeaking {
                if isFirstTime {
                    let text = pokemon.name + ", pokemon no \(pokemon.id)"
                    speak(text: text)
                    isFirstTime = false
                } else {
                    let text = StringHelper.getRandomEnglishText(from: species.flavorTextEntries)
                    speak(text: text)
                }
            } else {
                if speechSynthesizer.isSpeaking {
                    speechSynthesizer.stopSpeaking(at: .immediate)
                }
            }
        }
    }
    
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
}

extension VoiceHelper: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        withAnimation(.spring()) {
            isSpeaking = false
        }
    }
}
