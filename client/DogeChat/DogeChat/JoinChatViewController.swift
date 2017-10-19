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

class JoinChatViewController: UIViewController {
    
    // MARK: - Properties
    let logoImageView = UIImageView()
    let shadowView = UIView()
    let nameTextField = TextField()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViews()
        
        self.view.addSubview(self.shadowView)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.nameTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.logoImageView.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.logoImageView.center = CGPoint(x: self.view.bounds.size.width/2.0,
                                            y: self.logoImageView.bounds.size.height/2.0 + self.view.bounds.size.height/4)
        self.shadowView.frame = self.logoImageView.frame
        
        self.nameTextField.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width - 40, height: 44)
        self.nameTextField.center = CGPoint(x: self.view.bounds.size.width/2.0,
                                            y: self.logoImageView.center.y + self.logoImageView.bounds.size.height/2.0 + 20 + 22)
    }
}

// MARK: - UI configurations
extension JoinChatViewController {
    
    func loadViews() {
        self.view.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        self.navigationItem.title = "Doge Chat!"
        
        self.logoImageView.image = UIImage(named: "doge")
        self.logoImageView.layer.cornerRadius = 4
        self.logoImageView.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowRadius = 5
        self.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.shadowView.layer.shadowOpacity = 0.5
        self.shadowView.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        
        self.nameTextField.placeholder = "What's your username?"
        self.nameTextField.backgroundColor = .white
        self.nameTextField.layer.cornerRadius = 4
        self.nameTextField.delegate = self
        
        let backItem = UIBarButtonItem()
        backItem.title = "Run!"
        self.navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - UITextFieldDelegate protocol
extension JoinChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let chatRoomVC = ChatRoomViewController()
        if let username = self.nameTextField.text {
            chatRoomVC.username = username
        }
        
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
        return true
    }
}
