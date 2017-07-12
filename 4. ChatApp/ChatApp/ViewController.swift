//
//  ViewController.swift
//  ChatApp
//
//  Created by Ryan Kim on 7/9/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import SwiftPhoenixClient

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldStackView: UIStackView!

    let socket = Socket(domainAndPort: "afternoon-sands-51684.herokuapp.com", path: "socket", transport: "websocket", prot: "https", params: ["user":"ryankim"])
    var topic: String? = "lobby"
    var messages: [UserMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(TextBubbleCell.self, forCellWithReuseIdentifier: "TextBubbleCell")
        
        establishSocketConnection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            bottomConstraint.constant = isKeyboardShowing ? (keyboardFrame?.height)! : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    self.scrollCollectionViewToBottom()
                }
            })
        }
    }
    
    func establishSocketConnection() {
        socket.join(topic: topic!, message: Message(subject: "status", body: "joining")) { channel in
            let chan = channel as! Channel
            
            //            chan.on(event: "join") { message in
            //                self.chatWindow.text = "You joined the room.\n"
            //            }
            
            
            chan.on(event: "new_message") { message in
                guard let convertedMessage = message as? Message,
                    let username = convertedMessage["name"],
                    let body     = convertedMessage["message"] else {
                        return
                }
                if username as? String != self.usernameTextField.text {
                    let newMessage = "[\(username)]:\n \(body)"
                    self.messages.append(UserMessage(body: "\(newMessage)", isSender: false))
                    self.collectionView.reloadData()
                    self.scrollCollectionViewToBottom()
                }
            }
            
            //            chan.on(event: "user:entered") { message in
            //                let username = "anonymous"
            //                self.chatWindow.text = self.chatWindow.text.appending("[\(username) entered]\n")
            //            }
            
            //            chan.on(event: "error") { message in
            //                guard let message = message as? Message,
            //                    let body = message["body"] else {
            //                        return
            //                }
            //                let newMessage = "[ERROR] \(body)\n"
            //                let updatedText = self.chatWindow.text.appending(newMessage)
            //                self.chatWindow.text = updatedText
            //            }
        }
    }
    
    func setupViews() {
        let topborderView = UIView()
        topborderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        textFieldStackView.addConstraintsWithFormat("H:|[v0]|", views: topborderView)
        textFieldStackView.addConstraintsWithFormat("V:|[v0(0.5)]", views: topborderView)
    }
    
    func scrollCollectionViewToBottom() {
        let lastIndexPath = NSIndexPath(item: (self.messages.count - 1), section: 0) as IndexPath
        self.collectionView.scrollToItem(at: lastIndexPath , at: UICollectionViewScrollPosition.bottom, animated: true)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        if let msg = msgTextField.text, let username = usernameTextField.text {
            let message = Message(message: ["name": username, "message": msg])
            let payload = Payload(topic: topic!, event: "new_message", message: message)
            socket.send(data: payload)
            msgTextField.text = ""
            
            let newMessage = "[\(username)]: \(msg)"
            self.messages.append(UserMessage(body: "\(newMessage)", isSender: true))
            self.collectionView.reloadData()
            self.scrollCollectionViewToBottom()
        }
        
//        print(message.toJsonString())
        

        
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextBubbleCell", for: indexPath) as! TextBubbleCell
        
        cell.profileImageView.image = UIImage(named: "user")
        cell.messageTextView.text = messages[indexPath.row].body
        
        let estimatedFrame = calculateHeight(indexPath: indexPath)
        
        if messages[indexPath.row].isSender {
            //outgoing messages
            cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 7, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
            cell.profileImageView.isHidden = true
            cell.bubbleImageView.image = TextBubbleCell.blueBubbleImage
            cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.messageTextView.textColor = UIColor.white
        } else {
            //incoming messages
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 4)
            cell.profileImageView.isHidden = false
            cell.bubbleImageView.image = TextBubbleCell.grayBubbleImage
            cell.bubbleImageView.tintColor = UIColor(white: 0.90, alpha: 1)
            cell.messageTextView.textColor = UIColor.black
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedFrame = calculateHeight(indexPath: indexPath)

        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        msgTextField.endEditing(true)
        usernameTextField.endEditing(true)
        
    }
    
    func calculateHeight(indexPath: IndexPath) -> CGRect {
        let messageText = messages[indexPath.row].body
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return estimatedFrame
    }
}
