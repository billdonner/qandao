//
//  SwiftUIView.swift
//  transtest
//
//  Created by bill donner on 2/25/24.
//

import SwiftUI

// Define a simple model for the onboarding slides
struct OnboardingSlide {
    let title: String
    let description: String
    let image: String
    let kind: SlideKind
  
  enum SlideKind : String,CaseIterable{
    
    case plain
    case levelPicker
    case topicPicker
  }
}

// Define a difficulty level for the game

enum DifficultyLevel : String,CaseIterable,Identifiable {
  var id: String {self.rawValue}
  case easy
  case medium
  case hard
}

// Onboarding view that displays slides and a completion button on the last slide
struct OnboardingView: View {
    var completion: () -> Void
    @State private var slideIndex = 0
    @AppStorage("level")  var selectedLevel: DifficultyLevel = .medium
    @AppStorage("topic")  var selectedTopic : SampleTopics = .Movies
  func nextSlide() {
    if slideIndex == onboardingSlides.count - 1 {
      completion()
    } else {
      slideIndex += 1
    }
  }
    var body: some View {
        VStack {
          if slideIndex < onboardingSlides.count {
            singleSlideView(slide: onboardingSlides[slideIndex])
            switch onboardingSlides[slideIndex].kind {
              
            case .plain:
              Button("Next") {
                nextSlide()
              }.padding()
              
            case .levelPicker:
              VStack {
                Text("Select Difficulty:")
                  .font(.headline)
                Picker("Select Difficulty", selection: $selectedLevel) {
                  // Loop through all difficulty levels
                  ForEach(DifficultyLevel.allCases) { level in
                    Text(level.rawValue).tag(level).font(.largeTitle)
                  }
                }
                .pickerStyle(InlinePickerStyle())// You can adjust the picker style
                Button("Next") {
                  nextSlide()
                }.padding()
              .onChange(of: selectedLevel,initial:true) { val1,val2  in
                let _ =  print("Selected Level: \(val1.rawValue) \(val2.rawValue)")
              }
                Spacer()
              }
              .padding()
            case .topicPicker:
              VStack {
                Text("Select Topics:")
                  .font(.headline)

              let items = SampleTopics.allCases.map { PickerItem(  name:$0.rawValue, isEnabled:$0.rawValue.count<7)} // TODO: fix this

                PickerwDisable(prompt: "Select first topic:", items:items)
                
                Button("Next") {
                  nextSlide()
                }.padding()
              .onChange(of: selectedTopic,initial:true) { val1,val2  in
                let _ =  print("xxxSelected Topic: \(val1.rawValue) \(val2.rawValue)")
              }
                Spacer()
              }
              .padding()
            }
          }
        }
        .transition(.slide)
        .animation(.default, value: slideIndex)
    }
    
    @ViewBuilder
    func singleSlideView(slide: OnboardingSlide) -> some View {
        VStack {
          if slide.image == slide.image.lowercased() {
            Image(systemName: slide.image)
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .padding()
          } else {
            Image(slide.image)
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .padding()
          }
            Text(slide.title)
                .font(.title)
                .padding()
            Text(slide.description)
                .padding()
        }
    }
}
struct OnboardingScreen: View {
  @State var isPresented = false
  var body: some View {
    OnboardingView(){
      let _ = print("Done Onboarding")
      isPresented = true
    }
    .fullScreenCover (isPresented: $isPresented) {
      RootView()
    }
  }
}

struct DemoFullScreen: View {
    @State private var showMainView = false
    var body: some View {
        ZStack {
           OnboardingScreen()
                .opacity(showMainView ? 1 : 0) // Show one or the other
            VStack {
              AlienSplashView()
                    .opacity(showMainView ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(Animation.easeIn(duration:2.5).delay(0.5)) {
              showMainView = true // Start the transition
            }
        }
    }
}
#Preview {
  OnboardingScreen()
}
#Preview {
  DemoFullScreen()
}
//var items = [
//     PickerItem(name: "Item 1", isEnabled: true),
//     PickerItem(name: "Item 2", isEnabled: false), // This item will be visible but not selectable.
//     PickerItem(name: "Item 3", isEnabled: true)
// ]
//"Picker("Select First Topic", selection: $selectedTopic) {
//  // Loop through all topics
//  ForEach(SampleTopics.allCases) { level in
//    Text(level.rawValue).tag(level).font(.largeTitle)
//  }
//}
//.pickerStyle(InlinePickerStyle())// You can adjust the picker style"
