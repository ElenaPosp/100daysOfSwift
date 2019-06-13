//
//  ViewController.swift
//  HangmanGame
//
//  Created by Елена Поспелова on 12/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var enterLetterField = UITextField()
    var targetWordLabel = UILabel()
    var enterButton = UIButton()
    var words = ["world","peace","temptation"]
    var targetWord: String = ""
    var stringToDisplay: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        setupViews()
        enterLetterField.delegate = self
    }

    private func startGame() {
        words.shuffle()
        targetWord = words.first ?? ""
    }

    @objc func letterEntered() {
        guard let character = enterLetterField.text?.first else { return }
        for ch in targetWord { ch == character ? addCharacter(ch) : decrementScore() }
        enterLetterField.text = ""
    }

    private func addCharacter(_ character: Character) {
        
    }

    private func decrementScore() {
    }
    
    private func setupViews() {
        enterLetterField.translatesAutoresizingMaskIntoConstraints = false
        enterLetterField.placeholder = "Enter letter"
        enterLetterField.layer.borderWidth = 0.5
        enterLetterField.textAlignment = .center
        view.addSubview(enterLetterField)

        targetWordLabel.translatesAutoresizingMaskIntoConstraints = false
        targetWordLabel.font = UIFont.systemFont(ofSize: 24)
        targetWordLabel.textColor = .blue
        stringToDisplay = " "
        for _ in targetWord { stringToDisplay += "_ " }
        targetWordLabel.text = stringToDisplay
        targetWordLabel.textAlignment = .center
        view.addSubview(targetWordLabel)

        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.backgroundColor = .gray
        enterButton.setTitle("Enter", for: .normal)
        enterButton.addTarget(self, action: #selector(letterEntered), for: .touchUpInside)
        view.addSubview(enterButton)

        NSLayoutConstraint.activate([
            enterLetterField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 320),
            enterLetterField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 120),
            targetWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: enterLetterField.bottomAnchor,constant: 20),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.widthAnchor.constraint(equalToConstant: 80),
            enterButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        enterLetterField.allowsEditingTextAttributes = false
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count ?? 0
        return count > 0 ? false : true
    }
}
