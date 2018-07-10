//
//  AGInputBarView.swift
//  TestChatApp
//
//  Created by Pavel on 20.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

open class AGInputBarView: UIView {

    //MARK: IBOutlets
    //@IBOutlets for input area view
    @IBOutlet open weak var textInputAreaView: UIView!
    //@IBOutlets for input view
    @IBOutlet open weak var textInputView: UITextView!
    
    var inputViewDelegate : AGInputBarViewProtocol?
    
    //MARK: Public Parameters
    
    //MARK: Private Parameters
    //AGChatViewController where to input is sent to
    open weak var controller:AGChatViewController!
    
    // MARK: Initialisers
    /**
     Initialiser the view.
     - parameter controller: Must be AGChatViewController. Sets controller for the view.
     Calls helper method to setup the view
     */
    public required init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    public required init(controller:AGChatViewController) {
        super.init(frame: CGRect.zero)
        self.controller = controller
    }
    /**
     Initialiser the view.
     - parameter controller: Must be AGChatViewController. Sets controller for the view.
     - parameter controller: Must be CGRect. Sets frame for the view.
     Calls helper method to setup the view
     */
    public required init(controller:AGChatViewController,frame: CGRect) {
        super.init(frame: frame)
        self.controller = controller
    }
    /**
     - parameter aDecoder: Must be NSCoder
     Calls helper method to setup the view
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
