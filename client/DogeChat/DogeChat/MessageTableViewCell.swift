/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

enum MessageSender {
    case ourself
    case someoneElse
}

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var messageSender: MessageSender = .ourself
    let messageLabel = Label()
    let nameLabel = UILabel()
    
    
    // MARK: - Initializations
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.messageLabel.clipsToBounds = true
        self.messageLabel.textColor = .white
        self.messageLabel.numberOfLines = 0
        
        self.nameLabel.textColor = .lightGray
        self.nameLabel.font = UIFont(name: "Helvetica", size: 10) //UIFont.systemFont(ofSize: 10)
        
        self.clipsToBounds = true
        
        self.addSubview(self.messageLabel)
        self.addSubview(self.nameLabel)
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isJoinMessage() {
            self.layoutForJoinMessage()
        }
        else {
            self.messageLabel.font = UIFont(name: "Helvetica", size: 17) //UIFont.systemFont(ofSize: 17)
            self.messageLabel.textColor = .white
            
            let size = self.messageLabel.sizeThatFits(CGSize(width: 2*(bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude))
            self.messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
            
            if self.messageSender == .ourself {
                self.nameLabel.isHidden = true
                
                self.messageLabel.center = CGPoint(x: bounds.size.width - self.messageLabel.bounds.size.width/2.0 - 16,
                                              y: bounds.size.height/2.0)
                self.messageLabel.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
            }
            else {
                self.nameLabel.isHidden = false
                self.nameLabel.sizeToFit()
                self.nameLabel.center = CGPoint(x: self.nameLabel.bounds.size.width/2.0 + 16 + 4,
                                                y: self.nameLabel.bounds.size.height/2.0 + 4)
                
                self.messageLabel.center = CGPoint(x: self.messageLabel.bounds.size.width/2.0 + 16,
                                                   y: self.messageLabel.bounds.size.height/2.0 + self.nameLabel.bounds.size.height + 8)
                self.messageLabel.backgroundColor = .lightGray
            }
        }
        
        self.messageLabel.layer.cornerRadius = min(self.messageLabel.bounds.size.height/2.0, 20)
    }
}

// MARK: - Messages
extension MessageTableViewCell {
    
    func apply(message: Message) {
        self.nameLabel.text = message.senderUsername
        self.messageLabel.text = message.message
        self.messageSender = message.messageSender
        self.setNeedsLayout()
    }
    
    func layoutForJoinMessage() {
        self.messageLabel.font = UIFont.systemFont(ofSize: 10)
        self.messageLabel.textColor = .lightGray
        self.messageLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        
        let size = self.messageLabel.sizeThatFits(CGSize(width: 2*(self.bounds.size.width/3),
                                                         height: CGFloat.greatestFiniteMagnitude))
        self.messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        self.messageLabel.center = CGPoint(x: self.bounds.size.width/2,
                                           y: self.bounds.size.height/2.0)
    }
    
    func isJoinMessage() -> Bool {
        if let words = self.messageLabel.text?.components(separatedBy: " ") {
            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
                return true
            }
        }
        return false
    }
}

// MARK: - Dimensions
extension MessageTableViewCell {
    
    // MARK: - Dimensions
    class func height(for message: Message) -> CGFloat {
        let maxSize: CGSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3),
                                     height: CGFloat.greatestFiniteMagnitude)
        let nameHeight: CGFloat = message.messageSender == .ourself ? 0 : (MessageTableViewCell.height(forText: message.senderUsername,
                                                                                                       fontSize: 10,
                                                                                                       maxSize: maxSize) + 4 )
        let messageHeight: CGFloat = MessageTableViewCell.height(forText: message.message, fontSize: 17, maxSize: maxSize)
        let result: CGFloat = nameHeight + messageHeight + 32 + 16
        return result
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedStringKey.font: font,
                                                                      NSAttributedStringKey.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
}


