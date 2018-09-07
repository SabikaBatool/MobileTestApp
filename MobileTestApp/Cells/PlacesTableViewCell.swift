//
//  PlacesTableViewCell.swift
//  MobileTestApp
//
//  Created by Sabika Batool on 9/5/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeRatingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
