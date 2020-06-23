//
//  RecordViewController.swift
//  VoiceRecorderApp
//
//  Created by Oriana Gomez on 17/06/2020.
//  Copyright © 2020 Oriana Gomez. All rights reserved.
//

import UIKit
import CoreData
import IQAudioRecorderController
import AVFoundation

class RecordViewController: UIViewController, IQAudioRecorderViewControllerDelegate
{
    //GUI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsTable: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    
    //Data
    var audios: Array<Voicenote> = []
    var audioPlayer: AVAudioPlayer?
    var datasource = RecordDatasource()
    var audioName : String = ""
    var counter = 0
    var context: NSManagedObjectContext!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = "Voice Recorder App"
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        self.retrieveAudios()
        
        datasource.audios = audios
        datasource.delegate = self
        datasource.table = recordsTable
        recordsTable.delegate = datasource
        recordsTable.dataSource = datasource
        recordsTable.reloadData()
        
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
            let newVoicenote = Voicenote(name: "Voicenote \(self.counter)", filePath: filePath, context: self.context)
            self.audios.append(newVoicenote)
            self.datasource.audios = self.audios
            self.datasource.refresh()
            self.counter+=1
        }
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: CoreData
    
    func retrieveAudios()
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Voicenote>(entityName:"Voicenote")
            
            do {
                self.audios = try context.fetch(fetchRequest)
            } catch
            {
                print("Could not retrieve")
            }
        }
    }
}
    
// MARK: ResourceDatasourceDelegate
    
extension RecordViewController: RecordDatasourceDelegate
{
    func resourceDatasourceDidSelectAudio(voicenote: Voicenote)
    {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: voicenote.filePath!))
        } catch let error {
            print("Is not possible to play the audio because \(error.localizedDescription)")
        }
        audioPlayer?.play()
    }
    
    func resourceDatasourceDidSelectDeleteAudio(voicenote: Voicenote, indexRow: Int)
    {
        let alert = UIAlertController(title: "Estás seguro de eliminar este audio?", message: "Si lo eliminas no podrás recuperarlo", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Si", style: .default, handler:{ action in
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: voicenote.filePath!)
                let deleted = self.audios.remove(at: indexRow)
                self.context.delete(deleted)
                try self.context.save()
                self.datasource.audios = self.audios
                self.datasource.refresh()
            } catch {
                print("Can't be deleted: \(error)")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func resourceDatasourceDidSelectRenameAudio(voicenote: Voicenote)
    {
        let alert = UIAlertController(title: "Renombrar audio", message: "Escribe el nuevo nombre", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Renombrar", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if !(textField.text!.isEmpty)
            {
                self.audioName = textField.text!
                if !self.audioName.isEmpty
                {
                    voicenote.rename(newName: self.audioName, context: self.context)
                    self.retrieveAudios()
                    self.recordsTable.reloadData()
                }
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Voicenote"
        }
        alert.addAction(action)
        
        self.present(alert, animated:true)
    }
}

