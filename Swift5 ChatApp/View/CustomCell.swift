//
//  CustomCell.swift
//  Swift5 ChatApp
//
//  Created by 平林宏淳 on 2020/05/28.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
