//
//  ViewController.swift
//  Project1
//
//  Created by Елена Поспелова on 21/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture navigator"

        performSelector(inBackground: #selector(loadImgs), with: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(rateAppTapped))
    }

    @objc func loadImgs() {
        sleep(3)
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        items.forEach {
            if $0.hasPrefix("nssl") { pictures.append($0) }
        }
    
        pictures.sort()
        print(pictures)
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? CollectionViewCell
        cell?.titleLabel?.text = pictures[indexPath.row]
        cell?.layer.borderWidth = 0.5
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.title = "Picture \(indexPath.row) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func rateAppTapped() {
        let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
