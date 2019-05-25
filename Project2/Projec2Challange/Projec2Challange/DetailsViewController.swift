//
//  DetailsViewController.swift
//  Projec2Challange
//
//  Created by Елена Поспелова on 23/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.image = image
        mainImage.layer.borderWidth = 1
        mainImage.layer.borderColor = UIColor.lightGray.cgColor

        setupNavigation()
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}
