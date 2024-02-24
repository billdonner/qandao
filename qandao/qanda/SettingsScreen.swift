//
//  SettingsView.swift
//  qanda
//
//  Created by bill donner on 7/6/23.
//

import SwiftUI

struct SettingsScreen: View {
  let appState:AppState
  let difficulties : [DifficultyLevels] = [.easy,.medium,.hard]
  let dataSources : [GameDataSource] = [.gameDataSource1,.gameDataSource2,.gameDataSource3]
  
  @AppStorage("DifficultyLevel") var difficultyLevel: DifficultyLevels = DifficultyLevels.easy
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  @Binding var reset: Bool
  
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationStack {
      Spacer()
      VStack{
        AppVersionInformationView(
          name:AppNameProvider.appName(),
          versionString: AppVersionProvider.appVersion(),
          appIcon: AppIconProvider.appIcon()
        )
        Form {
          Section {
            Picker("Difficulty", selection: $difficultyLevel) {
              ForEach(difficulties, id: \.self) { ds in
                Text(DifficultyLevels.string(for:ds))
              }
            }.onChange   (of: gameDataSource)  {  reset = true  }
          }
          Section("This section for Freeport Software Only") {
            Picker("Source", selection: $gameDataSource) {
              ForEach(dataSources, id: \.self) { ds in
                Text(GameDataSource.string(for:ds))
              }
            }.onChange   (of: gameDataSource)  {  reset = true  }
          }
          Section {
            Text("Be sure to Restart the app for changes to take effect")
              .font(.footnote)
          }
          .navigationBarItems(leading:     Button {
            dismiss()
          } label: {
            Text("Done")
          })
          .navigationTitle("Settings")
        }
      }
    }
  }
}
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen(appState:SampleData.mock,reset:.constant(true))
  }
}
