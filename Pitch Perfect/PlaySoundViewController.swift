//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Udacity.com Pitch Perfect Project
//  Notes:
//  I have problem with the Autolayout during the landscape modes.
//  There's a bug in the 'playAudioWithVariablePitch' function that when the audio finishes playing,
//  it takes time to detect it and few seconds later the 'stopButton' change the enable state.
//
//  Created by Benny on 8/8/15.
//  Copyright (c) 2015 Benny Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var receiveAudio: RecorderAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a AVAudioPlayer object with the recorded audio.
        audioPlayer = try! AVAudioPlayer(contentsOf: receiveAudio.filePathUrl)
        
        // Enable playback rate adjustment
        audioPlayer.enableRate = true
        
        // Create a AVAudioEngine object
        audioEngine = AVAudioEngine()
        
        // Convert NSURL to AVAudioFile
        audioFile = try! AVAudioFile(forReading: receiveAudio.filePathUrl as URL)
        
        // Play audio through speaker
        setSessionPlayAndRecord()
        
        // Allocate AVAudioPlayer delegate for detecting if audio finish playing
        audioPlayer.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isEnabled = false
    }
    
    @IBAction func playSlowAudio(_ sender: UIButton) {
        
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(_ sender: UIButton) {
        
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(_ sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAnyAudio(_ sender: UIButton) {
        
        stopAllAndReset()
        stopButton.isEnabled = false
    }
    
    func playAudioWithVariablePitch(_ pitch: Float) {
        
        stopAllAndReset()
        
        // Create a AVAudioPlayerNode object
        let audioPlayerNode = AVAudioPlayerNode()
        
        // Attach AVAudioPlayerNode to AVAudioEngine
        audioEngine.attach(audioPlayerNode)
        
        // Create a AVAudioUnitTimePitch object
        let changePitchEffect = AVAudioUnitTimePitch()
        
        changePitchEffect.pitch = pitch
        
        // Attach AVAudioUnitTimePitch to AVAudioEngine
        audioEngine.attach(changePitchEffect)
        
        // Connect AVAudioPlayerNode to AVAudioUnitTimePitch
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        // Connect AVAudioUnitTimePitch to Output (speakers)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule playing of an entire audio file (disable stop button after the segment has completely played)
        // TODO: Check why it takes time to detect when audio did finish playing
        audioPlayerNode.scheduleFile(audioFile, at: nil) { () -> Void in
            
            self.stopButton.isEnabled = false
        }
        
        // Resume the engine by invoking start again
        try! audioEngine.start()
        
        // Play audio player
        audioPlayerNode.play()
        
        stopButton.isEnabled = true
    }
    
    func playAudioWithVariableRate(_ rate: Float) {
        
        stopAllAndReset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        stopButton.isEnabled = true
    }
    
    // Force audio file playback through iPhone loud speaker using Swift
    // http://stackoverflow.com/questions/29526435/force-audio-file-playback-through-iphone-loud-speaker-using-swift?answertab=active#tab-top
    func setSessionPlayAndRecord() {
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)

//        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker) {
//            print("Could not set output to speaker.")
//            if let e = error {
//                print(e.localizedDescription)
//            }
//        }
    }
    
    func stopAllAndReset() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // Detect audioPlayer finish playing (for the slow and fast audio)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        stopButton.isEnabled = false
    }
}
