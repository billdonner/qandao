//
//  RecoveryManager.swift
//  rstorer
//
//  Created by bill donner on 8/28/23.
//

import Foundation
import q20kshare


class RecoveryManager {
  
  static func restoreAll(source: GameDataSource) async throws -> (AppState,[GameData]) {
    if let playData = try await restorePlayData(source: source){
      let appstate =  try await restoreEverything(pd: playData)
      return (appstate,playData.gameDatum)
    }
    throw PumpingErrors.badInputURL
  }
  
  //z all private from here on down
  
  private static func downloadFile(from url: URL ) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
  private static let playdataFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("structure1.json")
  private static let appstateFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("appstate.json")
  
  private static  func restorePlayData(url:URL) async  throws -> PlayData? {
    do {
      let start_time = Date()
      let tada = try await  downloadFile(from:url)
      let str = String(data:tada,encoding:.utf8) ?? ""
      do {
        let pd = try JSONDecoder().decode(PlayData.self,from:tada)
        let elapsed = Date().timeIntervalSince(start_time)
        print("Downloaded \(pd.playDataId) in \(elapsed) secs from \(url)")
        let challengeCount = pd.gameDatum.reduce(0,{$0 + $1.challenges.count})
        print("Loaded"," \(pd.gameDatum.count) topics, \(challengeCount) challenges in \(elapsed) secs")
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
  
  private  static func savePlayData(_ pd: PlayData) throws {
    let encodedData = try JSONEncoder().encode(pd)
    try encodedData.write(to: playdataFileURL)
  }
  
  @MainActor
  private static  func restorePlayData(source: GameDataSource) async throws -> PlayData? {
    switch source {
    case .gameDataSource1:
      return try await restorePlayData(url: URL(string: PRIMARY_REMOTE)!)
    case .gameDataSource2:
      return try await restorePlayData(url: URL(string: SECONDARY_REMOTE)!)
    case .gameDataSource3:
      return try await restorePlayData(url: URL(string: TERTIARY_REMOTE)!)
    }
  }
  
  private  static func saveAppState(_ appstate: AppState) throws {
    appstate.save()
  }
  
  private static func restorePlayData() throws -> PlayData {
    let decodedData = try Data(contentsOf: playdataFileURL)
    return try JSONDecoder().decode(PlayData.self, from: decodedData)
  }
  
  private static func restoreAppState() throws -> AppState {
    guard let appstate = PersistentData.restoreAS()
    else  {
      throw CustomError.couldNotRestore
    }
    return appstate
  }
  
  private  static func initializePlayData(id:String,data:[GameData],topicData:TopicGroup) {
    let newPlayData = PlayData(topicData: topicData, gameDatum: data, playDataId: id, blendDate: Date())
    do {
      try savePlayData(newPlayData)
    }
    catch {
      print("***Can not initializePlayData")
    }
  }
  
  private static func initializeAppState(id:String,gd:[GameData]) {
    let newAppState = AppState(gameDatum: gd)
    newAppState.remoteContentID = id
    do {
      try saveAppState(newAppState)
    } catch {
      print("***Can not initializeAppState")
    }
  }
  
  
  static func restoreEverything(pd: PlayData ) async throws -> AppState  {
    
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
        RecoveryManager.initializePlayData(id: pd.playDataId,data:pd.gameDatum,topicData:pd.topicData)
        RecoveryManager.initializeAppState(id: pd.playDataId,gd:pd.gameDatum )
        return try RecoveryManager.restoreAppState()
      }
    }
    else {
      print("Could not restore app state gamedata id: \(pd.playDataId)")
      // the download has a different id, so reset all state
      RecoveryManager.initializeAppState(id: pd.playDataId,gd:pd.gameDatum )
      return try RecoveryManager.restoreAppState()
    }
  }
}
