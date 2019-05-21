//
//  ViewController.swift
//  Project2
//
//  Created by Елена Поспелова on 21/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var correctAnswer: Int = 0
    var score = 0
    var countries = [String]()
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle = ""
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
        } else {
            alertTitle = "Wrong"
            score -= 1
        }
        showAlert(title: alertTitle)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany",
                     "ireland", "italy", "monaco",
                     "nigeria", "poland", "russia",
                     "spain", "uk", "us"]
        
        setupBorders()
        askQuestion()
    }

    func askQuestion(_ sender: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        button1.setImage(UIImage(named: countries.first ?? ""), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    private func setupBorders() {
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func showAlert(title: String) {
        let message = "Your score is \(score)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
        ac.addAction(action)
        present(ac, animated: true)
    }
}

