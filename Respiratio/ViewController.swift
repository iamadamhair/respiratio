//
//  ViewController.swift
//  Respiratio
//
//  Created by Adam Hair on 4/20/16.
//  Copyright © 2016 Adam Hair. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioRecorder:AVAudioRecorder!
    var audioEngine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var recording = false
    
    @IBOutlet weak var captureButtonOutlet: UIButton!
    
    @IBAction func captureButton(sender: AnyObject) {
        if !recording {
            beginRecording()
            recording = true
            captureButtonOutlet.setTitle("Finish Session", forState: .Normal)
        }
        else {
            stopRecording()
            captureButtonOutlet.setTitle("Capture Respiration", forState: .Normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func beginRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "respirationAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        playAudio(audioRecorder.url)
        audioRecorder = nil
    }
    
    func playAudio(filePath: NSURL? = nil) {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        let audioFile:AVAudioFile!
        
        do {
            audioFile = try AVAudioFile(forReading: filePath!)
            print("Audio file read")
        } catch {
            print("Unable to read audio file")
            return
        }
        print("Attaching player")
        audioEngine.attachNode(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        print("Preparing")
        audioEngine.prepare()
        
        print("Stopping")
        playerNode.stop()
        print("Trying to schedule")
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
            print("Started audio engine")
        } catch {
            print("Unable to start Audio Engine")
            return
        }
        
        playerNode.play()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            //Handle system interrupts
        }
    }
}

