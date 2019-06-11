//
//  ViewController.swift
//  Project7
//
//  Created by Елена Поспелова on 03/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var urlString: String = ""
    var petitions = [Petition]()
    var stringForSearch = "" {
        didSet { executeFiltering() }
    }

    func executeFiltering() {
        DispatchQueue.global().async { [weak self] in
            guard let strSelf = self else {return}
            strSelf.setup()
            if strSelf.stringForSearch == "" { return }
            let a = strSelf.petitions
            strSelf.petitions = a.filter { (petition) -> Bool in
                let inBody = petition.body.lowercased().contains(strSelf.stringForSearch.lowercased())
                let inTitle = petition.title.lowercased().contains(strSelf.stringForSearch.lowercased())
                return inBody || inTitle
            }
            strSelf.tableView.performSelector(onMainThread: #selector(UITableView.reloadData),
                                              with: nil, waitUntilDone: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addNavItems()
    }
    
    private func addNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self, action: #selector(showInfo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(enterStringForSearch))
    }
    
    @objc func enterStringForSearch() {
        let ac = UIAlertController(title: "Enter string for", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        let handler: ((UIAlertAction) -> Void) = { _ in
            guard let str = ac.textFields?.first?.text else { return }
            self.stringForSearch = str
        }
        ac.addAction(UIAlertAction(title: "Search!", style: .cancel, handler: handler))
        present(ac, animated: true)
    }
    
    @objc func showInfo() {
        let ac = UIAlertController(title: "Info", message: "Data loaded from web site: \(urlString) ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    private func setup() {
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
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
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
