//
//  AGChatViewController+Constraints.swift
//  TestChatApp
//
//  Created by Pavel on 20.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

extension AGChatViewController {
    
    func setUpConstraintsForView(){
        inputBarView.translatesAutoresizingMaskIntoConstraints = false
        self.inputBarBottomSpacing = NSLayoutConstraint(item: self.inputBarView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        self.view.addConstraint(self.inputBarBottomSpacing)
        self.view.addConstraint(NSLayoutConstraint(item: self.inputBarView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.inputBarView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: inputBarView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.inputBarView.frame.size.height))
        self.view.addConstraint(NSLayoutConstraint(item: inputBarView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 43))
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.inputBarView, attribute: .top, multiplier: 1.0, constant: 0))

    }
    
}
