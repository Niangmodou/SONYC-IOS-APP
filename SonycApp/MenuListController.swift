//
//  MenuListController.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/23/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//
import Foundation
import UIKit

//credit to https://www.youtube.com/watch?v=iq-tWW45Vhk (Create Side Menu in App (Swift 5) Xcode 11 | 2020). Specific changes were made to conform to the project
class MenuListController: UITableViewController{
    //array for access to the recordings
    var items = ["Recordings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //shows one button since there is only 1 element in the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //shows the cell label text of the recordings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    //when the cell is pressed, it goes to a new screen to the recordings that were previously made
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "recordings") ; // recordings the storyboard ID
            self.present(vc, animated: true, completion: nil);
        }
    }
}
