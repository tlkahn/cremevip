//
//  CardIOViewController.swift
//  cremevip
//
//  Created by toeinriver on 10/17/16.
//  Copyright © 2016 toeinriver. All rights reserved.
//

import UIKit

class CardIOViewController: UIViewController, CardIOViewDelegate {
    
    var eventVc : EventViewController!
    
    var cardIOView : CardIOView!
    
    override func viewWillAppear(animated: Bool) {
        CardIOUtilities.preloadCardIO()
//        view.viewWithTag(111)?.frame = view.frame
        cardIOView.frame = view.frame
    }
    
    override func viewDidLoad() {
        cardIOView = CardIOView(frame: view.bounds)
        cardIOView.delegate = self
        cardIOView.tag = 111
        view.addSubview(cardIOView)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation == .Portrait ||  fromInterfaceOrientation == .Portrait {
            cardIOView.frame.origin.y = -40
        }
    }
    
    func cardIOView(cardIOView: CardIOView, didScanCard info: CardIOCreditCardInfo) {
        if info.scanned {
            // The full card number is available as info.cardNumber, but don't log that!
            print("Received card info. Number: \(info.redactedCardNumber), expiry: %02i/\(info.expiryMonth), cvv: \(info.expiryYear).")
            eventVc.closeModal()
            eventVc.showPaymentSuccess()
        }
        else {
            print("User cancelled payment info")
            // Handle user cancellation here...
        }
    }

}
