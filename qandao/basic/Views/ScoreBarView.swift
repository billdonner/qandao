//
//  ScoreBarView.swift
//  qdemo
//
//  Created by bill donner on 5/24/24.
//

import SwiftUI
private struct zz:View {
  let showchars:String
  let gs: GameState
  var body: some View{
    ScrollView(.horizontal, showsIndicators: false)  {
      HStack {
      Text(showchars).font(showchars.count<=1 ? .title:.footnote)
        
        Text("time:");Text(formatTimeInterval(gs.totaltime)) .font(isIpad ? .title:.headline)
        Text("score:");Text("\(gs.totalScore())")
          .font(isIpad ? .title:.headline)
        Text("gimmees:");Text("\(gs.gimmees)")
          .font(isIpad ? .title:.headline)
        HStack {
          Text("games:");Text("\(gs.gamenumber)")
          Text("won:");Text("\(gs.woncount)")
          Text("lost:");Text("\(gs.lostcount)")
          Text("right:");Text("\(gs.rightcount)")
          Text("wrong:");Text("\(gs.wrongcount)")
        }.opacity(0.8)
      }
    }.font(isIpad ? .title:.footnote)
    }
  }
struct ScoreBarView: View {
  let gs: GameState
  @State var showWinAlert = false
  @State var showLoseAlert = false
  var body:some View {
    return  VStack{
      HStack {
        let showchars = if isWinningPath(in:gs.cellstate ) {"😎"}
        else {
          if !isPossibleWinningPath(in:gs.cellstate) {
            "❌"
          } else {
           " "// "possibles: \(numberOfPossibleMoves(in: gs.cellstate))"
          }
        }
        zz(showchars: showchars,gs:gs).font(isIpad ?.title:.body)
      }
        if gs.gamestate == .playingNow {
         /// Text ("game in progress...").foregroundStyle(.blue )
        } else {
        //  Text ("you can start a new game now ").foregroundStyle(.green )
          if gs.startincorners {
         //   Text("you've got to start in a corner")
            //  .font(.footnote).foregroundStyle(.green )
          }
        }
      }

      .onChange(of:gs.cellstate) {
        if isWinningPath(in:gs.cellstate) {
          print("--->you have won this game as detected by ScoreBarView")
          showWinAlert = true
          gs.woncount += 1
          gs.saveGameState()
          
        } else {
          if !isPossibleWinningPath(in:gs.cellstate) {
            print("--->you cant possibly win this game s detected by ScoreBarView")
            showLoseAlert = true
            gs.lostcount += 1
            gs.saveGameState()
          }
        }
      }
    }
  }

#Preview {
  ScoreBarView(gs: GameState(size: 3, topics: ["a","b","c"], challenges: []))
}
