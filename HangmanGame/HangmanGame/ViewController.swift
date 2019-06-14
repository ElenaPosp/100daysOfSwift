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
    var scoreLabel = UILabel()
    var words = ["world","peace","temptation"]
    var targetWord: String = ""
    var stringToDisplay: String = ""
    var score = 2 {
        didSet {
            scoreLabel.text = "\(score) attempts left"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        setupViews()
        enterLetterField.delegate = self
    }

    func startGame() {
        words.shuffle()
        targetWord = words.first ?? ""
    }
    
    func startGame(_ sender: UIAlertController) {
        words.shuffle()
        targetWord = words.first ?? ""
    }

    @objc func letterEntered() {
        guard let character = enterLetterField.text?.lowercased().first else { return }
        for ch in targetWord {
            if ch == character {
                addCharacter(ch)
                return
            }
        }
        decrementScore()
        enterLetterField.text = ""
    }

    private func addCharacter(_ character: Character) {
        
    }

    private func decrementScore() {
        score -= 1
        if score == 0 { showLoseAlert() }
        
    }
    
    private func setupViews() {
        enterLetterField.translatesAutoresizingMaskIntoConstraints = false
        enterLetterField.placeholder = "Enter letter"
        enterLetterField.textAlignment = .center
        view.addSubview(enterLetterField)

        targetWordLabel.translatesAutoresizingMaskIntoConstraints = false
        targetWordLabel.font = UIFont.systemFont(ofSize: 24)
        targetWordLabel.textColor = .blue
        stringToDisplay = ""
        for _ in targetWord { stringToDisplay += "_" }
        targetWordLabel.text = stringToDisplay
        targetWordLabel.textAlignment = .center
        view.addSubview(targetWordLabel)

        enterButton.translatesAutoresizingMaskIntoConstraints = false
//        enterButton.backgroundColor = .gray
        enterButton.setTitle("Enter", for: .normal)
        enterButton.setTitleColor(.blue, for: .normal)
        enterButton.addTarget(self, action: #selector(letterEntered), for: .touchUpInside)
        view.addSubview(enterButton)

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "\(score) attempts left"
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            enterLetterField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 320),
            enterLetterField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 120),
            targetWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: enterLetterField.bottomAnchor,constant: 20),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.widthAnchor.constraint(equalToConstant: 80),
            enterButton.heightAnchor.constraint(equalToConstant: 30),
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20)
        ])
        enterLetterField.allowsEditingTextAttributes = false
    }
    
    func showLoseAlert() {
        showAlert(text: "You lose")
    }
    
    func showAlert(text: String) {
        let ac = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start new game", style: .default) { [weak self] _ in
            self?.startGame()
        })
        present(ac,animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count ?? 0
        return count > 0 ? false : true
    }
}
