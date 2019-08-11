//
//  UserDetailViewController.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
        self.updateViews()
        }
    }
    
    var usersController: UsersController? = nil
    
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    private func updateViews() {
        if let user = user,
            let usersController = usersController {
            self.nameLabel.text = "\(user.first)"
            self.phoneLabel.text = user.phone
            self.emailLabel.text = user.email
            
            usersController.getImages(for: user.large) { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        self.largeImage.image = UIImage(data: result)
                    }
                }
            }
        }
    }
}
