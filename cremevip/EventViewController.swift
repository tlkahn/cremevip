//
//  EventViewController.swift
//  cremevip
//
//  Created by toeinriver on 10/12/16.
//  Copyright © 2016 toeinriver. All rights reserved.
//

import VideoSplashKit
import UIKit
import WebKit
import MZFormSheetPresentationController
import Braintree
import SVProgressHUD

class EventViewController: VideoSplashViewController, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, BTDropInViewControllerDelegate {
    
    var scrollView: UIScrollView!
    
    var collectionIndex: Int?
    
    var contentOffset: CGPoint = CGPoint()
    
    var page: Double = 0
    
    var rightBarButtonItem: UIBarButtonItem?
    
    var formSheetController: MZFormSheetPresentationViewController = MZFormSheetPresentationViewController()
    
    var braintreeClient: BTAPIClient?
    
    var alertController: UIAlertController?
    
    var currentVideoUrl: String? = ""
    
    var indicator: UIActivityIndicatorView!
    
    var view1: UIView!
    
    var view2: WKWebView!
    
    var hasCamera: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentVideoUrl?.appendContentsOf("video")
        self.currentVideoUrl?.appendContentsOf(String(collectionIndex!))
        if (CardIOUtilities.canReadCardWithCamera()) {
            hasCamera = true
        }
        else {
            hasCamera = false
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: self.view.frame.height))
        
        let webConfiguration = WKWebViewConfiguration()
        view2 = WKWebView(frame: CGRect(x: 0, y: view1.frame.origin.y + view1.frame.height, width: scrollView.contentSize.width, height: view1.frame.height), configuration: webConfiguration)
        view2.UIDelegate = self
        view2.navigationDelegate = self
        let myURL = NSURL(string: "https://cremevip.wordpress.com/2016/10/15/party-real-hard-at-rubyskye/")
        let myRequest = NSURLRequest(URL: myURL!)
        view2.loadRequest(myRequest)
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(currentVideoUrl, ofType: "mp4")!)
        self.videoFrame = view1.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
        self.startTime = 12.0
        self.duration = 119.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.blackColor()
        self.contentURL = url
        self.restartForeground = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
        
        let bookingBtn = UIButton()
        let bookingBtnWidth : CGFloat = self.view.frame.width
        let bookingBtnHeight: CGFloat = 120.0
        let bookingBtnY: CGFloat = self.view.frame.height - bookingBtnHeight - (self.navigationController?.navigationBar.frame.height)!
        bookingBtn.frame = CGRect(x: 0, y: bookingBtnY, width: bookingBtnWidth, height: bookingBtnHeight)
        bookingBtn.backgroundColor = UIColor.blackColor()
        bookingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        bookingBtn.setTitle("Book Now", forState: .Normal)
        bookingBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        bookingBtn.addTarget(self, action: #selector(self.book(_:)), forControlEvents: .TouchUpInside)
        
        rightBarButtonItem = UIBarButtonItem.init(title: "Book Now", style: .Plain, target: self, action: #selector(self.book))
        
        view1.addSubview(bookingBtn)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        view.addSubview(scrollView)
        indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indicator.frame = CGRectMake(100.0, 100.0, 30.0, 30.0)
        indicator.center = view1.center
        view1.addSubview(indicator)
        indicator.bringSubviewToFront(view1)
        indicator.startAnimating()
        
        
    }
    
    func book(_: AnyObject) {
        print("book now")
        let modalView = ModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        modalView.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modalView.bottomButtonHandler = {[weak modal] in
            self.pay(modal!)
            return
        }
        modal.show(modalView: modalView, inView: window!)
    }
    
    func pay(sender: AnyObject) {
        print("pay")
        let modal = sender as! PathDynamicModal
        modal.closeWithLeansRandom()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("paymentNavVC") as! UINavigationController
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        let width = view.frame.width * 0.8
        let height = view.frame.height * 0.8
        formSheetController.presentationController?.contentViewSize = CGSize(width: width, height: height)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.interactivePanGestureDismissalDirection = .All
        
//        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
//        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
//        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
//        
//        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { (data, response, error) -> Void in
//            // TODO: Handle errors
//            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
//            
//            self.braintreeClient = BTAPIClient(authorization: clientToken!)
//            // As an example, you may wish to present our Drop-in UI at this point.
//            // Continue to the next section to learn more...
//            }.resume()
        
        if !hasCamera {
            
            let clientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI5ZGZkMjkyYmRlNWVkY2I1ZmI5ZTNjNjFmNjg0ODdlMTg1MzIyYWJlODExOWM1OTNhNTEzNTE5YWJiZTkzYzY4fGNyZWF0ZWRfYXQ9MjAxNi0xMC0xNFQxODoxNDozMi4yODQwNjYzMzMrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0="
            
            // If you haven't already, create and retain a `BTAPIClient` instance with a
            // tokenization key OR a client token from your server.
            // Typically, you only need to do this once per session.
            braintreeClient = BTAPIClient(authorization: clientToken)
            
            // Create a BTDropInViewController
            let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
            dropInViewController.delegate = self
            
            // This is where you might want to customize your view controller (see below)
            
            // The way you present your BTDropInViewController instance is up to you.
            // In this example, we wrap it in a new, modally-presented navigation controller:
            dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                target: self, action: #selector(self.userCancelPayment))
            
            navigationController.viewControllers = [dropInViewController]
            
        }
        
        else {
            let cardIOVc = storyboard.instantiateViewControllerWithIdentifier("cardIOVc") as! CardIOViewController
            navigationController.viewControllers = [cardIOVc]
            cardIOVc.eventVc = self
        }
        
        let presentedViewController = navigationController.viewControllers.first
        presentedViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(self.closeModal))
        
        self.presentViewController(formSheetController, animated: true, completion: nil)

    }
    
    func closeModal() {
        formSheetController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userCancelPayment() {
        print("user cancelled payment")
        formSheetController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        print("should postNonceToServer(paymentMethodNonce.nonce)")
        // postNonceToServer(paymentMethodNonce.nonce)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        showPaymentSuccess()
    
    }
    
    func showPaymentSuccess() {
        let modalView = PaymentSuccessModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        modal.showMagnitude = 500.0
        modal.closeMagnitude = 500.0
        modalView.dismissView = { [weak modal] in
            modal!.closeWithLeansRandom()
        }
        //        modalView.bottomButtonHandler = {[weak modal] in
        //            self.pay(modal!)
        //            return
        //        }
        modal.show(modalView: modalView, inView: window!)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func movieReadyToPlay() {
        print("movie ready")
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height = scrollView.frame.size.height;
        page = Double(scrollView.contentOffset.y / height)
        print("scrollViewDidScroll to ", page)
        if page > 0.3 {
            self.moviePlayer.player?.pause()
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
            self.navigationItem.hidesBackButton = true
        }
        else {
            self.moviePlayer.player?.play()
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.hidesBackButton = false
        }
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
        
}


