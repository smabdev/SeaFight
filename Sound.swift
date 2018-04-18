//
//  Sound.swift
//  SeaFight
//
//  Created by Алех on 29.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import Foundation
import MediaPlayer


class Sound {
    
    // длительность звука в мс
    static let kLenght = 3500
    static var audioItem: AVPlayerItem!
    static var audioPlayer:AVAudioPlayer!
    
    enum SoundType {
        case miss
        case hit
    }
    
    
    // приигрывание звука выстрела и попадания/промаха
    static func play(type: SoundType) {
        
        var url: URL!
        switch type {
        case .hit:
            url = Bundle.main.url(forResource: "hit-2", withExtension: "mp3")!
            
        case .miss:
            url = Bundle.main.url(forResource: "mis-2", withExtension: "mp3")!
        }
        audioItem = AVPlayerItem(url: url)
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            audioPlayer.volume = 0.5
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(kLenght), execute: {
            audioItem = nil
            audioPlayer = nil
        })
    }
    

    

    
    
}
