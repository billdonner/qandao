//
//  FirstDownloadView.swift
//  qanda
//
//  Created by bill donner on 9/24/23.
//

import SwiftUI
import q20kshare
import ComposableArchitecture



struct OuterShellView : View {
  @EnvironmentObject var logManager: LogEntryManager
  
  let loginID:String
  let source: GameDataSource
  var appState = AppState.reloadOrInit()
  
  let store=Store(initialState:AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }
  
  @State var gd:[GameData] = []
  @State var isDownloading = true //!!
  @State var terror:String = ""
  @State var showAlert = false
  @State var reset = false
  
  var body: some View {
    ZStack {
      ProgressView("loading...")
        .opacity(isDownloading ? 1.0 : 0.0)
      TopicsScreen(store:store, appState:appState,loginID:loginID,gd:$gd,reset:$reset )
        .opacity(isDownloading ? 0.0 : 1.0)
    }
    .alert ("error - \(terror)",isPresented: $showAlert){
      Button("OK", role: .cancel) { }
    }
    .task { //instead of OnAppear
      do {
        // send a log message indicating we are getting started
        sendLoginMessage(logManager, loginID: loginID, source: source)
        // go fetch everything we need to get started from the indicated source
        let (appstuff,gamestuff) =  try await RecoveryManager.restoreAll(source:source )
        gd = gamestuff
        //fixup appstate and lets get started with tca
        appState.reloadStuff (appstuff,gd:gamestuff)
        isDownloading = false
      } catch {
        isDownloading = false
        print("problem downloading - error: ",error.localizedDescription.debugDescription)
        terror = error.localizedDescription.debugDescription
        showAlert = true
      }
    }
  }
}
struct  OuterShellView_Previews: PreviewProvider {
  static var previews: some View {
    OuterShellView(loginID:"MY_LOGIN_UUID",source: .gameDataSource1)
      .environmentObject(LogEntryManager.mock)
  }
}
