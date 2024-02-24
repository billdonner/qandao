//
//  ChallengeView.swift
//  stupido
//
//  Created by bill donner on 7/15/23.
//

import SwiftUI
import q20kshare
import ComposableArchitecture

@Reducer
struct ChallengesFeature {
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action: BindableAction,Sendable {
    case binding(BindingAction<State>)
  }
  @Dependency(\.continuousClock) var clock
  @Dependency(\.uuid) var uuid
  private enum CancelID { case todoCompletion }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .binding:
        return .none
      }
      
    }
  }
}

struct ChallengesScreen: View {
  @EnvironmentObject var logManager: LogEntryManager
  let appState: AppState
  let backgroundPic:String
  let loginID : String
  
  var body: some View {
    NavigationStack{
      ChallengesNavbarView(appState: appState)
      // keep Question outside vstack to give it a chance to remain fullsize
      ZStack {
        Image(systemName:backgroundPic).font(.system(size:250)).foregroundColor(.gray.opacity(0.08))
        VStack {
          EssentialChallengeView(store: Store(initialState:ChallengesFeature.State()){ChallengesFeature()}
                                 , 
                                 appState: appState)//, topicIndex: topicIndex)
          StatsTextView(appState: appState)  // show dynamic stats
          ChallengesToolbarView(appState: appState).navigationTitle(fixTopicName(appState.thisChallenge.topic))
        }
      }.navigationTitle(appState.thisChallenge.topic)
        .task {
          // assert (topicIndex==appState.currentTopicIndex)
          // appState.isTimerRunning = appState.showing == ShowingState.qanda // still fresh
          // try? await updateTimer(appState: appState)
        }
        .foregroundColor( .primary)
        .borderedStyleStrong(.blue).padding(.horizontal)
        .onDisappear() {
          //          appState.isTimerRunning = false
          
          //   appState.addTime(appState.currentTopic, timeInSecs: Double(appState.timerCount)/10.0)// get the time
          
          Task {
            sendLogout(LogoutRec(datetime: Date(), initialUUID: loginID),lem: logManager)
          }
        }
    }
  }
}
struct ChallengesScreen_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ChallengesScreen(appState: SampleData.mock,
                        backgroundPic:"pencil",
                        loginID: "XXX-NOT_UUID")
      .environmentObject(  LogEntryManager.mock)
   
      ChallengesScreen(appState: SampleData.mock,
                        backgroundPic:"pencil",
                        loginID: "XXX-NOT_UUID")
      .environmentObject(  LogEntryManager.mock)
      .preferredColorScheme(.dark)
    }
  }
}
