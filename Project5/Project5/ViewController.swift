//
//  ViewController.swift
//  Project5
//
//  Created by Елена Поспелова on 27/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        setupNav()
        startGame()
    }
    
    private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    private func submit(_ answer: String) {
        let errTitle: String
//        let errMessage: String
        let lowerAnser = answer.lowercased()
        if isPossible(word: lowerAnser){
            if isOriginal(word: lowerAnser) {
                if isReal(word: lowerAnser) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else { errTitle = "Not real" }
            } else { errTitle = "Not original" }
        } else { errTitle = "Not possible" }
        
        let ac = UIAlertController(title: errTitle, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else { return false }
        }
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range,
                                                            startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}
