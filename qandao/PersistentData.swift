//
//  PersistentData.swift
//  qanda
//
//  Created by bill donner on 1/28/24.
//

import Foundation
import q20kshare


// this is what we need to save/restore as codable
struct PersistentData : Codable {
  var scoresByTopic:[String:TopicGroupData]
  var currentTopicIndex : Int
  var showing:ShowingState
  var remoteContentID:String
  
  static  let savePath = NSTemporaryDirectory()+("/app-state.json")
  
  init(ap:AppState)  {
    self.scoresByTopic = ap.scoresByTopic
    self.currentTopicIndex = ap.currentTopicIndex
    self.showing = ap.showing
    self.remoteContentID = ap.remoteContentID
  }
  static func restoreAS() -> AppState? {
    // first try to restore the GameDatum
    
    // failing that, download GameDatum from Internet and initialize
    
    // if we have restored gameDatrum dthen restore the rest
    //of state
    
    // if the ids dont match then the rest of state is invalid and must be initilized
    guard let x = PersistentData.restoreCodableAppState()
    else {return nil}
    return PersistentData.toAppState(x)
  }
  func saveInternalCodable () {
    do {
      let stuff = try JSONEncoder().encode(self)
      try stuff.write(to:URL(fileURLWithPath: Self.savePath))
    } catch {
      print ("***save error \(error.localizedDescription)")
    }
  }
  private static func toAppState (_ innn:PersistentData ) -> AppState {
    let ap = AppState(playData: PlayData.zero)
    ap.scoresByTopic = innn.scoresByTopic
    ap.currentTopicIndex = innn.currentTopicIndex
    ap.showing = innn.showing
    ap.remoteContentID = innn.remoteContentID
    return ap
  }
  private  static func restoreCodableAppState() -> PersistentData? {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath:Self.savePath))
      let decoded = try JSONDecoder().decode(Self.self, from:data)
      return decoded
    }
    catch {
      print(">>> could not restore from \(error.localizedDescription); will initialize new file")
      return nil
    }
  }
} // end of PersistentData
