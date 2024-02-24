//
//  TopicInfoView.swift
//  qanda
//
//  Created by bill donner on 10/15/23.
//

import SwiftUI
import q20kshare
struct OnePanelView: View {
  let sbt:TopicGroupData
  let gameData:GameData
  
  struct RightistView: View {
    let c:String
    let i:String
    var body: some View {
      HStack {
        Spacer()
        VStack {
          Text("correct: \(c)").font(.footnote)
          Text("incorrect: \(i)").font(.footnote)
        }
      }
    }
  }
  struct LeftistView: View {
    let h:String
    let gameData:GameData
    var body: some View {
      VStack{
        Text("progress: \(h)").font(.footnote)
        Text("challenges:\(gameData.challenges.count)").font(.footnote)
      }
    }
  }
  
  var body: some View {
    let playedAll = gameData.challenges.count == sbt.highWaterMark
   return  VStack {
      let score = sbt.playedCorrectly //- sbt.playedInCorrectly//
      Text(gameData.topic).font(.largeTitle).lineLimit(2)
      Text("\(score)").font(.largeTitle)
      Spacer()
      Image(systemName:gameData.pic ?? "leaf").font(.largeTitle)
      Spacer()
      HStack {
        let hwm = sbt.highWaterMark //?? -1
        let h = hwm == -1 ? "😎" : "\(hwm)"
        LeftistView(h: h, gameData:gameData)
        Spacer()
        let cwm = sbt.playedCorrectly //?? -1
        let c = cwm == -1 ? "😎" : "\(cwm)"
        let iwm = sbt.playedInCorrectly// ?? -1
        let i = iwm == -1 ? "😎" : "\(iwm)"
        RightistView ( c: c, i: i)
      }
      Spacer()
    }.foregroundColor(playedAll ? .gray : .black)
      //.frame(height:400)
      .borderedStyleStrong(.blue).padding(.horizontal)
  }
}

struct TopicInfoView: View {
  
  @Environment(\.dismiss) var dismiss
  let gameDatum:[GameData]
  
  let appState : AppState
  var body: some View {
      let gd = gameDatum[appState.currentTopicIndex]
    NavigationStack {
      VStack {
        ScrollView {
          Text(gd.commentary ?? "??")
          if let sbt = appState.scoresByTopic[appState.currentTopic]  {
            OnePanelView(sbt: sbt,gameData:gd)
            Spacer()
            
          } else { EmptyView() }
        }.navigationBarItems(leading: Button { dismiss()
        } label: { Text("Cancel")  })
        Text("generated: \(gd.generated)")
      }
      .navigationTitle(appState.currentTopic)
     
    }
  }
}
  
  #Preview {
    TopicInfoView(gameDatum: SampleData.gd, appState:SampleData.mock)
  }
