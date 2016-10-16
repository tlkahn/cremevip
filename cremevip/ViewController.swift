//
//  ViewController.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import CBStoreHouseRefreshControl

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let model = Model()
    
    var storeHouseRefreshControl: CBStoreHouseRefreshControl = CBStoreHouseRefreshControl()
    
    func refreshTriggered(sender aSender: AnyObject) -> Void {
        print("refreshTriggered")
        self.performSelector(#selector(self.finishRefreshControl), withObject: nil, afterDelay: 2, inModes: [NSRunLoopCommonModes])
    }
    
    func finishRefreshControl() {
        self.storeHouseRefreshControl.finishingLoading()
    }
 
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.blackColor()
        super.viewDidLoad()
        model.buildDataSource()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.collectionView, target: self, refreshAction: #selector(self.refreshTriggered(sender:)), plist: "storehouse", color: UIColor.whiteColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: true, internalAnimationFactor: 0.5)
        
        // Attach datasource and delegate
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.opaque = false
        self.navigationController?.navigationBar.topItem!.title = "Creme VIP - Rave like a pro"
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "din-regular", size: 24)!
        ]
        
        //Layout setup
        setupCollectionView()
        
        //Register nibs
        registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.headerHeight = 60.0
        
        // Collection view attributes
//        self.collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
    }
    
    // Register CollectionView Nibs
    func registerNibs(){
        
        // attach the UI nib file for the ImageUICollectionViewCell to the collectionview 
        let viewNib = UINib(nibName: "ImageUICollectionViewCell", bundle: nil)
        collectionView.registerNib(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var eventVc: EventViewController
        if indexPath.row == 0 {
            eventVc = EventViewControllerYT()
        }
        else {
            eventVc = EventViewController()
        }
        eventVc.collectionIndex = indexPath.row % 5 + 1
        self.navigationController?.pushViewController(eventVc, animated: true)
    }
    
    
    //MARK: - CollectionView Delegate Methods
    
     //** Number of Cells in the CollectionView */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    
    //** Create a basic CollectionView Cell */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Create the cell and return the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageUICollectionViewCell
        
        // Add image to cell
        cell.image.image = model.images[indexPath.row]
        cell.title.text = model.titles[indexPath.row]
        return cell
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        let imageSize = model.images[indexPath.row].size
        
        return imageSize
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl.scrollViewDidEndDragging()
    }
}

