//
//  ContentViewBottomButtons.swift
//  qandao
//
//  Created by bill donner on 8/19/24.
//

import SwiftUI

struct ContentViewBottomButtons : View {
  let gs:GameState
  let chmgr:ChaMan
  
  @State   var showSettings = false
  @State   var showingHelp = false
  var body: some View {
    
    HStack {
      //SETTINGS
      Button(action: {  withAnimation {showSettings = true } } ) {
 
        Image(systemName:"gearshape.2")
          .font(.title)
                 .frame(width: 40, height: 40)
                 .padding(.leading, 15)
                // .padding(.bottom, 15)
      }
      .disabled(gs.gamestate == .playingNow)
      .opacity(gs.gamestate != .playingNow ? 1 : 0.5)
      Spacer()
      Text("QandA \(AppVersionProvider.appVersion()) by Freeport Software").font(.caption2)
      Spacer()
      //Help
      Button(action: { showingHelp = true }) {
        Image(systemName:"questionmark")
          .font(.title)
                 .frame(width: 40, height: 40)
                 .padding(.trailing, 15)
      }
        


    }
    .debugBorder()
      .sheet(isPresented: $showSettings){
        SettingsScreen(chmgr: chmgr, gs: gs)
      }
      .fullScreenCover(isPresented: $showingHelp ){
        HowToPlayScreen (chmgr: chmgr, isPresented: $showingHelp)
          .statusBar(hidden: true)
      }
  
  }
}
 
