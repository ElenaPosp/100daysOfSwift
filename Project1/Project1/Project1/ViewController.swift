//
//  ViewController.swift
//  Project1
//
//  Created by Елена Поспелова on 21/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        items.forEach {
            if $0.hasPrefix("nssl") {
                pictures.append($0)
            }
        }
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
}
