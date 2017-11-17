//
//  Redio.swift
//  EXPANDABLETABLEVIEW
//
//  Created by LaNet on 8/3/16.
//  Copyright © 2016 LaNet. All rights reserved.
//

import UIKit

class DownStateButton: UIButton {
    
    let uncheckedImage = UIImage(named: "Unchecked-Checkbox")! as UIImage
    let checkedImage = UIImage(named: "Checked-Checkbox")! as UIImage
    
    var myAlternateButton:Array<DownStateButton>?
    
    var downStateImage:String? = "Checked-Checkbox"
        {
        
        didSet{
            
            if downStateImage != nil {
                
                self.setImage(UIImage(named: downStateImage!), forState: UIControlState.Selected)
                
            }
        }
    }
    
    func unselectAlternateButtons(){
        
        if myAlternateButton != nil {
            
            self.selected = true
            
            for aButton:DownStateButton in myAlternateButton! {
                
                aButton.selected = false
            }
            
        }else{
            
            toggleButton()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches as! Set<UITouch>, withEvent: event)
    }
    
    
    func toggleButton(){
        
        if self.selected==false{
            
            self.selected = true
        }else {
            
            self.selected = false
        }
    }
}
