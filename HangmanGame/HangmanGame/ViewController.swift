//
//  ViewController.swift
//  HangmanGame
//
//  Created by Елена Поспелова on 12/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var letterButtons = [UIButton]()
    var targetWordTextField = UITextField()
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWordView()
        setupButtons()
        
        startGame()
    }
    
    private func startGame() {
        
    }

    private func setupButtons() {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -20),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 20)
            ])
        
        let width: Int = Int(view.frame.width/5)
        let higth: Int = Int(view.frame.height/10)
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * higth, width: width, height: higth)
                letterButton.frame = frame
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.cornerRadius = 5
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }

    @objc func letterTapped() {
        
    }
    
    private func setupWordView() {
        
    }
}

