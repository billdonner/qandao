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
  
  @Binding   var isTouching:Bool
  @State   var showingHelp = false
  var body: some View {
    
    HStack {

     Image(systemName:gs.startincorners ? "skew" : "character.duployan")
          .font(.title)
          .foregroundColor( .blue)
                 .frame(width: 40, height: 40)
                 .padding(.leading, 15)
                // .padding(.bottom, 15)
    //  }
                 .gesture(
                           DragGesture(minimumDistance: 0)
                               .onChanged { _ in
                                isTouching = true
                               }
                               .onEnded { _ in
                                 isTouching = false
                               }
                       )
     // .opacity(gs.gamestate != .playingNow ? 1 : 0.5)
      Spacer()
      Text("QandA \(AppVersionProvider.appVersion()) by Freeport Software").font(.caption2)
      Spacer()
      //Help
      Button(action: { showingHelp = true }) {
        Image(systemName:"questionmark")
          //.foregroundColor( isTouching ? .red : .green)
          .font(.title)
                 .frame(width: 40, height: 40)
                 .padding(.trailing, 15)
      }
        


    }
    .debugBorder()

      .fullScreenCover(isPresented: $showingHelp ){
        HowToPlayScreen (chmgr: chmgr, isPresented: $showingHelp)
          .statusBar(hidden: true)
      }
  
  }
}
 
