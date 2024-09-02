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
  @State var colorSchemeName : ColorSchemeName = 2//.summer // hack //summer
  var body: some View {
    
    HStack {
     Image(systemName:gs.startincorners ? "skew" : "character.duployan")
          .font(.title)
          .foregroundColor(.accent)
          .frame(width: isIpad ? 70 : 50 , height: isIpad ? 70 : 50)
                 .padding(.leading, 15)
                 .gesture( DragGesture(minimumDistance: 0)
                               .onChanged { _ in
                                isTouching = true
                               }
                               .onEnded { _ in
                                 isTouching = false
                               }  )
      Spacer()
      
      Text("QandA \(AppVersionProvider.appVersion()) by Freeport Software")
        .font(isIpad ? .headline: .caption2)
      

      Spacer()
      
      //Help
      Button(action: { 
        showingHelp = true
      }) {
        Image(systemName:"questionmark")
          .font(.title)
          .frame(width: isIpad ? 70 : 50, height: isIpad ? 70 : 50)
                 .padding(.trailing, 15)
      }
    }
    .debugBorder()
      .fullScreenCover(isPresented: $showingHelp ){
        HowToPlayScreen (chmgr: chmgr, isPresented: $showingHelp)
          .statusBar(hidden: true)
      }
  .onChange(of: colorSchemeName) {
    withAnimation {
      gs.currentscheme = colorSchemeName
    }
  }
    
    }
}
 
