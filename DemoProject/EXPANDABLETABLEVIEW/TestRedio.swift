//
//  TestRedio.swift
//  EXPANDABLETABLEVIEW
//
//  Created by LaNet on 8/3/16.
//  Copyright © 2016 LaNet. All rights reserved.
//

import UIKit

class TestRedio: UIViewController {

    @IBOutlet weak var myRadioYesButton: DownStateButton!
    
    @IBOutlet weak var myRadioNoButton: DownStateButton!
    
    @IBOutlet weak var myRedio3: DownStateButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        myRadioNoButton?.downStateImage = "Checked-Checkbox"
        myRadioNoButton?.myAlternateButton = [myRadioYesButton!,myRedio3!]
        
        myRadioYesButton?.downStateImage = "Checked-Checkbox"
        myRadioYesButton?.myAlternateButton = [myRadioNoButton!,myRedio3!]
      
        myRedio3?.downStateImage = "Checked-Checkbox"
        myRedio3?.myAlternateButton = [myRadioNoButton!,myRadioYesButton!]
    
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
