//
//  Tbl_Cell.swift
//  EXPANDABLETABLEVIEW
//
//  Created by LaNet on 8/3/16.
//  Copyright © 2016 LaNet. All rights reserved.
//

import UIKit

class Tbl_Cell: UITableViewCell {

    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var btnMale: DownStateButton!
    
    @IBOutlet weak var btnFemale: DownStateButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMale?.downStateImage = "Checked-Checkbox"
        btnMale?.myAlternateButton = [btnFemale!]
        
        btnFemale?.downStateImage = "Checked-Checkbox"
        btnFemale?.myAlternateButton = [btnMale!]
        
        CellView.layer.cornerRadius = 10
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
