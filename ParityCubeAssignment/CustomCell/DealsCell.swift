//
//  DealsCell.swift
//  ParityCubeAssignment
//
//  Created by apple on 12/01/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
