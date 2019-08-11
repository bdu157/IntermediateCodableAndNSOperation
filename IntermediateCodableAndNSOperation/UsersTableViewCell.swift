//
//  UsersTableViewCell.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            self.updateView()
        }
    }
    
    var usersController = UsersController()

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!

    func updateView() {
        if let user = user {
            self.fullNameLabel.text = "\(user.title) \(user.first) \(user.last)"
//            usersController.getImages(for: user.thumbnail) { (result) in
//                if let result = try? result.get() {
//
//                    DispatchQueue.main.async {
//                        self.thumbnailImage.image = UIImage(data: result)
//                    }
//                }
//            }
//        } else {
//            print("there is no user being passed from tableVC")
        }
    }

}
