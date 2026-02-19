//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Owen Wong on 2/19/26.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    var topic: Subject?
    
    var currentQuestionIndex = 0
    var score = 0
    var selectedAnswerIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
        // Do any additional setup after loading the view.
    }
    
    func loadQuestion() {
        guard let currentTopic = topic else { return }
        let question = currentTopic.questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        if question.answers.count >= 4 {
            answer1.setTitle(question.answers[0], for: .normal)
            answer2.setTitle(question.answers[1], for: .normal)
            answer3.setTitle(question.answers[2], for: .normal)
            answer4.setTitle(question.answers[3], for: .normal)
        }
        resetButtonColors()
    }
    
    func resetButtonColors() {
        selectedAnswerIndex = -1
        let buttons = [answer1, answer2, answer3, answer4]
        for button in buttons {
            button?.backgroundColor = .clear
            button?.setTitleColor(.systemBlue, for: .normal)
        }
    }
    

    @IBAction func answerTapped(_ sender: UIButton) {
        resetButtonColors()
        
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        
        if sender == answer1 { selectedAnswerIndex = 0 }
        else if sender == answer2 { selectedAnswerIndex = 1 }
        else if sender == answer3 { selectedAnswerIndex = 2 }
        else if sender == answer4 { selectedAnswerIndex = 3 }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if selectedAnswerIndex == -1 { return }
        performSegue(withIdentifier: "toAnswerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerSegue" {
            if let answerVC = segue.destination as? AnswerViewController {
                answerVC.topic = self.topic
                answerVC.currentQuestionIndex = self.currentQuestionIndex
                answerVC.selectedAnswerIndex = self.selectedAnswerIndex
                answerVC.score = self.score
            }
        }
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
