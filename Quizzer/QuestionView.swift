//
//  QuistionView.swift
//  Quizzer
//
//  Created by Dan Søndergaard on 23/05/2023.
//

import SwiftUI

struct QuestionView: View {
    var questions: [Question]
    @State var shuffledAnswers = [String]()
    @State var questionCount = 0;
    @State var selectedAnswer: String?
    
    var body: some View {
        NavigationView() {
            VStack(spacing: 8.0) {
                Text("Question \(questionCount + 1)!")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                
                VStack(spacing: 24.0) {
                        
                        HStack() {
                            Text("\(questions[questionCount].question)")
                                .multilineTextAlignment(.center)
                                .padding(2.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        }
                    if shuffledAnswers.count >= 4 {
                        
                        HStack() {
                            VStack() {
                                
                                Text("1: \(shuffledAnswers[0])")
                                    .multilineTextAlignment(.center)
                                    .padding(.all, 2.0)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                Text("2: \(shuffledAnswers[1])")
                                    .multilineTextAlignment(.center)
                                    .padding(.all, 2.0)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            }
                            
                            VStack() {
                                Text("3: \(shuffledAnswers[2])")
                                    .multilineTextAlignment(.center)
                                    .padding(.all, 2.0)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                Text("4: \(shuffledAnswers[3])")
                                    .multilineTextAlignment(.center)
                                    .padding(.all, 2.0)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            }
                        }
                    }
                    
                }
                
                Button("Answer") {
                    if selectedAnswer != nil {
                        
                    } else {
                        print("Select an answer")
                    }
                    
                }
                .padding(.vertical, 4.0)
                
                Spacer()
                
            }
            .padding(.vertical, 28.0)
        }
        .onAppear() {
            shuffledAnswers = getAnswers(question: questions[questionCount])
        }
        
    }
    
    func getAnswers(question: Question) -> [String] {
        var answers = [String]()
        
        answers.append(question.correct_answer)
        answers.append(contentsOf: question.incorrect_answers)
        answers.shuffle()
        
        return answers
    }
}

struct QuistionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
