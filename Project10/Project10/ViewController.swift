//
//  ViewController.swift
//  Project10
//
//  Created by Елена Поспелова on 15/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var persons = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .purple
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell
        else { fatalError("Unable to dequeue cell") }

        let person = persons[indexPath.item]
        cell.nameLabel.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func rename(at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Enter the name", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.persons[indexPath.item].name = ac.textFields?[0].text ?? ""
            self?.collectionView.reloadData()
        }
        ac.addTextField(configurationHandler: nil)
        ac.addAction(action1)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: false)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let ash = UIAlertController(title: "Select action", message: nil, preferredStyle: .actionSheet)
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.rename(at: indexPath)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.persons.remove(at: indexPath.item)
            collectionView.reloadData()
        }
        ash.addAction(renameAction)
        ash.addAction(deleteAction)
        ash.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ash,animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        persons.append(person)
        collectionView.reloadData()

        dismiss(animated: true)
    }
}
