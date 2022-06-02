//
//  InfoViewModel.swift
//  Sol
//
//  Created by Júlio César Flores on 31/05/22.
//

import AVFAudio
import Foundation

final class InfoViewModel: NSObject {
    private var isAudioDescriptionPlaying = false

    private let audioDescriptionPlayer = AVSpeechSynthesizer()

    override init() {
        super.init()
        self.audioDescriptionPlayer.delegate = self
    }

    func handleAudioDescription(for weather: Weather, weatherProvider: WeatherProvider, locale: LocaleService) {
        if self.isAudioDescriptionPlaying {
            self.stopAudioDescription()
        } else {
            self.playAudioDescription(for: weather, weatherProvider: weatherProvider, locale: locale)
        }
    }

    private func playAudioDescription(for weather: Weather, weatherProvider: WeatherProvider, locale: LocaleService) {
        let description = AVSpeechUtterance(string: weatherProvider.generateAudioDescription(for: weather))
        description.voice = locale.voice

        self.audioDescriptionPlayer.speak(description)
    }

    private func stopAudioDescription() {
        self.audioDescriptionPlayer.stopSpeaking(at: .word)
    }
}

extension InfoViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isAudioDescriptionPlaying = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.isAudioDescriptionPlaying = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isAudioDescriptionPlaying = false
    }
}
