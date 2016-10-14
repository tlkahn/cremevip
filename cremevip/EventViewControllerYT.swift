//
//  EventViewControllerYT.swift
//  cremevip
//
//  Created by toeinriver on 10/13/16.
//  Copyright © 2016 toeinriver. All rights reserved.
//

import YouTubePlayer
import UIKit
import WebKit

class EventViewControllerYT: UIViewController, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, YouTubePlayerDelegate {
    
    var scrollView: UIScrollView!
    
    var contentOffset: CGPoint = CGPoint()
    
    var page: Double = 0
    
    var videoPlayer: YouTubePlayerView!
    
    var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    
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
        let myURL = NSURL(string: "https://www.apple.com")
        let myRequest = NSURLRequest(URL: myURL!)
        view2.loadRequest(myRequest)
        
        let videoPlayer = YouTubePlayerView(frame: view1.frame)
        view1.addSubview(videoPlayer)
        let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=AM-XbwjGAE4")
        videoPlayer.loadVideoURL(myVideoURL!)
        videoPlayer.delegate = self
        
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
        view1.addSubview(bookingBtn)
        
        rightBarButtonItem = UIBarButtonItem.init(title: "Book Now", style: .Plain, target: self, action: #selector(self.book))
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        
        
        view.addSubview(scrollView)
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
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    func book(_: AnyObject) {
        print("book now")
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func playerReady(videoPlayer: YouTubePlayerView) {
//        videoPlayer.seekTo(4.0, seekAhead: true)
//        videoPlayer.play()
    }
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
    }
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        
    }
    
    
}


