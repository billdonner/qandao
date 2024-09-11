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
  @Binding var selectedScheme: ColorSchemeName
  let chmgr: ChaMan
  let gs:GameState
  let minTopics:Int
  let maxTopics:Int
  @Binding var gimms: Int
  
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
  
  fileprivate func isNotReallyAvailable() -> Bool {
    return gimms<=0 || selectedTopics.count >= maxTopics//GameState.maxTopicsForBoardSize(boardSize)
  }
  
  fileprivate func isNotRemoveable() -> Bool {
    return gimms<=0 || selectedTopics.count <= minTopics//GameState.minTopicsForBoardSize(boardSize)
  }
  
  var body: some View {
    
    NavigationView{
      
      VStack(spacing: 5){
        VStack (alignment:.leading, spacing:0){
          Text("You must have between \(minTopics) and \(maxTopics) topics.")
          Text("You can select \(maxTopics - selectedTopics.count) more topics.")
          Text("Adding or removing a topic costs 1 gimmee.")
        }.font(.caption)//.padding()
        
        TopicIndexView(gs: gs,chmgr:chmgr,inPlayTopics: $selectedTopics, scheme:$selectedScheme )
          .dismissable {
            //print("dismissed TopicsIndexView")
          }
        
        
        Form {
          Section(header: HStack { Text("Active Topics"); Image(systemName: "info.circle"); Spacer()}) {
            
            ForEach(selectedTopics, id: \.self) { topic in
              HStack {
                Text(topic).font(.body)
                // Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                Spacer()
                Button(action: {
                  withAnimation {
                    if selectedTopics.contains(topic) {
                      selectedTopics.removeAll { $0 == topic }
                      gimms -= 1
                    }
                  }
                }) {
                  
                  Text ("remove?")     .font(.footnote)
                    .foregroundColor(.orange)
                    .opacity(isNotRemoveable() ? 0.0 : 1.0)
                }
              }
              .disabled(isNotRemoveable())
            }
          }
          
          Section(header: Text("Available Topics")) {
            ForEach(filteredTopics, id: \.self) { topic in
              HStack {
                Text(topic).font(.body)
                //Text("\(chmgr.freeChallengesCount(for: topic))").font(.caption2)
                Spacer()
                Button(action: { withAnimation {
                  if !selectedTopics.contains(topic) && selectedTopics.count < maxTopics {
                    selectedTopics.append(topic)
                    gimms -= 1
                  }
                }
                }) {
                  Text ("add?").font(.footnote)
                    .foregroundColor(.orange)
                    .opacity(isNotReallyAvailable() ? 0.0:1.0)
                }
              }.disabled(isNotReallyAvailable())
              
            }
          }.debugBorder()
        }
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
