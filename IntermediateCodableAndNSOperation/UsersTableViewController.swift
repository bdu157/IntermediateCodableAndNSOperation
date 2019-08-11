//
//  UsersTableViewController.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

class UsersTableViewController: UITableViewController {
    
    
    let usersController = UsersController()
    let cachedData = Cache<String, Data>()
    let queue = OperationQueue()
    var operations : [String: Operation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersController.getUsers(numberOfResults: 1000) { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let customCell = cell as! UsersTableViewCell
        let user = self.usersController.users[indexPath.row]
        customCell.user = user
        self.loadImage(for: customCell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = usersController.users[indexPath.row]
        operations[user.email]?.cancel()
        print("cancelling is happening")
    }
    
    private func loadImage(for cell: UsersTableViewCell, indexPath: IndexPath) {
        let user = self.usersController.users[indexPath.row]
        
        //fetchPhoto
        let fetchPhotoOp = FetchPhotoOperation(user: user)
        
        //show cachedImage
        
        if let cachedImageData = cachedData.value(for: user.email) {
            cell.thumbnailImage.image = UIImage(data: cachedImageData)
            print("cachedImage: \(cachedImageData) is showing")
        } else {
        
        //cachePhoto
        let cachePhotoOp = BlockOperation {
            if let imageData = fetchPhotoOp.imageData {
            self.cachedData.cache(value: imageData, for: user.email)
            print("caching imageData : \(imageData) with key of \(user.email)")
                }
            }
        //
        let completionOp = BlockOperation {
            if let currentIndexPath = self.tableView.indexPath(for: cell) {
                if currentIndexPath != indexPath {return}
            }
            
            if let imageData = fetchPhotoOp.imageData {
                cell.thumbnailImage.image = UIImage(data: imageData)
                print("show image based on imageData from fetchPhoto")
                }
            }
        
        
        //add dependency
        cachePhotoOp.addDependency(fetchPhotoOp)
        completionOp.addDependency(fetchPhotoOp)
        
        queue.addOperation(fetchPhotoOp)
        queue.addOperation(cachePhotoOp)
        OperationQueue.main.addOperation(completionOp)
            
        self.operations[user.email] = fetchPhotoOp
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailVC" {
            guard let destVC = segue.destination as? UserDetailViewController,
            let selectedRow =  self.tableView.indexPathForSelectedRow else {return}
            destVC.user = self.usersController.users[selectedRow.row]
            destVC.usersController = self.usersController
            destVC.passedCachedData = self.cachedData
            }
        }
    }
