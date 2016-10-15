//
//  ViewController.swift
//  MMCardView
//
//  Created by Millman on 09/20/2016.
//  Copyright (c) 2016 Millman. All rights reserved.
//

import UIKit
import MMCardView
class EnrolledViewController: UIViewController,CardCollectionViewDataSource {
    
    @IBOutlet weak var card:CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.registerCardCell( CardACell.classForCoder(), nib: UINib.init(nibName: "CardACell", bundle: nil))
        card.registerCardCell( CardBCell.classForCoder(), nib: UINib.init(nibName: "CardBCell", bundle: nil))
        card.registerCardCell( CardCCell.classForCoder(), nib: UINib.init(nibName: "CardCCell", bundle: nil))
        card.cardDataSource = self
        let arr = self.generateCardInfo(10)
        card.set(arr)
        
        self.card.showStyle(.cover)
        
        //fix overlapping main screen to the left
        card.frame.origin.x = card.frame.origin.x + 100
        card.layoutIfNeeded()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func generateCardInfo (cardCount:Int) -> [AnyObject] {
        var arr = [AnyObject]()
//        let xibName = ["CardA","CardB","CardC"]
        
//        for _ in 1...cardCount {
//            let value = Int(arc4random_uniform(3))
//            arr.append(xibName[value] as AnyObject)
//        }
        arr.append("CardA" as AnyObject)
        arr.append("CardB" as AnyObject)
        arr.append("CardC" as AnyObject)

        return arr
    }
    
    func cardView(collectionView:UICollectionView,item:AnyObject,indexPath:NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(item as! String, forIndexPath: indexPath)
        switch cell {
            case let c as CardACell:
                c.txtView.text = "Party with DJ T. Maximus at RubySkye!"
            case let c as CardBCell:
                let v = Int(arc4random_uniform(5))+1
                c.imgV.image = UIImage.init(named: "image\(v)")            
            case let c as CardCCell:
                c.clickCallBack {
                    
                    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Second") as? SecondViewController {
                        self.card.presentViewController(to: vc)
                    }
                }
            default:
                return UICollectionViewCell()

        }
        return cell
    }
    
    @IBAction func segmentAction(seg:UISegmentedControl) {
        if (seg.selectedSegmentIndex == 0) {
            self.card.showStyle(.cover)
        } else {
            self.card.showStyle(.normal)
        }
    }
    
    @IBAction func filterAction () {
        let sheet = UIAlertController.init(title: "Filter", message: "Select you want to show in View", preferredStyle: .ActionSheet)

        let cellA = UIAlertAction(title: "CellA", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.card.filterAllDataWith( { (idex, obj) -> Bool in
                return (obj as! String) == "CardA"
            })
        })
        
        let cellB = UIAlertAction(title: "CellB", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.card.filterAllDataWith( { (idex, obj) -> Bool in
                return (obj as! String) == "CardB"
            })
        })
        
        let cellC = UIAlertAction(title: "CellC", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.card.filterAllDataWith( { (idex, obj) -> Bool in
                return (obj as! String) == "CardC"
            })
        })
        let abc = ["CardA","CardB", "CardC"]
        let cellABC = UIAlertAction(title: "CellA, CellB, CellC", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.card.filterAllDataWith({ (idex, obj) -> Bool in
                return abc.contains(obj as! String)
            })
        })
        
        let ac = ["CardA","CardC"]
        let cellAC = UIAlertAction(title: "CellA,CellC", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            self.card.filterAllDataWith({ (idex, obj) -> Bool in
                return ac.contains(obj as! String)
            })
        })
        
        let allCell = UIAlertAction(title: "CellAll", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
           self.card.showAllData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        sheet.addAction(cellA)
        sheet.addAction(cellB)
        sheet.addAction(cellC)
        sheet.addAction(cellAC)
        sheet.addAction(cellABC)
        sheet.addAction(allCell)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

