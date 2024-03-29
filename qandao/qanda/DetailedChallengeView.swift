//
//  ChallengeInfoPageView.swift
//  qanda
//
//  Created by bill donner on 6/22/23.
//

import SwiftUI
import q20kshare


struct DetailedChallengeView: View {
  let challenge:Challenge
  
  @Environment(\.dismiss) var dismiss
  var body: some View {
    
    NavigationStack {
      ScrollView {
        VStack(spacing:20){
          HStack{ Text("The Challenge Generated By Chatbot")
            Spacer()
          }.font(.headline)
          VStack(spacing:5){
            HStack{
              Text("challenge id:")
              Spacer()
              Text(challenge.id )
            }
            HStack{
              Text("source:")
              Spacer()
              Text( challenge.aisource )
            }
            HStack{
              Text("generated:")
              Spacer()
              Text(challenge.date.formatted())
            }
            HStack{
              Text("topic:")
              Spacer()
              Text(challenge.topic)
            }
            HStack{
              Text("question:")
              Spacer()
              Text(challenge.question).font(.headline)
            }
            HStack{
              Text("answer:")
              Spacer()
              Text(challenge.correct).font(.headline)
            }
          }.borderedStyle(.blue)
          HStack{
            Text("Veracity Opinions From Other Chatbots").font(.headline)
            Spacer()
          }.font(.headline)
 //         VStack(spacing:5){

//          HStack{
//            Text("Prompt sent to ChatBot")
//            Spacer()
//          }.font(.headline)
//          VStack(spacing:5){
//            Text(decodeStringFromJSON(encodedString: challenge.prompt))
//              .borderedStyle(.blue)
//          }
        }
      }
      .navigationBarItems(leading:     Button {
        dismiss()
      } label: {
        Text("Done")
      })
      .navigationTitle("Challenge Details")
      .padding()
    }
  }
}




struct ChallengeInfoPageView_Previews: PreviewProvider {
  static let opinions = [
    Opinion(id: "1234-5678-91011", truth: Truthe.falseValue, explanation: "blah blah blah blah blah blah blah blah", opinionID: "9999999", source: "billbot-070-v2"),
    Opinion(id: "932823-abcd0393-11", truth: Truthe.trueValue, explanation: "blah blah blah blah blah blah blah blah", opinionID: "9999998", source: "bard-023-v3")
  ]
  static  let challenge = Challenge(question: "Why is the sky blue?", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good",id:"aa849-2339-23bcd",date:Date(),aisource:"snore.ai")
  static var previews: some View {
    DetailedChallengeView(challenge:challenge)
  }
  }
