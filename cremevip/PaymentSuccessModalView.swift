//
//  PaymentSuccessModalView.swift
//  cremevip
//
//  Created by toeinriver on 10/14/16.
//  Copyright © 2016 toeinriver. All rights reserved.
//

import UIKit

class PaymentSuccessModalView: UIView {
    var dismissView: (() -> Void)?
    
    class func instantiateFromNib() -> PaymentSuccessModalView {
        let view = UINib(nibName: "PaymentSuccessModalView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! PaymentSuccessModalView
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        self.layer.cornerRadius = 5.0
    }
    

    @IBAction func addToPassbook(sender: AnyObject) {
        dismissView?()
        
    }
    
    @IBAction func addToCalendar(sender: AnyObject) {
        dismissView?()
    }

}