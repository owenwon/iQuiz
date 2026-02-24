//
//  ViewController.swift
//  iQuiz
//
//  Created by Owen Wong on 2/15/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
    let defaultsKey = "savedQuizURL"
    
    @IBAction func settingsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Enter URL for quiz data", preferredStyle: .alert)
        
        let currentURL = UserDefaults.standard.string(forKey: defaultsKey) ?? defaultURL
        
        alert.addTextField { textField in
            textField.placeholder = "https://..."
            textField.text = currentURL
            textField.clearButtonMode = .whileEditing
        }
        
        let checkNowAction = UIAlertAction(title: "Check Now", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let newURL = textField.text,
                  !newURL.isEmpty else { return }
            
            UserDefaults.standard.set(newURL, forKey: self.defaultsKey)
            
            QuizRepository.shared.fetchQuizzes(from: newURL) { success in
                if success {
                    print("settings fetch successful")
                    self.tableView.reloadData()
                } else {
                    print("settings fetch failed")
                    self.showNetworkErrorAlert()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(checkNowAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "Network error",
            message: "Unable to download quiz data. Please check internet connection or URL",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let savedURL = UserDefaults.standard.string(forKey: defaultsKey) ?? defaultURL
        
        QuizRepository.shared.fetchQuizzes(from: savedURL) { success in
            if success {
                print("Successfully downloaded new quizzes!")
                self.tableView.reloadData()
            } else {
                print("Failed to download quizzes. Using fallback data.")
                self.showNetworkErrorAlert()
            }
        }
    }
    
    @objc func handleRefresh() {
        let savedURL = UserDefaults.standard.string(forKey: defaultsKey) ?? defaultURL
        
        QuizRepository.shared.fetchQuizzes(from: savedURL) { success in
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                if success {
                    self.tableView.reloadData()
                    print("pull to refresh worked")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showNetworkErrorAlert()
                    }
                    
                }
            }
        }
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

