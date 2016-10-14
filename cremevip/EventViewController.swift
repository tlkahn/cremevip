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

class EventViewController: VideoSplashViewController, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate {
    
    var scrollView: UIScrollView!
    
    var contentOffset: CGPoint = CGPoint()
    
    var page: Double = 0
    
    var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    
    var formSheetController: MZFormSheetPresentationViewController = MZFormSheetPresentationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: self.view.frame.height))
        
        let webConfiguration = WKWebViewConfiguration()
        let view2 = WKWebView(frame: CGRect(x: 0, y: view1.frame.origin.y + view1.frame.height, width: scrollView.contentSize.width, height: view1.frame.height), configuration: webConfiguration)
        view2.UIDelegate = self
        view2.navigationDelegate = self
        let myURL = NSURL(string: "http://localhost:8888/2016/10/14/5/")
        let myRequest = NSURLRequest(URL: myURL!)
        view2.loadRequest(myRequest)
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("video", ofType: "mp4")!)
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
        let presentedViewController = navigationController.viewControllers.first
        presentedViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(self.closeModal))
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        let width = view.frame.width * 0.8
        let height = view.frame.height * 0.8
        formSheetController.presentationController?.contentViewSize = CGSize(width: width, height: height)
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.interactivePanGestureDismissalDirection = .All
        self.presentViewController(formSheetController, animated: true, completion: nil)
        
    }
    
    func closeModal() {
        formSheetController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
        else {
            self.moviePlayer.player?.play()
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
}


