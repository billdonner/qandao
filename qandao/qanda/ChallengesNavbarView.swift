//
//  ChallengesNavbarView.swift
//  qanda
//
//  Created by bill donner on 8/14/23.
//

import SwiftUI
import q20kshare


struct ChallengesNavbarView : View {
  @EnvironmentObject var logManager: LogEntryManager
  let  appState:AppState
  @Environment(\.dismiss) var dismiss
  @State private var sheetchoice: ChallengeSheetChoices? = nil
  
  var body: some View {
    VStack {
      let tc = appState.thisChallenge
      Divider()
        .sheet(item: $sheetchoice) {sc in
          switch sc.choice {
          case .thumbsUpTapped :
            ThumbsUpView(challenge: tc )
          case .thumbsDownTapped :
            ThumbsDownView(challenge: tc )
          case  .infoTapped :
            DetailedChallengeView(challenge: tc)
          }
        }
        .navigationBarItems(leading:  Button {
          appState.sendChallengeAction(ChallengeActions.cancelButtonTapped)
          dismiss()
        } label: {
          HStack { Text("Topics")  }
        })
        .toolbar {
          ToolbarItem {
            Menu {
              Button {
                withAnimation{
                  sheetchoice = ChallengeSheetChoices(choice: .thumbsDownTapped)
                }
              } label: {
                Label( "Thumbs Down"   ,systemImage:  "hand.thumbsdown")
              }
              .disabled(appState.showing == .hint || appState.showing == .qanda)  
              Button{
                withAnimation{
                  sheetchoice = ChallengeSheetChoices(choice: .infoTapped)
                }
              }  label: {
                Label( "Challenge Info"   ,systemImage:  "info.circle")
              }
              
              Button {
                withAnimation{
                  sheetchoice = ChallengeSheetChoices(choice: .thumbsUpTapped)
                }
              } label: {
                Label( "Thumbs Up"   ,systemImage:   "hand.thumbsup")
              }.disabled(appState.showing == .hint || appState.showing == .qanda)
            }
          label: {
            Label ("...",systemImage: "ellipsis.circle")
          }
          }
        } 
    }
  }
}
struct ChallengesNavbarView_Previews: PreviewProvider {
  static var previews: some View {
    ChallengesNavbarView(appState: SampleData.mock).environmentObject(  LogEntryManager.mock)
  }
}
