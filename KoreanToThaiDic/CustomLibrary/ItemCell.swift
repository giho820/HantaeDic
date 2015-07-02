//
//  ItemCell.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 1..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var label01_largeText: UILabel!
    @IBOutlet weak var label02_smallText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
