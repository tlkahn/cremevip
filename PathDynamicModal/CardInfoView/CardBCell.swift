//
//  CardBCell.swift
//  MMCardView
//
//  Created by MILLMAN on 2016/9/21.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MMCardView

public class CardBCell: CardCell,CardCellProtocol {

    @IBOutlet weak var imgV:UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var text: UILabel!
    
    public static func cellIdentifier() -> String {
        return "CardB"
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        imgV.layer.cornerRadius = 10.0
        imgV.layer.borderColor = UIColor.whiteColor().CGColor
        imgV.layer.borderWidth = 3.0
        imgV.frame.size.width = imgV.frame.size.width - 100
        imgV.clipsToBounds = true
        text.numberOfLines = 0
        text.sizeToFit()
        // Initialization code
    }

}
