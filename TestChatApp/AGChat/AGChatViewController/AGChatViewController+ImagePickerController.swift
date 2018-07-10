//
//  AGChatViewController+ImagePickerController.swift
//  TestChatApp
//
//  Created by Pavel on 03.07.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

extension AGChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            handelSelectedVideoForUrl(videoURL: videoURL)
        } else {
            handelSelectedImageForInfo(info: info as [String : AnyObject])
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
