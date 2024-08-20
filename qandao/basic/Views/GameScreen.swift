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
  @Binding  var topics: [String]
  @Binding  var size:Int
  let onSingleTap: (_ row:Int, _ col:Int ) -> Bool
  
  @State   var firstMove = true
  @State   var startAfresh = true
  @State   var showWinAlert = false
  @State   var showLoseAlert = false
  @State   var showCantStartAlert = false
  @State private var isTouching: Bool = false
  
  var bodyMsg: String {
    let t =  """
    That was game \(gs.gamenumber) of which:\nyou've won \(gs.woncount) and \nlost \(gs.lostcount) games
"""
    return t
  }
  
  var body: some View {
 
      VStack {
     
        topButtonsVeew.padding([.bottom,.horizontal])
        
          if gs.boardsize > 1 {
            MainGridView(gs: gs, chmgr:chmgr,  firstMove: $firstMove, isTouching: $isTouching, onSingleTap: onSingleTap)
              .debugBorder()
          
            ScoreBarView(gs: gs)
              .debugBorder()
          
          .onChange(of:gs.cellstate) {
            onChangeOfCellState()
          }
          .onChange(of:gs.boardsize) {
            print("//GameScreen onChangeof(Size) to \(gs.boardsize)")
            onBoardSizeChange ()
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
      Image(systemName:gs.startincorners ? "skew" : "character.duployan")
        .resizable()
               .frame(width: 50, height: 50)
               //.padding(.leading, 10)
              // .padding(.top, 15)
               //.padding(.bottom,10)
               .foregroundColor(.blue)
        .gesture(
                  DragGesture(minimumDistance: 0)
                      .onChanged { _ in
                          isTouching = true
                      }
                      .onEnded { _ in
                          isTouching = false
                      }
              )
      Spacer()
      Text(" q a n d a").font(.largeTitle).bold()
      Spacer()
      if gs.gamestate !=  StateOfPlay.playingNow {
        //Start Game
        Button(action: {
          withAnimation {
            let ok =  onStartGame(boardsize: gs.boardsize)
            if !ok {
              showCantStartAlert = true
            }
            chmgr.checkAllTopicConsistency("GameScreen StartGamePressed")
            assert(gs.checkVsChaMan(chmgr: chmgr))
          }
        }) {
          Text("Play")
            .frame(width:50)
            .lineLimit(2)
            .padding(10)
            .background(.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(.body)
        }
        .alert("Can't start new Game - consider changing the topics or hit Full Reset",isPresented: $showCantStartAlert){
          Button("OK", role: .cancel) {
            withAnimation {
              onCantStartNewGameAction()
            }
          }
        }
      } else {
        // END GAME
        Button(action: {
          withAnimation {
            assert(gs.checkVsChaMan(chmgr: chmgr)) //cant check after endgamepressed
            onEndGamePressed()  //should estore consistency
            chmgr.checkAllTopicConsistency("GameScreen EndGamePressed")
          }
        }) {
          Text("End")
            .frame(width:50)
            .lineLimit(2)
            .padding(10)
            .background(.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(.body)
        }
      }

    }.font(.body)
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
        topics:.constant(GameState.mock.topicsinplay),
        size:.constant(3),
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
        topics:.constant(GameState.mock.topicsinplay),
        size:.constant(3),
        onSingleTap: { row,col in
          print("Tapped cell with challenge \(row) \(col)")
          return false
        }
      ).preferredColorScheme( .dark)
    }
