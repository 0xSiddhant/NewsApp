//
//  SpeechRecognizer.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 19/01/25.
//

import Foundation
import UIKit
import Speech

class SpeechRecognizer {
    
    private init() {}
    static let shared = SpeechRecognizer()
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isRecordingInProgress = false
    
    func processAudio(_ resultCallback: @escaping ((String) -> Void)) {
        if isRecordingInProgress {
            cancelRecording()
            return
        }
        requestSpeechAuthorization { [weak self] status in
            if status {
                self?.isRecordingInProgress = status
                self?.recordAndRecognizeSpeech { speech in
                    resultCallback(speech)
                }
            }
        }
        
    }
    
    private func requestSpeechAuthorization(_ callBack: @escaping ((Bool) -> Void)) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    debugPrint("Request Granted")
                    callBack(true)
                    return
                case .denied:
                    self.sendAlert(title: "User denied access to speech recognition", message: "")
                case .restricted:
                    self.sendAlert(title: "Speech recognition restricted on this device", message: "")
                case .notDetermined:
                    self.sendAlert(title: "Speech recognition not yet authorized", message: "")
                @unknown default:
                    return
                }
                callBack(false)
            }
        }
    }
    
    private func recordAndRecognizeSpeech(_ resultCallback: @escaping ((String) -> Void)) {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                resultCallback(lastString)
            }
//            else if let error = error {
//                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
//                print(error)
//            }
        })
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        isRecordingInProgress = false
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
