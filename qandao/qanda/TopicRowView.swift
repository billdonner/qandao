//
//  TopicRowView.swift
//  qanda
//
//  Created by bill donner on 1/28/24.
//

import SwiftUI
import q20kshare

struct TopicRowView: View {
  let appState:AppState
  let sbt:TopicGroupData
  let gameData:GameData
  let logManager:LogEntryManager
  
  struct RightistView: View {
    let score:Int
    let c:String
    let i:String
    var body: some View {
      HStack {
        // Spacer()
        Text("\(score)").font(.title)
        VStack {
          Text(c).font(.footnote)
          Text(i).font(.footnote)
        }
      }
    }
  }
  struct LeftistView: View {
    let h:String
    let gameData:GameData
    var body: some View {
      HStack {
        VStack{
          Text(h).font(.footnote)
          Text("\(gameData.challenges.count)").font(.footnote)
        }
        Image(systemName:gameData.pic ?? "leaf").font(.title)
      }
    }
  }
  
  var body: some View { 
    VStack {
      HStack {
        let hwm = sbt.highWaterMark //?? -1
        let h = hwm == -1 ? "😎" : "\(hwm)"
        LeftistView(h: h, gameData:gameData)
        Spacer()
        Text(fixTopicName(gameData.topic)).font(.title2).lineLimit(2)
        Text(String(format:"%4.1f",sbt.elapsedTime)).font(.footnote)
        Spacer()
        let cwm = sbt.playedCorrectly //?? -1
        let c = cwm == -1 ? "😎" : "\(cwm)"
        let iwm = sbt.playedInCorrectly// ?? -1
        let i = iwm == -1 ? "😎" : "\(iwm)"
        let score = sbt.playedCorrectly //- sbt.playedInCorrectly//
        RightistView (score: score, c: c, i: i)
      }
    }.foregroundColor(.primary)
      .borderedStyleStrong(.blue).padding(.horizontal)
  }
}


struct SimpleTopicRowView: View {
  let appState:AppState
  let sbt:TopicGroupData
  let gameData:GameData
  let logManager:LogEntryManager

  
  var body: some View {
    VStack {
      HStack {
        Image(systemName:gameData.pic ?? "leaf").font(.title)
        Spacer()
        Text(fixTopicName(gameData.topic)).font(.title2).lineLimit(2)
        Spacer()
      }
    }.foregroundColor(.primary)
      .borderedStyleStrong(.blue).padding(.horizontal)
  }
}
