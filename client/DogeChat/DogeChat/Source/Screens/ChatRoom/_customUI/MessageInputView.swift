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

protocol MessageInputDelegate {
    func sendWasTapped(message: String)
}

class MessageInputView: UIView {
    
    // MARK: - Properties
    var delegate: MessageInputDelegate?
    
    let textView = UITextView()
    let sendButton = UIButton()
    
    // MARK: - Initializations
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        self.textView.layer.cornerRadius = 4
        self.textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.6).cgColor
        self.textView.layer.borderWidth = 1
        
        self.sendButton.backgroundColor = UIColor(red: 8/255, green: 183/255, blue: 231/255, alpha: 1.0)
        self.sendButton.layer.cornerRadius = 4
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.isEnabled = true
        
        self.sendButton.addTarget(self, action: #selector(MessageInputView.sendTapped), for: .touchUpInside)
        
        self.addSubview(textView)
        self.addSubview(sendButton)
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.bounds.size
        self.textView.bounds = CGRect(x: 0, y: 0, width: size.width - 32 - 8 - 60, height: 40)
        self.sendButton.bounds = CGRect(x: 0, y: 0, width: 60, height: 44)
        
        self.textView.center = CGPoint(x: self.textView.bounds.size.width/2.0 + 16,
                                       y: self.bounds.size.height/2.0)
        self.sendButton.center = CGPoint(x: self.bounds.size.width - 30 - 16,
                                         y: self.bounds.size.height/2.0)
        
    }
    
    // MARK: - Actions
    @objc func sendTapped() {
        if let delegate = self.delegate, let message = self.textView.text {
            delegate.sendWasTapped(message:  message)
            self.textView.text = ""
        }
    }    
}

extension MessageInputView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
