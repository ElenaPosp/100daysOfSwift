//
//  ViewController.swift
//  Project8
//
//  Created by Елена Поспелова on 05/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Colors {
        static let green = UIColor(red: 0.1, green: 0.5, blue: 0.3, alpha: 1)
        static let red = UIColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1)
    }
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()

    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var level = 1
    var answered = 0
    var score = 0 {
        didSet { scoreLabel.text = "Score: \(score)" }
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        setupScoreLabel()
        setupCluesLabel()
        setupAnswersLabel()
        setupCurrentAnswerTextField()
        setupButtons()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async { [weak self] in
            self?.loadLevel()
        }
    }

    func setupButtons() {
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 5
        submit.tintColor = Colors.green
        submit.layer.borderColor = Colors.green.cgColor
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.setTitle("CLEAR", for: .normal)
        clear.tintColor = Colors.red
        clear.layer.borderWidth = 1
        clear.layer.cornerRadius = 5
        clear.layer.borderColor = Colors.red.cgColor
        view.addSubview(clear)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            submit.widthAnchor.constraint(equalToConstant: 150),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            clear.widthAnchor.constraint(equalToConstant: 150),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

        let width = 150
        let higth = 80

        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
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

    func setupScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .left
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
                scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    func setupCluesLabel() {
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "Clues"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        NSLayoutConstraint.activate([
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100)
            ])
    }

    func setupAnswersLabel() {
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answers"
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        view.addSubview(answersLabel)
        
        NSLayoutConstraint.activate([
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor)
            ])
    }

    func setupCurrentAnswerTextField() {
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        NSLayoutConstraint.activate([
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20)
        ])
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            answered += 1

            if answered % 7 == 0 {
                let ac = UIAlertController(title: "Well done",
                                           message: "Are you ready for next level?",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            present(ac, animated: true)
            score -= 1
        }
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        DispatchQueue.global().async { [weak self] in
            self?.loadLevel()
            DispatchQueue.main.async {
                for b in self?.letterButtons ?? [] { b.isHidden = false }
            }
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for b in activatedButtons { b.isHidden = false }
        activatedButtons.removeAll()
    }

    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)",
                                              withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, value) in lines.enumerated() {
                    let parts = value.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        letterButtons.shuffle()

        DispatchQueue.main.async { [weak self] in
            guard let strSelf = self else { return }
            strSelf.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            strSelf.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

            if strSelf.letterButtons.count == letterBits.count {
                for i in 0..<strSelf.letterButtons.count {
                    self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
}
