//
//  ViewController.swift
//  Project10
//
//  Created by Елена Поспелова on 15/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

final class ViewController: UICollectionViewController {
    private var persons = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .purple
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(add))
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "persons") as? Data {
            if let decodedPersons = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                persons = decodedPersons
            }
        }
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
        cell.delegate = self
        cell.index = indexPath.item
        cell.layer.cornerRadius = 7

        return cell
    }

    @objc private func addNewFromImagePicker() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) { picker.sourceType = .camera }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func addFromImages() {
        let tc = TableViewController()
        tc.delegate = self
        let nc = UINavigationController(rootViewController: tc)
        present(nc, animated: true)

    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc private func rename(at index: Int) {
        let ac = UIAlertController(title: "Enter the name", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.persons[index].name = ac.textFields?[0].text ?? ""
            self?.save()
            self?.collectionView.reloadData()
        }
        ac.addTextField(configurationHandler: nil)
        ac.addAction(action1)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: false)
    }
    
    @objc private func add() {
        let ac = UIAlertController(title: "Select action", message: nil, preferredStyle: .actionSheet)
        let addFromImagesAction = UIAlertAction(title: "addFromImages", style: .default) { [weak self] _ in
            self?.addFromImages()
        }
        let addNewFromImagePickerAction = UIAlertAction(title: "addNewFromImagePicker", style: .default) { [weak self] _ in
            self?.addNewFromImagePicker()
        }
        ac.addAction(addFromImagesAction)
        ac.addAction(addNewFromImagePickerAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }

    private func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: persons, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "persons")
            
        }
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
        save()
        collectionView.reloadData()

        dismiss(animated: true)
    }
}



extension ViewController: PersonCellDelegate {
    func didSelectImage(at index: Int) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            vc.selectedImage = persons[index].image
            vc.title = "Picture  \(persons[index].name) of \(persons.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectName(at index: Int) {
        let ac = UIAlertController(title: "Select action", message: nil, preferredStyle: .actionSheet)
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.rename(at: index)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.persons.remove(at: index)
            self?.save()
            self?.collectionView.reloadData()
        }
        ac.addAction(renameAction)
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }
}

extension ViewController: TableViewControllerDelegate {

    func didSelectImage(name: String, image: UIImage?) {
        guard let image = image else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: name, image: imageName)
        persons.append(person)
        save()
        collectionView.reloadData()
    }
}
