//
//  TopicDetailView.swift
//  investment 101
//
//  Created by Celine Tsai on 9/8/23.
//

import SwiftUI
import WebKit

struct TopicDetailView: View {
    var topic: Topic
    
    @State private var isQuizButtonClicked = false
    @State private var htmlMessage = ""
    
    var body: some View {
        VStack {
            WebView(url: URL(string: topic.articleURL)!, messageHandler: $htmlMessage)
                .frame(height: UIScreen.main.bounds.height)
            
            Button(action: {
                isQuizButtonClicked = true
            }) {
                Text("Quiz time!!")
                    .foregroundColor(.white)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.1)
                    .background(Color(#colorLiteral(red: 0.0431372549, green: 0.1411764706, blue: 0.2784313725, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.top, 30)
            }
            .fullScreenCover(isPresented: $isQuizButtonClicked) {
                NavigationView {
                    QuizView(questions: topic.questions, isQuizButtonClicked: $isQuizButtonClicked)
                        .navigationBarTitle("Quiz", displayMode: .inline)
                        .navigationBarItems(leading: Button("Back") {
                            isQuizButtonClicked = false
                        })
                }
                .transition(.move(edge: .trailing)) // Slide from right to left
            }
        }
        .onAppear {
            WebViewManager.shared.setupMessageHandler(handler: htmlMessageHandler)
        }
    }
    
    private func htmlMessageHandler(message: String) {
        if message == "quiz" {
            isQuizButtonClicked = true
        }
    }
}






struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var messageHandler: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        WebViewManager.shared.setupWebView(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Handle any necessary navigation delegate methods if needed
    }
}


struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTopic = Topic(id: 3, name: K.unit3, articleURL: K.article21URL, questions: K.quiz21)
        return TopicDetailView(topic: sampleTopic)
    }
}

