//
//  RecordViewController.swift
//  VoiceRecorderApp
//
//  Created by Oriana Gomez on 17/06/2020.
//  Copyright © 2020 Oriana Gomez. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsTable: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = "Voice Recorder"
        recordsTable.delegate = self
        recordsTable.dataSource = self
    }
    
    // MARK: Table View Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

