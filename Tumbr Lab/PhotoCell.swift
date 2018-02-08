//
//  PhotoCell.swift
//  Tumbr Lab
//
//  Created by Mo on 1/31/18.
//  Copyright © 2018 Mo. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var imageViewOutlet: UIImageView!
    var curl:URL?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
