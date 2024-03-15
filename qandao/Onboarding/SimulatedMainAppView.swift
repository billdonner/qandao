//
//  SimulatedMainAppView.swift
//  transtest
//
//  Created by bill donner on 2/25/24.
//

import SwiftUI

// The main application view displayed after onboarding
struct SimulatedMainAppView: View {
  @AppStorage("onboardingCompleted") private var onboardingCompleted = false
  @AppStorage("level")  var selectedLevel: DifficultyLevel = .medium
  @AppStorage("topic")  var selectedTopic : SampleTopics = .Movies
  var body: some View {
    ZStack {
      FullMainView()
      VStack {
        Text("Welcome to the Simulated Main App!")
        Text("level is \(selectedLevel) ;  topic is \(selectedTopic)")
          .padding()
        Button("Restart Onboarding"){
          onboardingCompleted = false 
        }
      }
    }
    
//    @State var items = [
//        PickerItem(name: "Item 1", isEnabled: true),
//        PickerItem(name: "Item 2", isEnabled: false), // This item will be visible but not selectable.
//        PickerItem(name: "Item 3", isEnabled: true)
//    ]
//    PickerwDisable(prompt: "Pick first topic", items:$items)
  }
}

#Preview {
    SimulatedMainAppView()
}
