//
//  ViewController.swift
//  Project7
//
//  Created by Елена Поспелова on 03/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        if tabBarController?.tabBarItem.tag == 0 {
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"

        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
        
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Loading error", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    private func parse(json: Data) {
        let decider = JSONDecoder()
        
        if let jsonPetitions = try? decider.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

