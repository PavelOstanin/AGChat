//
//  AGChatViewController+Keyboard.swift
//  TestChatApp
//
//  Created by Pavel on 25.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

extension AGChatViewController {
    
    //MARK: UIKeyboardWillChangeFrameNotification Selector
    /**
     Moves AGInputBarView up and down accoridng to the location of the keyboard
     */
    @objc func keyboardNotification(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.inputBarBottomSpacing.constant = 0
                self.isKeyboardIsShown = false
            } else {
                if self.inputBarBottomSpacing.constant==0{
                    self.inputBarBottomSpacing.constant -= endFrame?.size.height ?? 0.0
                }
                else
                {
                    self.inputBarBottomSpacing.constant = 0
                    self.inputBarBottomSpacing.constant -= endFrame?.size.height ?? 0.0
                }
                self.isKeyboardIsShown = true
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded()
                            if self.isKeyboardIsShown {
//                                self.messengerView.scrollToLastMessage(animated: true)
                            }
            },
                           completion: nil)
            
        }
    }

    
}
