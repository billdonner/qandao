//
//  FrontView.swift
//  basic
//
//  Created by bill donner on 6/23/24.
//
import SwiftUI

struct GameScreen: View {

  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @Bindable var lrdb: LeaderboardService
  @Binding  var topics: [String]
  @Binding  var size:Int
  @Binding var isTouching: Bool
  let onSingleTap: (_ row:Int, _ col:Int ) -> Bool
  
  @State   var firstMove = true
  @State   var startAfresh = true
  @State   var showWinAlert = false
  @State   var showLoseAlert = false
  @State   var showCantStartAlert = false
  
  @State   var showSettings = false

  @State   var showLeaderboard = false
  
  @State var marqueeMessage =  "Tap on a corner to start the game"

  var bodyMsg: String {
    let t =  """
    That was game \(gs.gamenumber) of which:\nyou've won \(gs.woncount) and \nlost \(gs.lostcount) games
"""
    return t
  }
  
  var body: some View {
 
      VStack { 
        topButtonsVeew.padding(.horizontal)      .debugBorder()
        if !marqueeMessage.isEmpty {
          MarqueeMessageView(
            message: $marqueeMessage,
            fadeInDuration: 1.0,
            fadeOutDuration: 3.0,
            displayDuration: 5.0 // Message stays visible for 5 seconds before fading out
          ).opacity(marqueeMessage.isEmpty ? 0:1).debugBorder()
        }
          if gs.boardsize > 1 {
            MainGridView(gs: gs, chmgr:chmgr, 
                        // boardsize:$gs.boardsize,
                         firstMove: $firstMove, isTouching: $isTouching, marqueeMessage: $marqueeMessage, onSingleTap: onSingleTap)
              .debugBorder()
          
            ScoreBarView(gs: gs,marqueeMessage:$marqueeMessage)
              .debugBorder()
            
            TopicIndexView(gs:gs,chmgr:chmgr,inPlayTopics:$gs.topicsinplay,scheme: $gs.currentscheme)
          
          .onChange(of:gs.cellstate) {
            onChangeOfCellState()
          }
     
          .onDisappear {
            print("Yikes the GameScreen is Disappearing!")
          }
        }
        else {
          loadingVeew
        }
      }
      .youWinAlert(isPresented: $showWinAlert, title: "You Win",
                   bodyMessage: bodyMsg, buttonTitle: "OK"){
        onYouWin()
      }
      .youLoseAlert(isPresented: $showLoseAlert, title: "You Lose",
                                 bodyMessage: bodyMsg, buttonTitle: "OK"){
                     onYouLose()
    }
  }
  
  var topButtonsVeew : some View{
    HStack(alignment:.center ){
      if gs.gamestate !=  StateOfPlay.playingNow {
        //Start Game
        Button(action: {
          withAnimation {
            let ok =  onStartGame(boardsize: gs.boardsize)
            if !ok {
              showCantStartAlert = true
            }
            chmgr.checkAllTopicConsistency("GameScreen StartGamePressed")
            conditionalAssert(gs.checkVsChaMan(chmgr: chmgr))
          }
        }) {
          Text("Play")
            .frame(width: isIpad ? 70:50, height: isIpad ? 70 : 50)
            .padding(5)
          //.background(.blue.opacity(0.8))
          // .foregroundColor(.white)
          //  .cornerRadius(8)
            .font(isIpad ? .title:.body)
        }
      }
      else {
        // END GAME
        Button(action: {
          withAnimation {
            // this one has been trouble
            // conditionalAssert(gs.checkVsChaMan(chmgr: chmgr)) //cant check after endgamepressed
            onEndGamePressed()  //should estore consistency
            chmgr.checkAllTopicConsistency("GameScreen EndGamePressed")
          }
        }) {
          Text("End")
            .frame(width: isIpad ? 70:50, height: isIpad ? 70:50)
            .padding(5)
          // .background(.red.opacity(0.8))
          // .foregroundColor(.white)
          //  .cornerRadius(8)
            .font(isIpad ? .title:.body)
        }
      }
        
      Spacer()
      Text(" q a n d a").font(.largeTitle).bold()
          .onLongPressGesture{
            showLeaderboard = true
          }
      Spacer()
        
      Button(action: {  withAnimation {showSettings = true } } ) {
        Image(systemName:"gearshape")
          .font(.title)
        .frame(width: isIpad ? 70:50, height: isIpad ? 70:50)

      }.disabled(gs.gamestate == .playingNow)
        .opacity(gs.gamestate == .playingNow ? 0.5:1.0)
        .alert("Can't start new Game - consider changing the topics or hit Full Reset",isPresented: $showCantStartAlert){
          Button("OK", role: .cancel) {
            withAnimation {
              onCantStartNewGameAction()
            }
          }
        }
      }  
    .font(.body)
    .sheet(isPresented: $showLeaderboard)
    {
    LeaderboardScreen(leaderboardService: lrdb)
    }
      .sheet(isPresented: $showSettings){
        SettingsScreen(chmgr: chmgr, gs: gs,lrdb:lrdb,showSettings:$showSettings)
      }
  }
  
  
  var loadingVeew: some View {
    Text("Loading...")
      .onAppear {
        onAppearAction()
      }
      .alert("Can't start new Game from this download, sorry. \nWe will reuse your last download to start afresh.",isPresented: $showCantStartAlert){
        Button("OK", role: .cancel) {
          onCantStartNewGameAction()
        }
      }
  }
}


#Preview ("GameScreen") {
      GameScreen(
        gs:GameState.mock ,
        chmgr: ChaMan(playData: PlayData.mock),
        lrdb: LeaderboardService(),
        topics:.constant(GameState.mock.topicsinplay),
        size:.constant(3), isTouching: .constant(true) ,
        onSingleTap: { row,col in
          print("Tapped cell with challenge \(row) \(col)")
          return false
        }
      )
    }


#Preview ("Dark") {
      GameScreen(
        gs:GameState.mock ,
        chmgr: ChaMan(playData: PlayData.mock),
        lrdb: LeaderboardService(),
        topics:.constant(GameState.mock.topicsinplay),
        size:.constant(3),isTouching: .constant(true) ,
        onSingleTap: { row,col in
          print("Tapped cell with challenge \(row) \(col)")
          return false
        }
      ).preferredColorScheme( .dark)
    }
