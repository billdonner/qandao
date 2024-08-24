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
          .frame(width: isIpad ? 60:40, height: isIpad ? 60 : 40)
                 .padding(.leading, 15)
//                 .gesture( DragGesture(minimumDistance: 0)
//                               .onChanged { _ in
//                                isTouching = true
//                               }
//                               .onEnded { _ in
//                                 isTouching = false
//                               }  )
      Spacer()
      
      Text("QandA \(AppVersionProvider.appVersion()) by Freeport Software").font(.caption2)
      
      Spacer()
      //Help
      Button(action: { 
        showingHelp = true
      }) {
        Image(systemName:"questionmark")
          .font(.title)
          .frame(width: isIpad ? 60:40, height: isIpad ? 60 : 40)
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
 
