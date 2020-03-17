//
//  TableViewController.swift
//  Project112
//
//  Created by Елена Поспелова on 17/03/2020.
//  Copyright © 2020 Елена Поспелова. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate: class {
    func didSelectImage(name: String, image: UIImage?)
}

final class TableViewController: UITableViewController {
    
    private var pictures = [String]()

    weak var delegate: TableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture navigator"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        performSelector(inBackground: #selector(loadImgs), with: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(rateAppTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(dismissSelf))
    }

    @objc private func loadImgs() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        items.forEach {
            if $0.hasPrefix("nssl") { pictures.append($0) }
        }

        pictures.sort()
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = pictures[indexPath.row]
        cell?.imageView?.image = UIImage(named: pictures[indexPath.row])
        cell?.layer.borderWidth = 0.5
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectImage(name: pictures[indexPath.row], image: UIImage(named: pictures[indexPath.row]))
        dismissSelf()
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func rateAppTapped() {
        let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    private func getImage(index: Int) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(pictures[index])

        return UIImage(contentsOfFile: path.path)
    }
}

