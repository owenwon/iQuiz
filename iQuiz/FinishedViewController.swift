//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Owen Wong on 2/19/26.
//

import UIKit

class FinishedViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var topic: Subject?
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnToMainList))
        self.navigationItem.leftBarButtonItem = customBackButton

        guard let currentTopic = topic else { return }
        let total = currentTopic.questions.count
        
        scoreLabel.text = "\(score) of \(total) correct"
        
        let percentage = Double(score) / Double(total)
        
        if percentage == 1.0 {
            descriptionLabel.text = "Perfect!"
        } else if percentage >= 0.7 {
            descriptionLabel.text = "Almost!"
        } else {
            descriptionLabel.text = "Better luck next time!"
        }
    }
    
    @objc func returnToMainList() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
