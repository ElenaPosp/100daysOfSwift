//
//  ViewController.swift
//  Project13
//
//  Created by Елена Поспелова on 24/03/2020.
//  Copyright © 2020 ---. All rights reserved.
//

import CoreImage
import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!

    private var currentImage: UIImage?
    private var context: CIContext?
    private var currentFilter: CIFilter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self
            , action: #selector(didTapAdd))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @IBAction func didTapChangeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
    }
    
    @IBAction func didTapSave() {
    }

    @IBAction func intensityChanged() {
        applyProcessing()
    }

    @objc
    private func didTapAdd() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    private func applyProcessing() {
        let inputKeys = currentFilter?.inputKeys
        if inputKeys?.contains(kCIInputIntensityKey) ?? false {
            currentFilter?.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys?.contains(kCIInputRadiusKey) ?? false {
            currentFilter?.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys?.contains(kCIInputScaleKey) ?? false {
            currentFilter?.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys?.contains(kCIInputCenterKey) ?? false {
            currentFilter?.setValue(CIVector(x: currentImage!.size.width/2,
                                             y: currentImage!.size.height/2),
                                    forKey: kCIInputCenterKey)
        }
        if
            let outputImage = currentFilter?.outputImage,
            let cgImage = context?.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }

    func setFilter(action: UIAlertAction) {
        guard
            let currentImage = currentImage,
            let filterName = action.title
        else { return }
        
        currentFilter = CIFilter(name: filterName)
        let beginImage = CIImage(image: currentImage)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: image)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}

extension ViewController: UINavigationControllerDelegate {
}
