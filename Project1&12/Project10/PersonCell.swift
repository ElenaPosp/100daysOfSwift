//
//  PersonCell.swift
//  Project10
//
//  Created by Елена Поспелова on 15/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

protocol PersonCellDelegate: class {
    func didSelectImage(at index: Int)
    func didSelectName(at index: Int)
}

final class PersonCell: UICollectionViewCell {

    var index: Int?
    weak var delegate: PersonCellDelegate?

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.isUserInteractionEnabled = true
            let gr = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            imageView.addGestureRecognizer(gr)
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.isUserInteractionEnabled = true
            let gr = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
            nameLabel.addGestureRecognizer(gr)
        }
    }

    @objc private func didTapImage() {
        guard let index = index else { return }
        delegate?.didSelectImage(at: index)
    }
    @objc private func didTapLabel() {
        guard let index = index else { return }
        delegate?.didSelectName(at: index)
    }
}
