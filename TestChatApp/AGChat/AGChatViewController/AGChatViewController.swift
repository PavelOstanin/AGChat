//
//  AGChatViewController.swift
//  TestChatApp
//
//  Created by Pavel on 18.06.2018.
//  Copyright © 2018 Agilie. All rights reserved.
//

import UIKit
import MobileCoreServices

open class AGChatViewController: UIViewController {

    //MARK: Views
    //This is messenger collection view
    @objc open var collectionView: UICollectionView!
    //This is input view
    open var inputBarView: AGInputBarView!
    
    open var isKeyboardIsShown : Bool = false
    
    //NSLayoutConstraint for the input bar spacing from the bottom
    var inputBarBottomSpacing:NSLayoutConstraint = NSLayoutConstraint()
    
    let cellId = "CellID"
    var messages = [AGMessage]()
    
    var user : Person? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let person = Person()
        person.name = "Test"
        person.id = "1"
        self.user = person
        loadMessengerCollectionView()
        loadInputView()
        setUpConstraintsForView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpKeyboardObservers()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    //////////////////////////
    
    fileprivate func loadMessengerCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 66), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.keyboardDismissMode = .interactive
        self.view.addSubview(self.collectionView)
    }

    fileprivate func loadInputView()
    {
        self.inputBarView = self.getInputBar()
        self.inputBarView.inputViewDelegate = self
        self.view.addSubview(inputBarView)
    }
    
    /**
     Override this method to create your own custom InputBarView
     - Returns: A view that extends InputBarView
     */
    open func getInputBar() -> AGInputBarView
    {
        return AGChatBarView(controller: self)
    }
    
    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func handelSelectedVideoForUrl(videoURL: URL) {
        //        let fileName = NSUUID().uuidString+".mov"
        //        let uploadTask = Storage.storage().reference().child("message_videos").child(fileName).putFile(from: videoURL, metadata: nil, completion: { (metadata, error) in
        //            if error != nil {
        //                print("Failed to upload the video:", error!)
        //            }
        //
        //            if let videoUrl = metadata?.downloadURL()?.absoluteString {
        //                if let thumbnailImage = self.thumnailImageForPrivateVideoUrl(videoUrl: videoURL){
        //                    self.uploadToFirebaseStorage(thumbnailImage, completion: { (imageUrl) in
        //                        let properties: [String: AnyObject] = ["imageUrl":imageUrl,"imageWidth":thumbnailImage.size.width , "imageHeight":thumbnailImage.size.height,"videoUrl": videoUrl] as [String: AnyObject]
        //                        self.sendMessageWithProperty(properties)
        //                    })
        //                }
        //            }
        //        })
        //
        //        uploadTask.observe(.progress) { (snapshot) in
        //            print(snapshot.progress?.completedUnitCount ?? " ")
        //        }
    }
    
    private func thumnailImageForPrivateVideoUrl(videoUrl: URL) -> UIImage?{
        //        let asset = AVAsset.init(url: videoUrl)
        //        let imageGenerator = AVAssetImageGenerator.init(asset: asset)
        //
        //        do {
        //            let thumbanailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
        //            return UIImage.init(cgImage: thumbanailCGImage)
        //        } catch let error {
        //            print(error)
        //        }
        //
        return nil
    }
    
    func handelSelectedImageForInfo(info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let origionalImage = info["UIImagePickerControllerOrigionalImage"] as? UIImage {
            selectedImageFromPicker = origionalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.sendMessageWithImageUrl(nil, selectedImage)
        }
    }
    
    private func uploadToFirebaseStorage(_ image: UIImage, completion:@escaping (_ imageUrl: String) -> ()) {
        //        let imageName = NSUUID().uuidString
        //        let ref = Storage.storage().reference().child("message_images").child(imageName)
        //        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
        //            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
        //                if error != nil {
        //                    print("Failed to Upload Image:",error!)
        //                    return
        //                }
        //
        //                if let imageUrl = metadata?.downloadURL()?.absoluteString {
        //                    completion(imageUrl)
        //                }
        //            })
        //        }
    }
    
    private func sendMessageWithImageUrl(_ imageUrl: String?, _ image: UIImage?){
        addMessage(text: nil, image: image, imageUrl: nil, imageWidht: image?.size.width, imageHeight: image?.size.height)
    }
    
    func addTextMessage(_ text: String, isIncoming: Bool){
        addMessage(text: text, image: nil, imageUrl: nil, imageWidht: nil, imageHeight: nil)
    }
    
    func addMessage(text: String?, image: UIImage?, imageUrl: String?, imageWidht: CGFloat?, imageHeight: CGFloat?){
        let message = AGMessage()
        message.text = text
        message.image = image
        message.imageUrl = imageUrl
        message.imageWidth = imageWidht
        message.imageHeight = imageHeight
        self.messages.append(message)
        self.collectionView?.reloadData()
        let indexpath = NSIndexPath.init(item: self.messages.count-1, section: 0)
        self.collectionView?.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
    }
    
    var startingFrame: CGRect?
    var backBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    @objc func handelZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.backBackgroundView?.alpha = 0
                self.inputAccessoryView?.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}

extension AGChatViewController: AGInputBarViewProtocol {
    
    public func sendButtonDidTouch(_ message: String) {
        addTextMessage(message, isIncoming: false)
    }
    
    public func mediaButtonDidTouch() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension AGChatViewController: ChatMessageCellDelegate {
    
    public func imageViewDidTouch(_ imageView: UIImageView) {
        self.startingImageView = imageView
        self.startingImageView?.isHidden = true
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        let zoomingImageView = UIImageView.init(frame: startingFrame!)
        zoomingImageView.image = imageView.image
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handelZoomOut)))
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow =  UIApplication.shared.keyWindow {
            
            backBackgroundView = UIView.init(frame: keyWindow.frame)
            if let backBackgroundView = backBackgroundView {
                backBackgroundView.backgroundColor = UIColor.black
                backBackgroundView.alpha = 0
                keyWindow.addSubview(backBackgroundView)
            }
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.backBackgroundView!.alpha = 1
                self.inputAccessoryView?.alpha = 0
                // calculate heright h2/w2 = h1/w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect.init(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }

    }
    
}
