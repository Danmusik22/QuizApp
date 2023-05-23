//
//  ContentView.swift
//  Quizzer
//
//  Created by Dan Søndergaard on 22/05/2023.
//

import SwiftUI

enum Difficulty: String, CaseIterable{
    case EASY = "Easy"
    case MEDIUM = "Medium"
    case HARD = "Hard"
}

struct CategoryResponse: Codable {
    var trivia_categories: [Category]
}

struct QuestionResponse: Codable {
    var response_code: Int
    var results: [Question]
}

struct Category: Hashable, Codable {
    var id: Int
    var name: String
   
}

struct Question: Codable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
}

struct ContentView: View {
    @State var selectedDifficulty: Difficulty = .EASY
    @State var selectedCategory: Category?
    @State var categories = [Category]()
    @State var categoryStrings = [String]()
    @State var questions = [Question]()
    @State var isQuizViewActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                
                VStack(alignment: .leading, spacing: 4.0) {
                    
                    Image("rubber-duck.jpg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                    
                    HStack(alignment: .center) {
                        Text("Pick Difficulty")
                        Picker(selection: $selectedDifficulty, label: Text("Picker")){
                            ForEach(Difficulty.allCases, id: \.self) {d in
                                Text(d.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    HStack(alignment: .center) {
                        Text("Pick Category")
                        
/*
 Af en eller anden grund så vil den her
 Picker ikke opdatere selectedCategory
 Jeg mistænker at problemet er i
 fetchTriviaCategories() hvor selectedAnswer
 bliver sat til at være 1. element i categories
 Men hvis jeg fjerner det græder xcode, så jeg
 er ikke kommet frem til nogen løsning på det
 */
                        
                        Picker(selection: $selectedCategory, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                            ForEach(categories, id: \.self) {c in
                                Text(c.name);
                            }
                        }
                        .pickerStyle(.wheel)
                        .accentColor(.black)
                    }
                    
                    HStack(alignment: .center) {
                        
                        NavigationLink(destination: QuizView(questions: questions), isActive: $isQuizViewActive) {
                            
                            Button("Go to quiz") {
                                let catId = getCategoryId(category: selectedCategory!)

                                if (catId != nil) {
                                    Task {
                                        await fetchQuestions(amount: 5, categoryId: catId!, difficulty: selectedDifficulty)
                                        isQuizViewActive = true
                                    }
                                } else {
                                    print("Pick category")
                                }
                                
                            }
                        }
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 2.0)
                        .foregroundColor(.black)
                        .opacity(0.8)
                        .background(Color(red: 0, green: 0, blue: 1, opacity: 0.555))
                        .clipShape(Capsule())
                        
                        
                    }
                    .padding(.leading, 7.0)
                    
                }
                .padding()
            }
            .task {
                await fetchTriviaCategories()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Duck")
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
    
    func fetchTriviaCategories() async {
        guard let url = URL(string: "https://opentdb.com/api_category.php") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                let trivia_categories = decodedResponse.trivia_categories
                
                categories = trivia_categories.map { let category = Category(id: $0.id, name: $0.name)
                    return category
                }
                selectedCategory = categories[0];
            }
        } catch {
            print("Invalid data for Categories")
        }
    }
    
    func fetchQuestions(amount: Int, categoryId: Int, difficulty: Difficulty) async {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=\(String(amount))&category=\(categoryId)&difficulty=\(difficulty.rawValue.lowercased())&type=multiple") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(QuestionResponse.self, from: data) {
                questions = decodedResponse.results
            }
        } catch {
            print("Invalid data for Questions")
        }
    }
    
    func getCategoryId(category: Category) -> Int? {
        
        let category = categories.first(where: { (c) -> Bool in
            return c == category
        })
        return category?.id
    }
    
    func navigationToDestination(data: [Question]?) {
        
    }
}

struct QuizView: View {
    var questions: [Question]
    @State var shuffledAnswers = [String]()
    @State var questionCount = 0;
    @State var selectedAnswer: String?
    @State var answer1BgColor = Color.white
    @State var answer2BgColor = Color.white
    @State var answer3BgColor = Color.white
    @State var answer4BgColor = Color.white
    @State var hasAnswered = false;
    @State var correct: Bool?
    @State var endQuiz = false
    @State var correctAnswers: Int = 0
    
