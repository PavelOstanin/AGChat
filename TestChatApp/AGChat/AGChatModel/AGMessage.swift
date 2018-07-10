//
//  AGMessage.swift
//  TestChatApp
//
//  Created by Pavel on 26.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

enum MessageType: String {
    case text
    case image
    case video
}

class AGMessage: NSObject {
    
    var ownerId: String?
    var text: String?
    var timeStamp: NSNumber?
    var imageUrl: String?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    var image: UIImage?
    var videoUrl: String?
    var type: MessageType {
        get {
            if image != nil || imageUrl != nil{
                return .image
            }
            else{
                return .text
            }
        }
    }

}
