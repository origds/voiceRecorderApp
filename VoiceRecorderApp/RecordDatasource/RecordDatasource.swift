//
//  RecordDatasource.swift
//  VoiceRecorderApp
//
//  Created by Oriana Gomez on 22/06/2020.
//  Copyright © 2020 Oriana Gomez. All rights reserved.
//

import UIKit

protocol RecordDatasourceDelegate: AnyObject
{
    func resourceDatasourceDidSelectAudio(voicenote: Voicenote)
    func resourceDatasourceDidSelectDeleteAudio(voicenote: Voicenote, indexRow: Int)
    func resourceDatasourceDidSelectRenameAudio(voicenote: Voicenote)
}

class RecordDatasource: NSObject, UITableViewDataSource, UITableViewDelegate
{
    weak var delegate: RecordDatasourceDelegate?
    var audios: Array<Voicenote>?
    var table: UITableView?
    
    public func refresh()
    {
        self.table!.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let voicenote = audios![indexPath.row]
        
        if !voicenote.filePath!.isEmpty
        {
            let recordCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordTableViewCell
            recordCell.showAudioRecord(name: voicenote.name!)
            return recordCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let voicenote = self.audios![indexPath.row]
        delegate?.resourceDatasourceDidSelectAudio(voicenote: voicenote)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") {
            (action, view, completionHandler) in
            let voicenote = self.audios![indexPath.row]
            self.delegate?.resourceDatasourceDidSelectDeleteAudio(voicenote: voicenote, indexRow: indexPath.row)
        }

        let rename = UIContextualAction(style: .normal, title: "Renombrar") {
            (action, view, completionHandler) in
            let voicenote = self.audios![indexPath.row]
            self.delegate?.resourceDatasourceDidSelectRenameAudio(voicenote: voicenote)
        }
        rename.backgroundColor = UIColor.blue

        return UISwipeActionsConfiguration(actions: [delete, rename])
    }
}
