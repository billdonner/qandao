//
//  ThumbsView.swift
//  qanda
//
//  Created by bill donner on 7/7/23.
//

import SwiftUI
import q20kshare

struct ThumbsUpView: View {
  @EnvironmentObject var logManager: LogEntryManager
  let challenge:Challenge

  @Environment(\.dismiss) var dismiss
  @State private var isOn0 = false
  @State private var isOn1 = false
  @State private var isOn2 = false
  @State private var isOn3 = false
  @State private var isOn4 = false
  @State private var isOn5 = false
  @State private var isOn6 = false
  @State private var freeForm = ""
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Text(challenge.question).foregroundStyle(.blue).font(.headline)
          Text("Glad you enjoyed this Challenge. Please let us know why you liked it. Select all that apply:").padding([.top,.bottom])
        }
        Section {
          Toggle(isOn: $isOn0) {
            Text("It was clever")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn1) {
            Text("It was easy")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn2) {
            Text("It was hard")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn3) {
            Text("It was mind-bending")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn4) {
            Text("Explanation is poor or redundant")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn5) {
            Text("Irrelevant to topic")
          }.toggleStyle(.switch)
        }
        Section {
          Text("If you'd like to communicate your thoughts directly, please enter them here:").padding([.top])
          TextField("don't be shy", text: $freeForm,axis:.vertical)
            .textFieldStyle(.roundedBorder)
        }
      }.padding([.top])
        .navigationBarItems(trailing:     Button {
          // send upstream, kind of fire and forget
          let t = ThumbsUpRec(clever: isOn0, tooeasy: isOn1, toohard: isOn2, mindbending: isOn3, irrelevant: isOn4, badexplanation: isOn5, freeform: freeForm)
          sendThumbsUp(t, lem: logManager)
          dismiss()
        } label: {
          Text("Submit")
        })
        .navigationBarItems(leading:     Button {
          dismiss()
        } label: {
          Text("Cancel")
        })
        .navigationTitle("Thumbs Up")
    }
  }
}
struct ThumbsUpView_Previews: PreviewProvider {
  static var previews: some View {
    let ch = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good",id:"123",date:Date(),aisource: "xyxxy.ai")
    ThumbsUpView(challenge: ch).environmentObject(LogEntryManager.mock)
  }
}

struct ThumbsDownView: View {
  @EnvironmentObject var logManager: LogEntryManager
  let challenge:Challenge
  @Environment(\.dismiss) var dismiss
  @State private var isOn0 = false
  @State private var isOn1 = false
  @State private var isOn2 = false
  @State private var isOn3 = false
  @State private var isOn4 = false
  @State private var isOn5 = false
  @State private var freeForm = ""
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Text(challenge.question).foregroundStyle(.red).font(.headline)
          Text("Sorry you didn't like this Challenge.  Please let us know why you disliked it . Select all that apply:").padding([.top,.bottom])
        }
        Section {
          Toggle(isOn: $isOn0) {
            Text("It is inaccurate")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn1) {
            Text("It is too easy")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn2) {
            Text("It is too hard")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn3) {
            Text("It was mind-bending")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn4) {
            Text("Explanation is poor or redundant")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn5) {
            Text("Irrelevant to topic")
          }.toggleStyle(.switch)
        }
        Section {
          Text("If you'd like to communicate your thoughts directly, please enter them here:").padding([.top])
          TextField("don't be shy", text: $freeForm,axis:.vertical)
            .textFieldStyle(.roundedBorder)
        }
      }.padding([.top])
        .navigationBarItems(trailing:     Button {
          // send upstream
          // send upstream, kind of fire and forget
          let t = ThumbsDownRec(clever: isOn0, tooeasy: isOn1, toohard: isOn2, mindbending: isOn3, irrelevant: isOn4, badexplanation: isOn5, freeform: freeForm)
          
          sendThumbsDown(t, lem: logManager)
          dismiss()
        } label: {
          Text("Submit")
        })
        .navigationBarItems(leading:     Button {
          dismiss()
        } label: {
          Text("Cancel")
        })
        .navigationTitle("Thumbs Down")
    }
  }
}


struct ThumbsDownView_Previews: PreviewProvider {
  static var previews: some View {
    let ch = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good",id:"123",date:Date(),aisource: "xyxxy.ai")
    ThumbsDownView(challenge:ch).environmentObject(LogEntryManager.mock)
  }
}


struct InfoImageView: View {
  let imageName: String
  var body: some View {
    Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .clipped()
  }
}

struct RoundedTextViewGradient: View {
  let text: String
  let backgroundColor: Color
  let gradientColor: Color
  var body: some View {
    VStack {
      Text(text)
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.primary)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [gradientColor.opacity(0.1), backgroundColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(radius: 5))}}
}

struct RoundedTextViewNoGradient: View {
  let text: String
  let backgroundColor: Color
  var body: some View {
    VStack {
      Text(text)
        .multilineTextAlignment(.center)
        .font(.headline)
        .padding()
        .foregroundColor(.primary)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            .shadow(radius: 10)  )  } }
}
struct RoundedTextView_Previews: PreviewProvider {
  static var previews: some View {
    VStack{
      RoundedTextViewGradient(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor: .white.opacity(0.15), gradientColor: .red)
      Spacer()
      RoundedTextViewNoGradient(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor:   .white.opacity(0.15) )
    }
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
