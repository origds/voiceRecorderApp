//
//  RecordViewController.swift
//  VoiceRecorderApp
//
//  Created by Oriana Gomez on 17/06/2020.
//  Copyright © 2020 Oriana Gomez. All rights reserved.
//

import UIKit
import IQAudioRecorderController
import AVFoundation

class RecordViewController: UIViewController, IQAudioRecorderViewControllerDelegate
{
    //GUI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsTable: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    
    //Data
    var audiosFilePath: Array<String> = []
    var audioPlayer: AVAudioPlayer?
    var datasource = RecordDatasource()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = "Voice Recorder App"
        
        datasource.audiosFilePath = audiosFilePath
        datasource.delegate = self
        recordsTable.delegate = datasource
        recordsTable.dataSource = datasource
        
        recordButton.backgroundColor = UIColor.purple
        recordButton.layer.cornerRadius = 25
        recordButton.clipsToBounds = true
        recordButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        recordButton.addTarget(self, action: #selector(recordNewVoicenote), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: Action button
    
    @objc func recordNewVoicenote()
    {
        let vc = IQAudioRecorderViewController()
        vc.delegate = self
        vc.title = "Recorder"
        vc.maximumRecordDuration = 10
        vc.allowCropping = true
        vc.normalTintColor = UIColor.purple
        vc.highlightedTintColor = UIColor.purple
        self.presentBlurredAudioRecorderViewControllerAnimated(vc)
    }
    
    // MARK: IQAudioRecorderViewControllerDelegate
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String)
    {
        controller.dismiss(animated: true) {
            self.audiosFilePath.append(filePath)
            self.datasource.audiosFilePath = self.audiosFilePath
            self.recordsTable.reloadData()
        }
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
    
// MARK: ResourceDatasourceDelegate
    
extension RecordViewController: RecordDatasourceDelegate
{
    func resourceDatasourceDidSelectAudio(filePath: String)
    {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        } catch let error {
            print("No se puede reproducir el audio debido al siguiente error \(error.localizedDescription)")
        }
        audioPlayer?.play()
    }
    
    func resourceDatasourceDidDeleteAudio(filePath: String)
    {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func resourceDatasourceDidRenameAudio(filePath: String)
    {
        //
    }
}

