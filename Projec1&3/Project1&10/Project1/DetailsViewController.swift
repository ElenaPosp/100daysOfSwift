//
//  DetailsViewController.swift
//  Project1
//
//  Created by Елена Поспелова on 21/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let imgName = selectedImage {
            imageView.image = UIImage(named: imgName)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        var dataArray: [Data] = []
        if let imgData = imageView.image?.jpegData(compressionQuality: 0.8) {
            dataArray.append(imgData)
        } else {
            print("No img found")
        }
        if let nameData = selectedImage?.data(using: .utf8) {
            dataArray.append(nameData)
        }
        
        let vc = UIActivityViewController(activityItems: dataArray, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
}
