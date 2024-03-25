//
//  onboardingApp.swift
//  transtest
//
//  Created by bill donner on 2/25/24.
//

import Foundation
import SwiftUI

// Define a difficulty level for the game

enum SampleTopics : String,CaseIterable,Identifiable {
 var id: String {self.rawValue}
 case Movies,Music,Television,History,Politics,Space,Underwater,Stocks,Trump
}

// Define a simple base of slides for usage within onboarding presentation
let onboardingSlides = [
 OnboardingSlide(title: "Welcome to Q20K", description: "Play for a minute or an hour\nThis is the only time you will see this sequence", image: "Onboarding1",kind:.plain),
 OnboardingSlide(title: "What is Q20K?", description: "Twenty Thousand Questions. On Speed", image: "Onboarding2",kind:.plain),
 OnboardingSlide(title: "How to Win", description: "Answer as many questions as you can. Keep moving forward for bonus points...", image: "Onboarding3",kind:.plain),
 OnboardingSlide(title: "First Adjust Settings", description: "Pick Your Topics and Level", image: "Onboarding4",kind:.plain),
 OnboardingSlide(title: "Choose Difficulty Level", description: "Easy plays 3 topics\nMedium plays 5 topics\nHard plays 7 topics", image: "gear",kind:.levelPicker),
 OnboardingSlide(title: "Pick Your Topics", description: "Choose first in group", image: "person.3",kind:.topicPicker),
 OnboardingSlide(title: "Here We Go", description: "Let’s get started", image: "person.3",kind:.plain)
]
// Root Content View, switching views based on onboarding completion
struct RootView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    var body: some View {
        Group {
            if onboardingCompleted {
                SimulatedMainAppView()
            } else {
                OnboardingView { onboardingCompleted = true }
            }
        }
    }
}

#Preview {
  RootView() 
}
