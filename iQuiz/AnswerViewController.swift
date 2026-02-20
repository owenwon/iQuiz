//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Owen Wong on 2/19/26.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var topic: Subject?
    var currentQuestionIndex = 0
    var score = 0
    var selectedAnswerIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentTopic = topic else { return }
        
        let question = currentTopic.questions[currentQuestionIndex]
        questionLabel.text = question.text
        let correctAnswerText = question.answers[question.correctAnswerIndex]
        correctAnswerLabel.text = "Correct Answer: \(correctAnswerText)"
        
        if selectedAnswerIndex == question.correctAnswerIndex {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .systemGreen
            score += 1
        } else {
            resultLabel.text = "Incorrect!"
            resultLabel.textColor = .systemRed
        }
        
        let customBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnToMainList))
        self.navigationItem.leftBarButtonItem = customBackButton

        // Do any additional setup after loading the view.
    }
    
    @objc func returnToMainList() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    @IBAction func nextTapped(_ sender: Any) {
        guard let currentTopic = topic else { return }
        
        if currentQuestionIndex + 1 < currentTopic.questions.count {
            performSegue(withIdentifier: "toNextQuestionSegue", sender: self)
        } else {
            performSegue(withIdentifier: "toFinishedSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextQuestionSegue" {
            if let nextQuestionVC = segue.destination as? QuestionViewController {
                nextQuestionVC.topic = self.topic
                nextQuestionVC.score = self.score
                nextQuestionVC.currentQuestionIndex = self.currentQuestionIndex + 1
            }
        }
        
        
        if segue.identifier == "toFinishedSegue" {
            if let finishedVC = segue.destination as? FinishedViewController {
                finishedVC.topic = self.topic
                finishedVC.score = self.score
            }
        }
         
    }
    

}
