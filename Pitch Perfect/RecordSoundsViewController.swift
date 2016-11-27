//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Udacity.com Pitch Perfect Project
//
//  Created by Benny on 8/3/15.
//  Copyright (c) 2015 Benny Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recorderAudio: RecorderAudio!
    var recordingLabelStartText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Take the current text inside the recording label and save it for later change.
        recordingLabelStartText = recordingInProgress.text
    }

    override func viewWillAppear(_ animated: Bool) {
        recordButton.isEnabled = true
        stopButton.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            
            let playSoundViewController = segue.destination as! PlaySoundViewController
            playSoundViewController.receiveAudio = sender as! RecorderAudio
        }
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        recordButton.isEnabled = false
        stopButton.isHidden = false
        recordingInProgress.text = "Recording"
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
    
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialize and prepare the recorder
        audioRecorder = try! AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        
        recordButton.isEnabled = true
        recordingInProgress.text = recordingLabelStartText
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            // Save the recorder audio
            recorderAudio = RecorderAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to next scene (aka preform segue)
            self.performSegue(withIdentifier: "stopRecording", sender: recorderAudio)
            
        } else {
            
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
}

