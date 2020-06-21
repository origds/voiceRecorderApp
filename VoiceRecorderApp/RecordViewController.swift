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

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IQAudioRecorderViewControllerDelegate
{
    //GUI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsTable: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    
    //Data
    var audiosFilePath: Array<String> = []
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = "Voice Recorder App"
        recordsTable.delegate = self
        recordsTable.dataSource = self
        
        recordButton.backgroundColor = UIColor.purple
        recordButton.layer.cornerRadius = 25
        recordButton.clipsToBounds = true
        recordButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        recordButton.addTarget(self, action: #selector(recordNewVoicenote), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: Table View Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audiosFilePath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let filePath = audiosFilePath[indexPath.row]
        
        if (!filePath.isEmpty)
        {
            let recordCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordTableViewCell
            recordCell.showAudioRecord(filePath: filePath)
            return recordCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            let filePath = audiosFilePath[indexPath.row]
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        } catch let error {
            print("No se puede reproducir el audio debido al siguiente error \(error.localizedDescription)")
        }
        
        audioPlayer?.play()
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
            self.recordsTable.reloadData()
        }
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

