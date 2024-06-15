//
//  FirstDownloadView.swift
//  qanda
//
//  Created by bill donner on 9/24/23.
//

import SwiftUI
import q20kshare
//import ComposableArchitecture
 
func restoreEverything(pd: PlayData ) throws -> AppState  {
    
    //2. try to restore both structures, otherwise initilize them
    // let (structure1, appstate) = try RecoveryManager.restoreOrInitializeStructures(id: id)
    let appstate =  PersistentData.restoreAS()
    if let appstate = appstate{
      if appstate.remoteContentID == pd.playDataId {
        // all good
        print ("Restored app state \(pd.playDataId)")
        return appstate
      }
      else {
        // must be new download
        print("New download - must initialize app state id \(pd.playDataId) remote \(appstate.remoteContentID)")
        // the download has a different id, so reset all state
      initializePlayData(id: pd.playDataId,data:pd.gameDatum,topicData:pd.topicData)
    initializeAppState(id: pd.playDataId,pd:pd )
        return try  restoreAppState()
      }
    }
    else {
      print("Could not restore app state id: \(pd.playDataId)")
      // the download has a different id, so reset all state
    initializeAppState(id: pd.playDataId,pd:pd)
      return try restoreAppState()
    }
  }

  


  func restoreAppState() throws -> AppState {
  guard let appstate = PersistentData.restoreAS()
  else  {
    throw CustomError.couldNotRestore
  }
  return appstate
}

 func initializeAppState(id:String,pd:PlayData) {
  let newAppState = AppState(playData:pd)
  newAppState.remoteContentID = id
  do {
    try saveAppState(newAppState)
  } catch {
    print("***Can not initializeAppState")
  }
}


  func savePlayData(_ pd: PlayData) throws {
  let encodedData = try JSONEncoder().encode(pd)
  try encodedData.write(to: playdataFileURL)
}


 func saveAppState(_ appstate: AppState) throws {
  appstate.save()
}

 func restorePlayData() throws -> PlayData {
  let decodedData = try Data(contentsOf: playdataFileURL)
  return try JSONDecoder().decode(PlayData.self, from: decodedData)
}



  func initializePlayData(id:String,data:[GameData],topicData:TopicGroup) {
  let newPlayData = PlayData(topicData: topicData, gameDatum: data, playDataId: id, blendDate: Date())
  do {
    try savePlayData(newPlayData)
  }
  catch {
    print("***Can not initializePlayData")
  }
}


@MainActor
func restorePlayData(source: GameDataSource) async throws -> PlayData? {
  switch source {
  case .gameDataSource1:
    return try await restorePlayDataURL(URL(string: PRIMARY_REMOTE)!)
  case .gameDataSource2:
    return try await restorePlayDataURL(URL(string: SECONDARY_REMOTE)!)
  case .gameDataSource3:
    return try await restorePlayDataURL(URL(string: TERTIARY_REMOTE)!)
  }
}


  func downloadFile(from url: URL ) async throws -> Data {
  let (data, _) = try await URLSession.shared.data(from: url)
  return data
}

   func restorePlayDataURL(_ url:URL) async  throws -> PlayData? {
  do {
    let start_time = Date()
    let tada = try await  downloadFile(from:url)
    let str = String(data:tada,encoding:.utf8) ?? ""
    do {
      let pd = try JSONDecoder().decode(PlayData.self,from:tada)
      let elapsed = Date().timeIntervalSince(start_time)
      print("************")
      print("Downloaded \(pd.playDataId) in \(elapsed) secs from \(url)")
      let challengeCount = pd.gameDatum.reduce(0,{$0 + $1.challenges.count})
      print("Loaded"," \(pd.gameDatum.count) topics, \(challengeCount) challenges in \(elapsed) secs")
      print("************")
      return pd
    }
    catch {
      print(">>> could not decode playdata from \(url) \n>>> original str:\n\(str)")
    }
  }
  catch {
    throw error
  }
  return nil
}






struct OuterShellView : View {
  
  @AppStorage("onboardingCompleted") private var onboardingCompleted = false
  @EnvironmentObject var logManager: LogEntryManager
  
  let loginID:String
  let source: GameDataSource
  var appState = AppState.reloadOrInit()
  
////  let store=Store(initialState:AppFeature.State()) {
//    AppFeature()
//      ._printChanges()
//  }
  
  @State var playData:PlayData = PlayData.zero
  @State var isDownloading = true
  @State var terror:String = ""
  @State var showAlert = false
  @State var reset = false
  @State private var showMainView = false
  

  
  var body: some View {
    ZStack{
      VStack{
       //Color.red
      AlienSplashView() // Replace this with your own custom logo if desired
         .rotation3DEffect(.degrees(showMainView ? 180 : 0), axis: (x: 0, y: 1, z: 0))
          .opacity(showMainView ? 0 : 1)
      }
      VStack{
        ZStack {
          ProgressView("loading...")
            .opacity(isDownloading ? 1 : 0)
          //TODO: MAYBE Go directly to challenges screen
              if onboardingCompleted {
                TopicsScreen( appState:appState,loginID:loginID,pd:playData,reset:$reset )
                  .opacity(isDownloading ? 0 : 1).environmentObject(logManager)
            } else {
               OnboardingView { onboardingCompleted = true }
            }
        }.opacity(showMainView ? 1 : 0)
      }
    }
    .alert ("error - \(terror)",isPresented: $showAlert){
      Button("OK", role: .cancel) { }
    }
    .task { //instead of OnAppear
      withAnimation(Animation.easeInOut(duration: 1.5)) { // .delay(0.5)
        showMainView = true // Start the transition
      }
      do {
        // send a log message indicating we are getting started
        sendLoginMessage(logManager, loginID: loginID, source: source)
        
        
       // try await rebuild(source: source)
        
        isDownloading = false
        if let playData = try await restorePlayData(source: source){
          let appstatex =  try restoreEverything(pd: playData)
          appState.reloadStuff (appstatex,pd:playData) //manuever this in, crudely
          return
        }
        throw PumpingErrors.badInputURL
        
        
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
