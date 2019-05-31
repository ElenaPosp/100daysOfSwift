//
//  ViewController.swift
//  Project6.1
//
//  Created by Елена Поспелова on 30/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var labels = [String: UILabel]()
    var previous: UILabel?

    func createLabel(_ name: String, color: UIColor) -> UILabel {
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = color
        label1.text = name
        label1.sizeToFit()
        return label1
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        let label1 = UILabel()
//        label1.translatesAutoresizingMaskIntoConstraints = false
//        label1.backgroundColor = .red
//        label1.text = "THESE"
//        label1.sizeToFit()
//
//        let label2 = UILabel()
//        label2.translatesAutoresizingMaskIntoConstraints = false
//        label2.backgroundColor = .cyan
//        label2.text = "ARE"
//        label2.sizeToFit()
//
//        let label3 = UILabel()
//        label3.translatesAutoresizingMaskIntoConstraints = false
//        label3.backgroundColor = .yellow
//        label3.text = "SOME"
//        label3.sizeToFit()
//
//        let label4 = UILabel()
//        label4.translatesAutoresizingMaskIntoConstraints = false
//        label4.backgroundColor = .green
//        label4.text = "AWESOME"
//        label4.sizeToFit()
//
//        let label5 = UILabel()
//        label5.translatesAutoresizingMaskIntoConstraints = false
//        label5.backgroundColor = .orange
//        label5.text = "LABELS"
//        label5.sizeToFit()
        
        labels = [ "label1": createLabel("THESE", color: .red),
                   "label2": createLabel("ARE", color: .cyan),
                   "label3": createLabel("SOME", color: .yellow),
                   "label4": createLabel("AWESOME", color: .green),
                   "label5": createLabel("LABELS", color: .orange) ]
        
        for label in labels { view.addSubview(label.value) }
        
        setupUIWithAncors()
    }
    
    func setupUIWithAncors() {
        for label in labels {
            label.value.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.value.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

//            label.value.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.value.heightAnchor.constraint(equalToConstant: view.frame.height/5 - 20).isActive = true
            
            if let previous = previous {
                label.value.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.value.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            previous = label.value
        }
    }
    
    func setupUIWithVisualFormat() {
        for key in labels.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(key)]|", options: [] ,
                                                               metrics: nil, views: labels))
        }
        
        let metrics =  ["labelHeight": 88]
        view.addConstraints(NSLayoutConstraint.constraints( withVisualFormat:
            "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|",
            options: [], metrics: metrics , views: labels))
    }
}

