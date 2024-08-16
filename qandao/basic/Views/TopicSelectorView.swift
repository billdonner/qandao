//
//  TopicSelectorView.swift
//  basic
//
//  Created by bill donner on 7/9/24.
//
import SwiftUI
/// A view for selecting topics from the full list.
 struct TopicSelectorView: View {
   //don't touch any of gamestate in here so we can back it all out if the user cancels out at any level
   
    let allTopics: [String]
    @Binding var selectedTopics: [String]
    @Binding var selectedSchemeIndex: Int
    let chmgr: ChaMan
    let boardSize: Int
    @State private var searchText = ""
    @State private var rerolledTopics: [String: String] = [:]  // Dictionary to keep track of rerolled topics

    var body: some View {
      let maxTopics =  GameState.maxTopicsForBoardSize(boardSize)
      let minTopics  =  GameState.minTopicsForBoardSize(boardSize)
        VStack {
          Text("board size:\(boardSize)x\(boardSize) requires \(minTopics)-\(maxTopics) topics.")
            Text("You can select \(maxTopics - selectedTopics.count) more topics.")
                .font(.subheadline)
          Text("You can reroll the pre-selected topics once.\nAfter that you must pay in gimmees.")
              .font(.caption)
              .padding(.bottom)

            List {
                Section(header: Text("Pre-selected Topics")) {
               
                  ForEach(selectedTopics.prefix(GameState.preselectedTopicsForBoardSize(boardSize)), id: \.self) { topic in
                        HStack {
                          Text(topic).font(.body)
                          Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
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
                                    Text("reroll?")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Your Selected Topics")) {
                  ForEach(selectedTopics.dropFirst(GameState.preselectedTopicsForBoardSize(boardSize)), id: \.self) { topic in
                        Button(action: {
                            if selectedTopics.contains(topic) {
                                selectedTopics.removeAll { $0 == topic }
                            }
                        }) {
                            HStack {
                              Text(topic).font(.body)
                              Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }

                Section(header: Text("Remaining Topics")) {
                    ForEach(filteredTopics, id: \.self) { topic in
                        Button(action: {
                            if !selectedTopics.contains(topic) && selectedTopics.count < maxTopics {
                                selectedTopics.append(topic)
                            }
                        }) {
                            HStack {
                              Text(topic).font(.body)
                              Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Topics")
            .searchable(text: $searchText, prompt: "Search Topics")
        }
        .onAppear {
           // loadPersistentData()
          print("//TopicSelectorView onAppear Topics: \(selectedTopics)")
        }
        .onDisappear{
          print("//TopicSelectorView onDisappear Topics: \(selectedTopics)")
        }
    }

    var filteredTopics: [String] {
        if searchText.isEmpty {
            return allTopics.filter { !selectedTopics.contains($0) }
        } else {
            return allTopics.filter { $0.localizedCaseInsensitiveContains(searchText) && !selectedTopics.contains($0) }
        }
    }
}

//


