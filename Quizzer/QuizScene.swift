//
//  SwiftUIView.swift
//  Quizzer
//
//  Created by Dan Søndergaard on 22/05/2023.
//

import SwiftUI

struct QuizScene: View {
    @State private var questionCount = 1;
    
    var body: some View {
        NavigationView() {
            VStack(spacing: 0.0) {
                Text("Spørgsmål \(questionCount)!")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                
                VStack(spacing: 24.0) {
                    HStack() {
                        Text("""
Who was the only god
from Greece who did
not get a name change
in Rome?
""")
                        .multilineTextAlignment(.center)
                        .padding(2.0)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    }
                    
                    HStack() {
                        VStack() {
                            
                            Text("Answer 1")
                                .multilineTextAlignment(.center)
                                .padding(.all, 2.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            Text("Answer 2")
                                .multilineTextAlignment(.center)
                                .padding(.all, 2.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        }
                        
                        VStack() {
                            Text("Answer 3")
                                .multilineTextAlignment(.center)
                                .padding(.all, 2.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            Text("Answer 4")
                                .multilineTextAlignment(.center)
                                .padding(.all, 2.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding(.vertical, 28.0)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        QuizScene()
    }
}
