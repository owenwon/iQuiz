//
//  QuizModel.swift
//  iQuiz
//
//  Created by Owen Wong on 2/15/26.
//

import Foundation
import UIKit

struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
    var correctAnswerIndex: Int {
        return (Int(answer) ?? 1) - 1
    }
}

struct Subject: Codable {
    let title: String
    let description: String
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "desc"
        case questions
    }
    
    var iconName: String {
        if title.lowercased().contains("math") { return "math_icon" }
        if title.lowercased().contains("marvel") { return "marvel_icon" }
        return "science_icon"
    }
}

class QuizRepository {
    static let shared = QuizRepository()
    
    private let localFileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("localQuizzes.json")
    }()
    
    private func saveToLocalStorage(topicsToSave: [Subject]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(topicsToSave)
            try data.write(to: localFileURL)
            print("saved quizzes to offline storage")
        } catch {
            print("failed to save quizzes to offline storage \(error)")
        }
    }
    
    private func loadFromLocalStorage() -> Bool {
        do {
            let data = try Data(contentsOf: localFileURL)
            let decoder = JSONDecoder()
            let savedTopics = try decoder.decode([Subject].self, from: data)
            self.topics = savedTopics
            print("successfully loaded quizzes from offline storage")
            return true
        } catch {
            print("failed to load quizzes from offline storage \(error)")
            return false
        }
    }
    
    var topics: [Subject] = [
        Subject(
            title: "Mathematics",
            description: "numbers and equations",
            questions: [
                Question(text: "What is 2 + 2?", answer: "2", answers: ["3", "4", "5", "22"]),
                Question(text: "What is 10 * 10?", answer: "1", answers: ["100", "200", "50", "10"]),
                Question(text: "Solve for x: 2x = 10", answer: "3", answers: ["1", "2", "5", "10"])
            ]
        ),
        Subject(
            title: "Marvel Super Heroes",
            description: "assemble those avengers",
            questions: [
                Question(text: "What's Iron Man's real name?", answer: "1", answers: ["Tony Stark", "Wade Wilson", "Peter Parker", "Bruce Banner"])
            ]
        ),
        Subject(
            title: "Science",
            description: "science lmao",
            questions: [
                Question(text: "Elemental sign for gold?", answer: "1", answers: ["Au", "Ag", "H2O", "Go"])
            ]
        )
    ]
    
    func getTopics() -> [Subject] {
        return topics
    }
    
    func fetchQuizzes(from urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            let _ = self.loadFromLocalStorage()
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let _ = self.loadFromLocalStorage( )
                    completion(false)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    let _ = self.loadFromLocalStorage( )
                    completion(false)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let downloadedTopics = try decoder.decode([Subject].self, from: data)
                
                self.saveToLocalStorage(topicsToSave: downloadedTopics)
                
                DispatchQueue.main.async {
                    self.topics = downloadedTopics
                    completion(true)
                }
            } catch {
                print("JSON decoding error: \(error)")
                DispatchQueue.main.async {
                    let _ = self.loadFromLocalStorage()
                    completion(false)
                }
            }
        }
        task.resume()
    }
}
