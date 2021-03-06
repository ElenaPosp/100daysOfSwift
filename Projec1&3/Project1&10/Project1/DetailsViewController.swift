//
//  DetailsViewController.swift
//  Project1
//
//  Created by Елена Поспелова on 21/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = getImage()
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

    @objc private func shareTapped() {
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

    private func getImage() -> UIImage? {
        guard let imageName = selectedImage else { return nil }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(imageName)
        return UIImage(contentsOfFile: path.path)
    }
}
