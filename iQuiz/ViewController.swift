//
//  ViewController.swift
//  iQuiz
//
//  Created by Owen Wong on 2/15/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return QuizRepository.shared.getTopics().count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let topic = QuizRepository.shared.getTopics()[indexPath.row]
        
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.description
        cell.imageView?.image = UIImage(named: topic.iconName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionSegue" {
            if let destinationVC = segue.destination as? QuestionViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let selectedTopic = QuizRepository.shared.getTopics()[indexPath.row]
                    destinationVC.topic = selectedTopic
                }
            }
        }
    }

}

