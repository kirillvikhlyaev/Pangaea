//
//  CustomMessageCell.swift
//  Pangaea
//
//  Created by Кирилл on 05.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    @IBOutlet weak var messageBody: UIView!
    @IBOutlet weak var rightSenderImage: UIImageView!
    @IBOutlet weak var leftSenderImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
