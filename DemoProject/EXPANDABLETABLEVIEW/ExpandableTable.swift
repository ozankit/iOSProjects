//
//  ExpandableTable.swift
//  EXPANDABLETABLEVIEW
//
//  Created by LaNet on 8/3/16.
//  Copyright © 2016 LaNet. All rights reserved.
//

import UIKit

class ExpandableTable: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl: UITableView!
    var arrtitle = NSMutableArray()
    var isArrExpand = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        setArrValue()
        
         tbl.registerNib(UINib(nibName:"Tbl_Cell",bundle: nil ), forCellReuseIdentifier: "Tbl_Cell")
         tbl.registerNib(UINib(nibName:"Lb_Cell",bundle: nil ), forCellReuseIdentifier: "Lb_Cell")
         tbl.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }
    
    func setArrValue()
    {
        arrtitle.addObject("Personal Info")
        arrtitle.addObject("Academic")
        arrtitle.addObject("Interested Area")
        
        for var j in 0..<arrtitle.count
        {
            isArrExpand.addObject(false)
        }
        
    
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        

        
        return arrtitle.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isArrExpand[section] as! Bool == true)
        {
            return 5
            
        }
        
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1
        {
          return 43
        }
        return 152
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if  indexPath.section == 1
        {
            var cell = tableView.dequeueReusableCellWithIdentifier("Lb_Cell", forIndexPath: indexPath) as! Lb_Cell
            
            if indexPath.row == 0
            {
            var maskPath: UIBezierPath
            maskPath = UIBezierPath(roundedRect: cell.DisView.bounds, byRoundingCorners: ([.TopLeft, .TopRight]), cornerRadii: CGSizeMake(20.0, 20.0))
            var maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            cell.DisView.layer.mask = maskLayer
            }
            else if indexPath.row == 4
            {
                var maskPath: UIBezierPath
                maskPath = UIBezierPath(roundedRect: cell.DisView.bounds, byRoundingCorners: ([.BottomLeft, .BottomRight]), cornerRadii: CGSizeMake(20.0, 20.0))
                var maskLayer: CAShapeLayer = CAShapeLayer()
                maskLayer.path = maskPath.CGPath
                cell.DisView.layer.mask = maskLayer
            
            }
            
            return cell
        }
        else
        {
        var cell = tableView.dequeueReusableCellWithIdentifier("Tbl_Cell", forIndexPath: indexPath) as! Tbl_Cell
            
            return cell
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRectMake(0,0,400,40)
        headerView.clipsToBounds = true
       // headerView.layer.cornerRadius = 10
        headerView.backgroundColor = UIColor.lightGrayColor()
 
//        var maskPath: UIBezierPath
//        maskPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: ([.BottomLeft, .BottomRight,.TopLeft,.TopRight]), cornerRadii: CGSizeMake(20.0, 20.0))
//        var maskLayer: CAShapeLayer = CAShapeLayer()
//        maskLayer.path = maskPath.CGPath
//        headerView.layer.mask = maskLayer
        
        
        let lbtitle = UILabel()
        lbtitle.frame = CGRectMake(10, 5,UIScreen.mainScreen().bounds.width/2 , CGFloat(20))
        lbtitle.numberOfLines = 0
        lbtitle.text = arrtitle[section] as? String
        headerView.addSubview(lbtitle)
        let imgArrow = UIImageView()
        imgArrow.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 50, 5, 20, 20)
        if (isArrExpand[section] as! Bool)
            
            
        {
            var maskPath: UIBezierPath
            maskPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: ([.TopLeft,.TopRight]), cornerRadii: CGSizeMake(10.0, 10.0))
            var maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            headerView.layer.mask = maskLayer
             imgArrow.image = UIImage(named:"Arrow_Up")
            
        }
        else{
             imgArrow.image = UIImage(named:"Arrow")
        }
            let btnClick = UIButton()
        btnClick.frame = CGRectMake(0, 0,UIScreen.mainScreen().bounds.width , CGFloat(40))
        btnClick.backgroundColor = UIColor.clearColor()
        btnClick.addTarget(self, action:#selector(ExpandableTable.btnClick(_:)), forControlEvents: .TouchUpInside)
        btnClick.tag = section
        headerView.addSubview(imgArrow)
        headerView.addSubview(btnClick)
        return headerView
    }

    func btnClick(sender:UIButton)
    {
        let isExp = isArrExpand[sender.tag] as! Bool
        isArrExpand.replaceObjectAtIndex(sender.tag, withObject: !isExp)
        let indexSet = NSIndexSet(index: sender.tag)
        tbl.reloadSections(indexSet, withRowAnimation: .Fade)
   }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
