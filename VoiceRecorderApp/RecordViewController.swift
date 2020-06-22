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
    var audioName : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = "Voice Recorder App"
        
        datasource.audiosFilePath = audiosFilePath
        datasource.delegate = self
        datasource.table = recordsTable
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
            self.datasource.refresh()
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
    
    func resourceDatasourceDidSelectDeleteAudio(filePath: String, indexRow: Int)
    {
        let alert = UIAlertController(title: "Estás seguro de eliminar este audio?", message: "Si lo eliminas no podrás recuperarlo", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Si", style: .default, handler:{ action in
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: filePath)
                self.audiosFilePath.remove(at: indexRow)
                self.datasource.audiosFilePath = self.audiosFilePath
                self.datasource.refresh()
            } catch {
                print("No se puede eliminar de la carpeta: \(error)")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func resourceDatasourceDidSelectRenameAudio(filePath: String)
    {
        let alert = UIAlertController(title: "Renombrar audio", message: "Escribe el nuevo nombre", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Renombrar", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if (!(textField.text!.isEmpty))
            {
                self.audioName = textField.text!
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Voicenote"
        }
        alert.addAction(action)
        
        self.present(alert, animated:true)
        
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: filePath, toPath: "")
        } catch {
            print("No se puede renombrar debido a: \(error)")
        }
    }
}

