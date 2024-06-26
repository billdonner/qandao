//
//  TodaysTopics.swift
//  qanda
//
//  Created by bill donner on 6/9/23.
//

import SwiftUI
import q20kshare


struct TopicsScreen: View {
  
  let appState: AppState
  let loginID:String
  let pd:PlayData
  @Binding var reset:Bool
  @EnvironmentObject var logManager: LogEntryManager
  @State  private var sheetchoice: TopicSheetChoices? = nil
  
  var body: some View {
    let _ = print("TopicsScreen \(pd.gameDatum.count) topics")
    NavigationStack {
      HStack {
        Text("Elapsed \(String(format:"%4.f",appState.grandTime))").font(.headline)
        Spacer()
        //Text(" Score \(appState.grandScore)").font(.headline)
        if appState.allAnswered {
          Text("Your Game is Over because all topics are answered").font(.footnote)
        }
      }.padding(.horizontal)
      ScrollView {
        ForEach(pd.gameDatum, id: \.self) {   gameData  in
          if let index = appState.indexForTopic(gameData.topic),
             let sbt = appState.scoresByTopic[gameData.topic] {
            TopicRowView(appState:appState,sbt:sbt,gameData:gameData,logManager:logManager )
              .tag(index)
              .disabled( gameData.challenges.count <= sbt.highWaterMark )
              .opacity(gameData.challenges.count > sbt.highWaterMark ? 1.0 : 0.4)
              .onTapGesture {
                if gameData.challenges.count > sbt.highWaterMark {
                  let _  =  appState.sendTopicAction(.topicRowTapped(index) )
                  sheetchoice = TopicSheetChoices(choice: .rowDetailsTapped(index), index: index)
                }
              }
              .onLongPressGesture {
                if gameData.challenges.count > sbt.highWaterMark {
                  let _  =  appState.sendTopicAction(.topicRowTapped(index) )
                  sheetchoice = TopicSheetChoices(choice: .longPressTapped(index), index: index)
                }
              }
          }
        }
        Spacer()
      }
      .navigationBarItems(trailing:     Button {
        sheetchoice = TopicSheetChoices(choice: .settingsTapped, index: nil)
      } label: {
        HStack {
          Image(systemName: "gearshape")
        }
      })
      .navigationBarTitle("Q20K Score \(appState.grandScore)")
      Spacer()
    }
    .fullScreenCover(item: $sheetchoice ) {sc in
      switch sc.choice {
      case .settingsTapped :
        SettingsScreen (appState:appState, reset: $reset)//????
      case .longPressTapped( _) :
        TopicInfoView(gameDatum:pd.gameDatum, appState: appState)
      case .rowDetailsTapped:
          ChallengesScreen(appState: appState,
                           gd: .constant(SampleData.gd),
                           backgroundPic:"pencil", loginID: loginID).environmentObject( logManager)
      }
    }
  } 
}

#Preview {
  TopicsScreen(
              appState: SampleData.mock,
               loginID:"MY_LOGIN_UUID",
              pd:SampleData.mock.playData,
               reset:.constant(false)  )
      .environmentObject(LogEntryManager.mock)
}


struct SimpleTopicsScreen: View {
  let appState: AppState
  @Binding var gd:[GameData]
  @EnvironmentObject var logManager: LogEntryManager
  var body: some View {
    NavigationStack {
      ScrollView {
        ForEach(gd, id: \.self) {   gameData  in
          if let index = appState.indexForTopic(gameData.topic),
             let sbt = appState.scoresByTopic[gameData.topic] {
            TopicRowView(appState:appState,sbt:sbt,gameData:gameData,logManager:logManager )
              .tag(index)
              .disabled( gameData.challenges.count <= sbt.highWaterMark )
              .opacity(gameData.challenges.count > sbt.highWaterMark ? 1.0 : 0.4)
              }
          }
        }
        Spacer()
      .navigationBarTitle("Q20K Score \(appState.grandScore)")
    }
      Spacer()
    }
}
#Preview("Simple Topics Screen") {
  SimpleTopicsScreen(
              appState: SampleData.mock,
               gd:.constant(SampleData.gd)  )
      .environmentObject(LogEntryManager.mock)
}

//import ComposableArchitecture

// MARK :- Build Topics Page

/* at this point all game an topic data is set up and we can behave as in tca */

/*
@Reducer
struct AppFeature  {
  @ObservableState
  struct State:Equatable {
    static func == (lhs: AppFeature.State, rhs: AppFeature.State) -> Bool {
      lhs.gameDatum == rhs.gameDatum
    }
    var isLoading = false
    var gameDatum : [GameData] = []
    var scoreDatum: [String:TopicGroupData] = [:]
  }
  enum Action {
    case reloadButtonTapped
    case reloadButtonResponse([GameData])
  }
  @Dependency(\.continuousClock) var clock
  @Dependency(\.date.now) var now
  // @Dependency(\.dataManager.save) var saveData
  @Dependency(\.uuid) var uuid
  
  private enum CancelID {
    case saveDebounce
  }
  
  func  scoresFromGameDatum(_ gameDatum:[GameData]) ->  [String:TopicGroupData] {
    var sd :  [String:TopicGroupData] = [:]
    for gd in gameDatum {
      let topic = gd.topic
      let tgd = TopicGroupData(topic: topic, outcomes:[ ], time: [], questionNumber: 1)
      sd [ gd.topic] = tgd
    }
    return sd
  }
  
  
  var body: some ReducerOf<Self> {
    
    Reduce { state,action in
      switch action {
        
      case let .reloadButtonResponse(gameData):
        state.gameDatum = gameData
        state.isLoading = false
        //TODO: must reinstate this
        state.scoreDatum = scoresFromGameDatum(gameData)
        return .none
        
      case .reloadButtonTapped: if !state.isLoading {
        state.gameDatum = []
        state.isLoading = true
        return .run { //[count = state.count]
          send in
          let count = 1
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://billdonner.com/fs/gs/readyforios\(count)")!)
          let gd = try JSONDecoder().decode([GameData].self,from:data)
          await send(.reloadButtonResponse(gd))
        }
      }
      }
      return .none
    }
  }
}
 */
