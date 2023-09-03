//
//  QuizView.swift
//  investment 101
//
//  Created by Celine Tsai on 25/7/23.
//

import SwiftUI

struct QuizView: View {
    let questions: [Question]
    @Binding var isQuizButtonClicked: Bool

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var userAnswers: [String] = []
    @State private var shouldPresentEndOfQuiz = false
    @Environment(\.presentationMode) var presentationMode

    @State private var shuffledAnswerIndices: [Int] = []
    var body: some View {
        if questions.isEmpty {
            NoQuizView()
        } else {
            content
        }
    }
    var content: some View {
        NavigationView{
            VStack {
                // Question counter and progress bar
                HStack {
                    Text("Question \(currentQuestionIndex + 1)/\(questions.count)")
                        .font(.headline)
                        .padding()

                    Spacer()

                    ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                        .padding()
                }

                // Question
                Text(questions[currentQuestionIndex].text)
                    .font(.title)
                    .padding()

                Spacer()

                // Answer choices
                ForEach(shuffledAnswerIndices, id: \.self) { index in
                    Button(action: {
                        selectAnswer(index)
                    }) {
                        Text(questions[currentQuestionIndex].answers[index])
                            .font(.headline)
                            .frame(width: 320)
                            .padding()
                            .foregroundColor(getButtonTextColor(index))
                            .background(getButtonBackgroundColor(index))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .disabled(selectedAnswerIndex != nil)
                    }
                    .padding(.vertical, 5)
                }

                Spacer()

                // Confirm button
                Button(action: {
                    nextQuestion()
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(getConfirmButtonColor())
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .disabled(selectedAnswerIndex == nil)
                }
                .padding(.vertical, 10)
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationBarTitle("", displayMode: .inline)
            .background(
                NavigationLink(destination: EndOfQuizView(questions: questions, userAnswers: userAnswers), isActive: $shouldPresentEndOfQuiz) {
                    EmptyView()
                }
            )
            .onAppear {
                initializeQuiz()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }


    private var backButton: some View {
        Button(action: {
            confirmGoBack()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Are you sure you want to go back? Your progress will be lost."),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Go Back"), action: goBack)
            )
        }
    }

    @State private var showConfirmationAlert = false

    func confirmGoBack() {
        showConfirmationAlert = true
    }

    func goBack() {
        isQuizButtonClicked = false
        resetQuizState()
        presentationMode.wrappedValue.dismiss()
    }

    func resetQuizState() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        userAnswers = []
        shouldPresentEndOfQuiz = false
        shuffledAnswerIndices = []
    }


    func selectAnswer(_ index: Int) {
        if selectedAnswerIndex == index {
            selectedAnswerIndex = nil
        } else {
            selectedAnswerIndex = index
        }
    }

    func nextQuestion() {
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            return // Exit the function if no answer is selected
        }
        
        userAnswers.append(questions[currentQuestionIndex].answers[selectedAnswerIndex])
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            self.selectedAnswerIndex = nil // Reset the selected answer for the next question
        } else {
            shouldPresentEndOfQuiz = true
            return // Exit the function early to prevent further code execution
        }
        
        shuffledAnswerIndices = Array(0..<questions[currentQuestionIndex].answers.count)
        shuffledAnswerIndices.shuffle() // Shuffle the answer indices for the next question
    }


    func getButtonTextColor(_ index: Int) -> Color {
        if selectedAnswerIndex == index {
            return .white
        } else {
            return .black
        }
    }

    func getButtonBackgroundColor(_ index: Int) -> Color {
        if selectedAnswerIndex == index {
            return .blue
        } else {
            return .gray
        }
    }

    func getConfirmButtonColor() -> Color {
        if selectedAnswerIndex != nil {
            return .blue
        } else {
            return .gray
        }
    }

    func initializeQuiz() {
        shuffledAnswerIndices = Array(0..<questions[currentQuestionIndex].answers.count)
        shuffledAnswerIndices.shuffle() // Shuffle the initial answer indices
    }
}




