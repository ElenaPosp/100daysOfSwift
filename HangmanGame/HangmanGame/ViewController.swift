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
    var words = ["world","peace","temptation","caption"]
    var targetWord: [String] = []
    var stringToDisplay: [String] = []
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
        targetWord = words.first?.map{ (ch) -> String in return "\(ch)" } ?? []

        score = 7
        stringToDisplay = []
        for _ in targetWord { stringToDisplay.append("_") }
        targetWordLabel.text = stringToDisplay.joined()
    }

    @objc func letterEntered() {
        guard let character = enterLetterField.text?.lowercased() else { return }
        var positions = [Int]()
        for (index, ch) in targetWord.enumerated() {
            if ch == character { positions.append(index) }
        }

        if positions.isEmpty {
            decrementScore()
        } else {
            addCharacter(indexes: positions)
            checkForFinish()
        }
        enterLetterField.text = ""
    }

    private func checkForFinish() {
        if !stringToDisplay.contains("_") {
            showWinAlert()
        }
    }

    private func addCharacter(indexes: [Int]) {

        for (index,value) in targetWord.enumerated() {
            if indexes.contains(index) {
                stringToDisplay[index] = value
            }
        }
        targetWordLabel.text = stringToDisplay.joined()
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
        targetWordLabel.textAlignment = .center
        view.addSubview(targetWordLabel)

        enterButton.translatesAutoresizingMaskIntoConstraints = false
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

    func showWinAlert() {
        showAlert(text: "You win!")
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