    var body: some View {
        NavigationView() {
            
            ZStack {
                Color.blue
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
                                .background(Color.white)
                        }
                        
                        if shuffledAnswers.count >= 4 {
                            
                            HStack() {
                                VStack() {
                                    
                                    Text("1: \(shuffledAnswers[0])")
                                        .multilineTextAlignment(.center)
                                        .padding(.all, 2.0)
                                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                        .background(answer1BgColor)
                                        .onTapGesture {
                                            selectedAnswer = shuffledAnswers[0]
                                            answer1BgColor = Color.green
                                            answer2BgColor = Color.white
                                            answer3BgColor = Color.white
                                            answer4BgColor = Color.white
                                        }
                                    Text("2: \(shuffledAnswers[1])")
                                        .multilineTextAlignment(.center)
                                        .padding(.all, 2.0)
                                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                        .background(answer2BgColor)
                                        .onTapGesture {
                                            selectedAnswer = shuffledAnswers[1]
                                            answer1BgColor = Color.white
                                            answer2BgColor = Color.green
                                            answer3BgColor = Color.white
                                            answer4BgColor = Color.white
                                        }
                                }
                                
                                VStack() {
                                    Text("3: \(shuffledAnswers[2])")
                                        .multilineTextAlignment(.center)
                                        .padding(.all, 2.0)
                                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                        .background(answer3BgColor)
                                        .onTapGesture {
                                            selectedAnswer = shuffledAnswers[2]
                                            answer1BgColor = Color.white
                                            answer2BgColor = Color.white
                                            answer3BgColor = Color.green
                                            answer4BgColor = Color.white
                                        }
                                    Text("4: \(shuffledAnswers[3])")
                                        .multilineTextAlignment(.center)
                                        .padding(.all, 2.0)
                                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                        .background(answer4BgColor)
                                        .onTapGesture {
                                            selectedAnswer = shuffledAnswers[3]
                                            answer1BgColor = Color.white
                                            answer2BgColor = Color.white
                                            answer3BgColor = Color.white
                                            answer4BgColor = Color.green
                                        }
                                }
                            }
                        }
                        
                    }
                    
                    if !hasAnswered {
                        Button("Answer") {
                            
                            if selectedAnswer != nil {
                                if selectedAnswer == questions[questionCount].correct_answer {
                                    correct = true
                                    correctAnswers += 1
                                } else {
                                    correct = false
                                }
                                hasAnswered = true
                                
                            } else {
                                print("Select an answer")
                            }
                            
                        }
                        .padding(.vertical, 4.0)
                        .foregroundColor(Color.black)
                    }
                    
                    Spacer()
                    
                    if hasAnswered {
                        VStack {
                            
                            if correct! {
                                Text("Correct!")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.green)
                                    .font(.title)
                                
                            } else {
                                Text("Wrong answer")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.red)
                                    .font(.title)
                            }
                            
                            if !endQuiz {
                                
                                Button("Next Question") {
                                    
                                    nextQuestion()
                                }
                                .foregroundColor(Color.black)
                            } else {
                                NavigationLink("See results", destination: ResultsView(correctAnswers: correctAnswers, questionAmount: questions.count))
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
                .padding(.vertical, 28.0)
                
            }
        }
        .navigationBarBackButtonHidden()
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
    
    func nextQuestion() {
            
        hasAnswered = false
        selectedAnswer = nil
        answer1BgColor = Color.white
        answer2BgColor = Color.white
        answer3BgColor = Color.white
        answer4BgColor = Color.white
        
        questionCount += 1
        
        shuffledAnswers = getAnswers(question: questions[questionCount])
        
        if questionCount >= questions.count-1 {
            endQuiz = true
        }
    }
}

struct ResultsView: View {
    var correctAnswers: Int
    var questionAmount: Int
   
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.blue
                
                VStack {
                    Spacer()
                    Text("Out of \(questionAmount) questions")
                    Text("You answered: \(correctAnswers) correct!")
                    Spacer()
                    NavigationLink("Back to menu", destination: ContentView())
                        .foregroundColor(Color.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .transition(.move(edge: .leading))
    }
}

