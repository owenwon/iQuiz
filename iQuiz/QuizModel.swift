//
//  QuizModel.swift
//  iQuiz
//
//  Created by Owen Wong on 2/15/26.
//

import Foundation
import UIKit

struct Subject {
    let title: String
    let description: String
    let iconName: String
}

class QuizRepository {
    static let shared = QuizRepository()
    
    var topics: [Subject] = [
        Subject(title: "Mathematics", description: "numbers and equations", iconName: "math_icon"),
        Subject(title: "Marvel Super Heroes", description: "assemble those avengers", iconName: "marvel_icon"),
        Subject(title: "Science", description: "science lmao", iconName: "science_icon")
    ]
    
    func getTopics() -> [Subject] {
        return topics
    }
}
