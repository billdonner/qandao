//
//  q2App.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI
import q20kshare


let PRIMARY_REMOTE = "https://billdonner.com/fs/gd/readyforios01.json"
let SECONDARY_REMOTE = "https://billdonner.com/fs/gd/readyforios02.json"
let TERTIARY_REMOTE = "https://billdonner.com/fs/gd/readyforios03.json"

let container = "iCloud.com.billdonner.gentest"
let zone = "_defaultZone"
let correctColor:Color = .green.opacity(0.1)
let incorrectColor:Color = .red.opacity(0.1)
let unplayedColor:Color = .blue.opacity(0.1)


let formatter = DateComponentsFormatter()





@main
struct qandaoApp: App {
  @AppStorage("DifficultyLevel") var difficultyLevel: DifficultyLevels = DifficultyLevels.easy
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource2
  @AppStorage("InitialUUID") var initialUUID:String = UUID().uuidString
  var logManager:LogEntryManager
  init () {
     let _ = print(">>> \(AppNameProvider.appName()) \(AppVersionProvider.appVersion()) \n")
   let _ =  SampleData.makeMock() 
     logManager = LogEntryManager(container:container,zone:zone)
  }
  var body: some Scene {
    WindowGroup {
      OuterShellView(loginID:initialUUID,source:gameDataSource).environmentObject(logManager)
    }
  }
}
