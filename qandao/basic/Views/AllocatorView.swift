//
//  AllocatorView.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//

import SwiftUI
struct AllocatorView: View {
  let chmgr: ChaMan
  let  gs:GameState
  @Environment(\.colorScheme) var colorScheme //system light/dark
  @State var succ = false
  
  var body: some View {
    VStack {
      HStack {
        Text("Allocated: \(chmgr.allocatedChallengesCount())")
        Text("Free: \(chmgr.freeChallengesCount())")
        Text("Played: \(gs.gamenumber)")
      }
      .font(.footnote)
      .padding(.bottom, 8)
      
      let playData = chmgr.playData
      ScrollView {
        VStack(spacing: 4) {
          ForEach(gs.basicTopics(), id: \.name) { topic in
            if chmgr.allocatedChallengesCount(for: topic.name) > 0 {
              TopicCountsView(topic: topic.name,chmgr: chmgr, gs: gs )
            }
          }
        }
        Divider()
        VStack(spacing: 4) {
          ForEach(playData.topicData.topics, id: \.name) { topic in
            if chmgr.allocatedChallengesCount(for: topic.name) > 0 {
              TopicCountsView(topic: topic.name,chmgr: chmgr, gs: gs )
            }
          }
        }
        Divider()
        VStack(spacing: 4) {
          ForEach(playData.topicData.topics, id: \.name) { topic in
            if chmgr.allocatedChallengesCount(for: topic.name) <=  0 {
              TopicCountsView(topic: topic.name,chmgr: chmgr,gs: gs)
            }
          }
        }
      }
    }
    .background(backgroundColor)
    .padding()
  }
  
  // Computed properties for background and text colors
  private var backgroundColor: Color {
    colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.96)
  }
  
  private var textColor: Color {
    colorScheme == .dark ? Color.white : Color.black
  }
}

// Assuming you have the ChaMan and colorSchemes to preview the view
struct AllocatorView_Previews: PreviewProvider {
  static var previews: some View {
    AllocatorView(chmgr: ChaMan(playData:PlayData.mock),
                  gs: GameState.mock)
    
  }
}

fileprivate struct TopicCountsView: View {
  let topic: String
  let chmgr: ChaMan
  let gs: GameState
  
  var counts: some View {
    Text("\(chmgr.allocatedChallengesCount(for: topic )) - "
         + "\(chmgr.freeChallengesCount(for: topic )) - "
         + "\(chmgr.abandonedChallengesCount(for: topic )) - "
         + "\(chmgr.correctChallengesCount(for: topic )) - "
         + "\(chmgr.incorrectChallengesCount(for: topic ))"
    )
  }
  var body: some View {
    HStack {
      RoundedRectangle(cornerSize: CGSize(width: 15.0, height: 5.0))
        .frame(width: 24, height: 24)
        .foregroundStyle(gs.colorForTopic(topic).0)
      Text(topic )
      Spacer()
      counts
    }
    .font(.caption)
    .padding(.vertical, 4)
    .padding(.horizontal, 8)
  }
}
