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

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextTapped(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
