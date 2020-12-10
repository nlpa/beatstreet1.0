//
//  StreetTableViewController.swift
//  beatstreet1.0
//
//  Created by Natalie Lampa on 12/9/20.
//

import UIKit

class StreetTableViewCell: UITableViewCell {

    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var streetImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
