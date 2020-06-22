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
    func resourceDatasourceDidSelectAudio(filePath: String)
    func resourceDatasourceDidDeleteAudio(filePath: String)
    func resourceDatasourceDidRenameAudio(filePath: String)
}

class RecordDatasource: NSObject, UITableViewDataSource, UITableViewDelegate
{
    weak var delegate: RecordDatasourceDelegate?
    var audiosFilePath: Array<String>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audiosFilePath!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let filePath = audiosFilePath![indexPath.row]
        
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
        let filePath = self.audiosFilePath![indexPath.row]
        delegate?.resourceDatasourceDidSelectAudio(filePath: filePath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") {
            (action, view, completionHandler) in
            let filePath = self.audiosFilePath![indexPath.row]
            self.delegate?.resourceDatasourceDidDeleteAudio(filePath: filePath)
            self.audiosFilePath!.remove(at: indexPath.row)
            tableView.reloadData()
        }

        let rename = UIContextualAction(style: .normal, title: "Renombrar") {
            (action, view, completionHandler) in
            //
        }
        rename.backgroundColor = UIColor.blue

        return UISwipeActionsConfiguration(actions: [delete, rename])
    }
}
