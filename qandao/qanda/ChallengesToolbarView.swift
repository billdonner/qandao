//
//  ChallengesToolbarView.swift
//  qanda
//
//  Created by bill donner on 1/28/24.
//

import SwiftUI
import q20kshare


struct  ChallengesToolbarView: View {
  @Environment(\.dismiss) var dismiss
  let appState: AppState
  var body : some View {
    return VStack {
      Divider()
        .navigationBarItems(leading:     Button {
          appState.sendChallengeAction(ChallengeActions.cancelButtonTapped)
          dismiss()
        } label: {
          HStack {
            Text("Topics")
          }
        })
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar){
            Button {
              appState.sendChallengeAction(.previousButtonTapped)
              Task {
               // appState.isTimerRunning = (appState.thisOutcome == .unplayed )// still fresh
                //try? await updateTimer(appState: appState)
              }
            } label: {
              Image(systemName: "arrow.left")
            }.disabled(appState.questionNumber <= 0)
            Spacer()
           // HStack {
              Text("Q \(appState.questionNumber+1)" + " of " + "\(appState.questionMax)").font(.headline).monospaced()
             // Text("in this topic").font(.footnote).monospaced()
           // }
            Spacer()
            Button {
              appState.sendChallengeAction(.nextButtonTapped)
              Task {
                //appState.isTimerRunning = (appState.thisOutcome == .unplayed )// still fresh
                //try? await updateTimer(appState: appState)
              }
            } label: {
              Image(systemName: "arrow.right")
            }.disabled(appState.questionNumber >= appState.questionMax-1)
          }
        }
    }
  }
}

struct ChallengesToolbarView_Previews: PreviewProvider {
  static var previews: some View {
    ChallengesToolbarView(appState: SampleData.mock).environmentObject(  LogEntryManager.mock)
  }
}


#Preview {
    ChallengesToolbarView(appState: SampleData.mock).environmentObject( LogEntryManager.mock)
}
