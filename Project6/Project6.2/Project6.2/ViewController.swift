//
//  ViewController.swift
//  Project6.2
//
//  Created by Елена Поспелова on 02/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var things = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        setupNavBar()
    }

    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(enterThing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                           target: self, action: #selector(share))
        
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return things.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = things[indexPath.row]
        return cell
    }

    func submit(_ answer: String) {
        things.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    @objc func share() {
        let item = things.joined(separator: "\n")
        let acVC = UIActivityViewController(activityItems: [item], applicationActivities: [])
        present(acVC, animated: true, completion: nil)
    }

    @objc func enterThing() {
        let avc = UIAlertController(title: "Enter name", message: nil, preferredStyle: .alert)
        avc.addTextField()
        
        let action = UIAlertAction(title: "Submit", style: .default) { [weak self, weak avc] action in
            guard let answer = avc?.textFields?.first?.text else { return }
            self?.submit(answer)
        }
        avc.addAction(action)
        avc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(avc, animated: true, completion: nil)
    }
}
