//
//  TopicSelectorView.swift
//  basic
//
//  Created by bill donner on 7/9/24.
//
import SwiftUI

// A view for selecting topics from the full list.
 struct TopicSelectorView: View {
   //don't touch any of gamestate in here so we can back it all out if the user cancels out at any level
   
    let allTopics: [String]
    @Binding var selectedTopics: [String]
    @Binding var selectedSchemeIndex: ColorSchemeName
    let chmgr: ChaMan
    let gs:GameState
    let boardSize: Int
   
   @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var rerolledTopics: [String: String] = [:]  // Dictionary to keep track of rerolled topics

   var filteredTopics: [String] {
       if searchText.isEmpty {
           return allTopics.filter { !selectedTopics.contains($0) }
       } else {
           return allTopics.filter { $0.localizedCaseInsensitiveContains(searchText) && !selectedTopics.contains($0) }
       }
   }
   
   var body: some View {
     let maxTopics =  GameState.maxTopicsForBoardSize(boardSize)
     // let minTopics  =  GameState.minTopicsForBoardSize(boardSize)
     NavigationView{
       VStack(spacing: 5){
         TopicIndexView(gs: gs, chmgr: chmgr)
           .dismissable {
             //print("dismissed TopicsIndexView")
           }
//         VStack(spacing: 0){
//           //Text("board size:\(boardSize)x\(boardSize) requires \(minTopics)-\(maxTopics) topics.")
//           Text("You can select \(maxTopics - selectedTopics.count) more topics.")

//             .font(.subheadline)
//           Text("You can change a pre-selected topic for one gimmee.")
//             .font(.caption)
//             .padding(.bottom)
//         }.debugBorder()
         List {
           Section(header: Label("Current Fixed Topics",systemImage: "info.circle")) {
             ForEach(selectedTopics.prefix(GameState.preselectedTopicsForBoardSize(boardSize)), id: \.self) { topic in
               HStack {
                 Text(topic).font(.body)
               //  Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                 Spacer()
                 if let previousTopic = rerolledTopics[topic] {
                   Text(previousTopic)
                     .font(.footnote)
                     .foregroundColor(.gray)
                 } else {
                   Button(action: {
                     if let newTopic = allTopics.filter({ !selectedTopics.contains($0) }).randomElement() {
                       if let index = selectedTopics.firstIndex(of: topic) {
                         selectedTopics[index] = newTopic
                         rerolledTopics[newTopic] = topic
                       }
                     }
                   }) {
                     Text("replace?").opacity(gs.gimmees > 2 ? 1.0:0.5)
                       .font(.footnote)
                       .foregroundColor(.orange)
                   }.disabled(gs.gimmees <= 1)
                 }
               }
             }
           }
           
           Section(header: Label("Current Topics Chosen By You",systemImage: "info.circle")) {
             //For a boardsize of \(boardSize)x\(boardSize)
             Text("You can select \(maxTopics - selectedTopics.count) more topics.").font(.footnote).padding()
             ForEach(selectedTopics.dropFirst(GameState.preselectedTopicsForBoardSize(boardSize)), id: \.self) { topic in
               Button(action: {
                 if selectedTopics.contains(topic) {
                   selectedTopics.removeAll { $0 == topic }
                 }
               }) {
                 HStack {
                   Text(topic).font(.body)
                  // Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                   Spacer()
                   Text ("remove?")     .font(.footnote)
                     .foregroundColor(.orange)
                 }
               }
             }
           }
           
           Section(header: Text("Available Topics")) {
             ForEach(filteredTopics, id: \.self) { topic in
               Button(action: {
                 if !selectedTopics.contains(topic) && selectedTopics.count < maxTopics {
                   selectedTopics.append(topic)
                 }
               }) {
                 HStack {
                   Text(topic).font(.body)
                   //Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                   Spacer()
                   Text ("add?")     .font(.footnote)
                     .foregroundColor(.orange)
                 }
               }
             }
           }
         }.debugBorder()
       }
       .onAppear {
         // loadPersistentData()
         // print("//TopicSelectorView onAppear Topics: \(selectedTopics)")
       }
       .onDisappear{
         // print("//TopicSelectorView onDisappear Topics: \(selectedTopics)")
       }

       .navigationTitle("Choose Topics")
       .navigationBarTitleDisplayMode(.inline)
       .navigationBarItems(
        leading: Button("Cancel") {
          // dont touch anything
          self.presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("Done") {
          // onDonePressed() // update global state
          self.presentationMode.wrappedValue.dismiss()
        }
       )
     }
   }
}
