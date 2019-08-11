//
//  UserDetailViewController.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
        self.updateViews()
        }
    }
    
    var usersController: UsersController? = nil
    var passedCachedData: Cache<String, Data>?
    
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
            
            if let cachedData = passedCachedData?.value(for: user.phone) {
                self.largeImage.image = UIImage(data: cachedData)
                print("LargeImage is showing based on cachedData: \(cachedData)")
            } else {
            
            usersController.getImages(for: user.large) { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        self.largeImage.image = UIImage(data: result)
                    }
                    self.passedCachedData?.cache(value: result, for: user.phone)
                    print("caching the largeImageData")
                    }
                }
            }
        }
    }
}
