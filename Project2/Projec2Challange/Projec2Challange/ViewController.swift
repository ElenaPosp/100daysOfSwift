//
//  ViewController.swift
//  Projec2Challange
//
//  Created by Елена Поспелова on 23/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

struct Flag {
    var name: String
    var image: UIImage?
}

class ViewController: UITableViewController {

    var flags = [Flag]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        items.forEach {
            if $0.hasPrefix("country_") {
                let img = UIImage(named: $0)
                let flag = Flag(name: $0, image: img)
                flags.append(flag)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        cell.imageView?.image = flags[indexPath.row].image
        cell.textLabel?.text = flags[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsViewController {
            vc.image = flags[indexPath.row].image
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

