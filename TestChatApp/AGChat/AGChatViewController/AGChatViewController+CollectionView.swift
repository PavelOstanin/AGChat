//
//  AGChatViewController+CollectionView.swift
//  TestChatApp
//
//  Created by Pavel on 21.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit

extension AGChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        //        cell.chatLogController = self
        
        let messages = self.messages[indexPath.item]
        cell.message = messages
        cell.textView.text = messages.text
        setUpCell(cell: cell, messages: messages)
        
        if let text = messages.text {
            cell.bubbleWidthAnchor?.constant = estimatedHeightBasedOnText(text: text).width + 32
            cell.textView.isHidden = false
        } else if (messages.imageUrl != nil || messages.image != nil){
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, messages: AGMessage){
        cell.delegate = self
        //        if let profileImageUrl = self.user?.profileImageUrl {
        //            cell.profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        //        }
        
        //        if messages.fromId == Auth.auth().currentUser?.uid {
                    cell.bubbleView.backgroundColor = UIColor.clear
                    cell.bubbleView.layer.masksToBounds = true
                    cell.bubbleView.layer.cornerRadius = 16
                    cell.textView.textColor = UIColor.black
                    cell.bubbleView.layer.borderWidth = 1
                    cell.bubbleView.layer.borderColor = UIColor.black.cgColor
                    cell.profileImageView.isHidden = true
                    cell.bubbleViewRightAnchor?.isActive = true
                    cell.bubbleViewLeftAnchor?.isActive = false
        //        }else {
//        cell.bubbleView.backgroundColor = UIColor.clear
//        cell.bubbleView.layer.masksToBounds = true
//        cell.bubbleView.layer.cornerRadius = 16
//        cell.textView.textColor = UIColor.black
//        cell.bubbleView.layer.borderWidth = 1
//        cell.bubbleView.layer.borderColor = UIColor.black.cgColor
//        cell.textView.font = UIFont.init(name: "AvenirNext-Regular", size: 17)
//        cell.profileImageView.isHidden = false
//        cell.bubbleViewRightAnchor?.isActive = false
//        cell.bubbleViewLeftAnchor?.isActive = true
        //        }
        
        if let messageImageUrl = messages.imageUrl {
            cell.messageImageView.loadImagesUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else if let messageImage = messages.image{
            cell.messageImageView.image = messageImage
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else {
            cell.messageImageView.isHidden = true
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let text = message.text {
            height = estimatedHeightBasedOnText(text: text).height + 20
        }else if let imageWidth = message.imageWidth , let imageHeight = message.imageHeight {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        return CGSize.init(width: view.frame.width, height: height)
    }
    
    private func estimatedHeightBasedOnText(text: String) -> CGRect{
        let size = CGSize.init(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImagesUsingCacheWithUrlString(urlString:String){
        
        // check cache for image first
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        let url = NSURL(string: urlString)
        let urlRequest = URLRequest.init(url: url! as URL)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage.init(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject )
                    self.image = downloadedImage
                }
                //                self.image = UIImage.init(data: data!)
            }
        }).resume()
    }
}
