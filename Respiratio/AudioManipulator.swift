//
//  AudioManipulator.swift
//  Respiratio
//
//  Created by Adam Hair on 4/20/16.
//  Copyright © 2016 Adam Hair. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManipulator {
    let engine = AVAudioEngine()
    
    func captureAudio() {
        let inputNode = engine.inputNode
        let bus = 0
        
        inputNode?.installTapOnBus(bus, bufferSize: 2048, format: inputNode?.inputFormatForBus(bus)) {
            (buffer:AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
        }
        
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print("Error starting engine")
        }
    }
    
}