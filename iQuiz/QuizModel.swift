//
//  QuizModel.swift
//  iQuiz
//
//  Created by Owen Wong on 2/15/26.
//

import Foundation
import UIKit

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

struct Subject {
    let title: String
    let description: String
    let iconName: String
    let questions: [Question]
}

class QuizRepository {
    static let shared = QuizRepository()
    
    var topics: [Subject] = [
        Subject(
            title: "Mathematics",
            description: "numbers and equations",
            iconName: "math_icon",
            questions: [
                Question(text: "What is 2 + 2?", answers: ["3", "4", "5", "22"], correctAnswerIndex: 1),
                Question(text: "What is 10 * 10?", answers: ["100", "200", "50", "10"], correctAnswerIndex: 0),
                Question(text: "Solve for x: 2x = 10", answers: ["1", "2", "5", "10"], correctAnswerIndex: 2)
            ]
        ),
        Subject(
            title: "Marvel Super Heroes",
            description: "assemble those avengers",
            iconName: "marvel_icon",
            questions: [
                Question(text: "What's Iron Man's real name?", answers: ["Tony Stark", "Wade Wilson", "Peter Parker", "Bruce Banner"], correctAnswerIndex: 0)
            ]
        ),
        Subject(
            title: "Science",
            description: "science lmao",
            iconName: "science_icon",
            questions: [
                Question(text: "Elemental sign for gold?", answers: ["Au", "Ag", "H2O", "Go"], correctAnswerIndex: 0)
            ]
        )
    ]
    
    func getTopics() -> [Subject] {
        return topics
    }
}
