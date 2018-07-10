//
//  AGChatBarView.swift
//  TestChatApp
//
//  Created by Pavel on 20.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit
import AVFoundation

class AGChatBarView: AGInputBarView, UITextViewDelegate {

    //MARK: IBOutlets
    //@IBOutlet for AGInputBarView
    @IBOutlet open weak var inputBarView: UIView!
    //@IBOutlet for send button
    @IBOutlet open weak var sendButton: UIButton!
    //@IBOutlets NSLayoutConstraint input area view height
    @IBOutlet open weak var textInputAreaViewHeight: NSLayoutConstraint!
    //@IBOutlets NSLayoutConstraint input view height
    @IBOutlet open weak var textInputViewHeight: NSLayoutConstraint!
    
    //MARK: Public Parameters
    //CGFloat to the fine the number of rows a user can type
    open var numberOfRows:CGFloat = 4
    //String as placeholder text in input view
    open var inputTextViewPlaceholder: String = "Write a message..."
        {
        willSet(newVal)
        {
            self.textInputView.text = newVal
        }
    }
    
    //MARK: Private Parameters
    //CGFloat as defualt height for input view
    fileprivate let textInputViewHeightConst:CGFloat = 32
    fileprivate let textInputViewBorderColorConst:CGColor = UIColor.init(red: 229.0/255, green: 229.0/255, blue: 229.0/255, alpha: 1).cgColor
    fileprivate let textInputViewBackgroundColorConst: UIColor = UIColor.init(red: 249.0/255, green: 250.0/255, blue: 251.0/255, alpha: 1)
    
    // MARK: Initialisers
    /**
     Initialiser the view.
     */
    public required init() {
        super.init()
    }
    
    /**
     Initialiser the view.
     - parameter controller: Must be AGChatViewController. Sets controller for the view.
     Calls helper method to setup the view
     */
    public required init(controller:AGChatViewController) {
        super.init(controller: controller)
        loadFromBundle()
    }
    /**
     Initialiser the view.
     - parameter controller: Must be AGChatViewController. Sets controller for the view.
     - parameter frame: Must be CGRect. Sets frame for the view.
     Calls helper method to setup the view
     */
    public required init(controller:AGChatViewController,frame: CGRect) {
        super.init(controller: controller,frame: frame)
        loadFromBundle()
    }
    /**
     - parameter aDecoder: Must be NSCoder
     Calls helper method to setup the view
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromBundle()
    }
    
    // MARK: Initialiser helper methods
    /**
     Loads the view from nib file InputBarView and does intial setup.
     */
    fileprivate func loadFromBundle() {
        inputBarView = Bundle(for: AGChatViewController.self).loadNibNamed("AGChatBarView", owner: self, options: nil)?[0] as! UIView
        self.addSubview(inputBarView)
        inputBarView.frame = self.bounds
        self.setupBarView()
        textInputView.delegate = self
        self.sendButton.isEnabled = false
    }
    
    //MARK: TextView delegate methods
    
    /**
     Implementing textViewShouldBeginEditing in order to set the text indictor at position 0
     */
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.textInputView.text == self.inputTextViewPlaceholder{
            textView.text = ""
        }
        textView.textColor = UIColor.darkGray
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.isEnabled = true
        })
        return true
    }
    /**
     Implementing textViewShouldEndEditing in order to re-add placeholder and hiding send button when lost focus
     */
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.textInputView.text.isEmpty {
            self.addInputSelectorPlaceholder()
        }
        self.textInputView.resignFirstResponder()
        return true
    }
    /**
     Implementing textViewDidChange in order to resize the text input area
     */
    open func textViewDidChange(_ textView: UITextView) {
        let newText = textView.text as NSString
        var textWidth: CGFloat = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding
        let boundingRect: CGRect = newText.boundingRect(with: CGSize(width: textWidth, height: 0), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font: textView.font!], context: nil)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
        
        if numberOfLines <= numberOfRows{
            textView.isScrollEnabled = false
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            textInputViewHeight.constant = newFrame.size.height
            
            textInputAreaViewHeight.constant = newFrame.size.height+10
        }
        else{
            textView.isScrollEnabled = true
        }
    }
    
    //MARK: TextView helper methods
    /**
     Adds placeholder text and change the color of textInputView
     */
    fileprivate func addInputSelectorPlaceholder() {
        self.textInputView.text = self.inputTextViewPlaceholder
        self.textInputView.textColor = UIColor.lightGray
    }
    
    //MARK: @IBAction selectors
    /**
     Send button selector
     Sends the text in textInputView to the controller
     */
    @IBAction open func sendButtonClicked(_ sender: AnyObject) {
        if self.textInputView.text != "" && self.textInputView.text != self.inputTextViewPlaceholder && !self.textInputView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            textInputViewHeight.constant = textInputViewHeightConst
            textInputAreaViewHeight.constant = textInputViewHeightConst+10
            self.inputViewDelegate?.sendButtonDidTouch(self.textInputView.text)
            self.textInputView.text = ""
            if !self.textInputView.isFirstResponder{
                addInputSelectorPlaceholder()
            }
        }
    }
    /**
     Plus button selector
     Requests camera and photo library permission if needed
     Open camera and/or photo library to take/select a photo
     */
    @IBAction open func plusClicked(_ sender: AnyObject?) {
        inputViewDelegate?.mediaButtonDidTouch()
    }
    
    func setupBarView(){
        let fixedWidth = textInputView.frame.size.width
        textInputView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textInputView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textInputView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textInputViewHeight.constant = newFrame.size.height
        textInputAreaViewHeight.constant = newFrame.size.height+10
        self.textInputAreaView.layer.cornerRadius = self.textInputAreaView.frame.size.height / 2
        self.textInputAreaView.layer.borderWidth = 1
        self.textInputAreaView.layer.borderColor = textInputViewBorderColorConst
        self.textInputAreaView.backgroundColor = textInputViewBackgroundColorConst
    }


}
