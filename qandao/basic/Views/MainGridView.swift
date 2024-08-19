//
//  MainGridView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//


import SwiftUI

struct MainGridView : View {
  let gs:GameState
  let chmgr:ChaMan
  @Binding var firstMove: Bool
  @Binding var isTouching : Bool
  let onSingleTap: (Int,Int)->Bool
  
  var body: some View {
    let spacing: CGFloat = 1.0 * (isIpad ? 1.2 : 1.0)
    
    return   GeometryReader { geometry in
      let totalSpacing = spacing * CGFloat(gs.boardsize + 1)
      let axisSize = min(geometry.size.width, geometry.size.height) - totalSpacing
      let cellSize = (axisSize / CGFloat(gs.boardsize)) //* shrinkFactor  // Apply shrink factor
      VStack(alignment:.center, spacing: spacing) {
        ForEach(0..<gs.boardsize, id: \.self) { row in
          HStack(spacing:0) {
            Spacer(minLength:spacing/2)
            ForEach(0..<gs.boardsize, id: \.self) { col in
              // i keep getting row and col out of bounds, so clamp it
              if row < gs.boardsize  && col < gs.boardsize
              //&&  gs.board[row][col] >= 0
              { // ensure its inbounds and allocated
                SingleCellView(gs:gs,chmgr:chmgr,row:row,col:col,
                               chidx:gs.board[row][col],
                               status:gs.cellstate[row][col],
                               cellSize: cellSize, onSingleTap:  onSingleTap,firstMove:$firstMove,isTouching:$isTouching)
              }
              else {
                Color.clear
                  .frame(width: cellSize, height: cellSize)
              }
              Spacer(minLength:spacing/2)
            }
          }
        }
      }
    }
  }
}

#Preview ("MainGridView") {
  MainGridView(gs: GameState.mock, 
               chmgr: ChaMan(playData: PlayData.mock),
               firstMove: .constant(false),
               isTouching: .constant(false) ,
               onSingleTap: { row,col in
    print("Tapped cell with challenge \(row) \(col)")
    return false
  }
  )
  
}
