//
//  RecordTableViewCell.swift
//  VoiceRecorderApp
//
//  Created by Oriana Gomez on 17/06/2020.
//  Copyright © 2020 Oriana Gomez. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var audioName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 4
        container.clipsToBounds = true
        
        playButton.backgroundColor = UIColor.purple
        playButton.layer.cornerRadius = 18
        playButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool)
    {
    }
    
    public func showAudioRecord(name: String!)
    {
        audioName!.text = name!
    }

}
