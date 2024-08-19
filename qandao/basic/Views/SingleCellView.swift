//
//  SingleCellView.swift
//  basic
//
//  Created by bill donner on 7/30/24.
//


import SwiftUI
@ViewBuilder
func markView(at position: CornerPosition, size: CGFloat) -> some View {
  
   let markSize: CGFloat = CGFloat(size)/10.0
    let offset: CGFloat = 100.0
    let xpos = position == .topLeft || position == .bottomLeft ? offset : size - offset
    let ypos =  position == .topLeft || position == .topRight ? offset : size - offset
  
    Circle()
        .fill(Color.orange)
        .frame(width: markSize, height: markSize)
        .position(x: xpos, y: ypos)
}
struct Sdi: Identifiable
{
  let row:Int
  let col:Int
  let id=UUID()
}
enum ChallengeOutcomes: Codable {
  
  case playedCorrectly
  case playedIncorrectly
  case unplayed
  
  var borderColor: Color {
    switch self {
    case .playedCorrectly: return Color.neonGreen
    case .playedIncorrectly: return Color.neonRed
    case .unplayed: return .gray
    }
  }
}
enum CornerPosition: CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
extension Color {
  static let offBlack = Color(red: 0.1, green: 0.1, blue: 0.1)
  static let offWhite = Color(red: 0.95, green: 0.95, blue: 0.95)
}
struct HappySmileyView : View {
  let color:Color
  @Environment(\.colorScheme) var colorScheme //system light/dark
  var body: some View {
    ZStack {
      colorScheme == .dark ? Color.offBlack : Color.offWhite
      Circle().foregroundStyle(color)
    }
  }
}
#Preview ("Happy") {
  HappySmileyView(color: .blue)
    .frame(width: 100, height: 100) // Set the size of the square
}

 
#Preview ("Gloomy"){
  GloomyView(color:.red)
    .frame(width: 100, height: 100) // Set the size of the square
}

let fudge = 3.0
struct GloomyView: View {
  let color:Color
  @Environment(\.colorScheme) var colorScheme //system light/dark
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Black background
                colorScheme == .dark ? Color.offBlack : Color.offWhite
                // White diagonal line
                Path { path in
                    let size = geometry.size
                    path.move(to: CGPoint(x: fudge, y: fudge))
                    path.addLine(to: CGPoint(x: size.width-fudge, y: size.height-fudge))
                  path.move(to: CGPoint(x:  size.width-fudge, y: fudge))
                  path.addLine(to: CGPoint(x:fudge, y: size.height-fudge))
                }
                .stroke(color, lineWidth: 5)
            }
        }
    }
}
let cornerradius = 0.0

struct SingleCellView: View {
  let gs:GameState
  let chmgr:ChaMan
  let row:Int
  let col:Int
  let chidx:Int
  let status:ChallengeOutcomes
  let cellSize: CGFloat
  let onSingleTap: (_ row:Int, _ col:Int ) -> Bool
  @Binding var firstMove:Bool
  @Binding var isTouching:Bool
  @Environment(\.colorScheme) var colorScheme //system light/dark
  @State var alreadyPlayed:Sdi?
  var body: some View {
    let thisCellIsLastMove:Bool  = gs.lastmove?.row == row &&  gs.lastmove?.col == col
    let challenge = chidx < 0 ? Challenge.amock : chmgr.everyChallenge[chidx]
    let colormix = gs.colorForTopic(challenge.topic)

    return  ZStack {
      // part 1:
      // if faceup show the question else blank
      VStack(alignment:.center, spacing:0) {
        if row<gs.boardsize && col<gs.boardsize {
          switch gs.cellstate[row][col] {
            
          case .playedCorrectly:
            HappySmileyView(color:colormix.0)
              .cornerRadius(cornerradius)
              .frame(width: cellSize, height: cellSize)
              .opacity(gs.gamestate == .playingNow ? 1.0:0.7)
          case .playedIncorrectly:
            GloomyView(color:colormix.0)
              .cornerRadius(cornerradius)
              .frame(width: cellSize, height: cellSize)
              .opacity(gs.gamestate == .playingNow ? 1.0:0.7)
          case .unplayed:
            if ( gs.gamestate == .playingNow ) {
              Text(gs.facedown ? "" : challenge.question)
                .font(.caption)
                .padding(10)
                .frame(width: cellSize, height: cellSize)
                .background(colormix.0)
                .foregroundColor(foregroundColorFrom( backgroundColor: colormix.0 ))
                .cornerRadius(cornerradius)
                .opacity(gs.gamestate == .playingNow ? 1.0:0.7)
            } else {
              if  colorScheme == .dark { Color.offBlack
                  .cornerRadius(cornerradius)
                  .opacity(gs.gamestate == .playingNow ? 1.0:0.7)
              } else {
                Color.offWhite
                    .cornerRadius(cornerradius)
                    .opacity(gs.gamestate == .playingNow ? 1.0:0.7)
              }
            }
            
          }
        }
      }
 
      
      // part 3:
      // mark corner of last move with orange circle
      if thisCellIsLastMove && isTouching {
        Circle()
          .fill(Color.orange)
          .frame(width: cellSize/6, height: cellSize/6)
          .offset(x:-cellSize/2 + 10,y:-cellSize/2 + 10)
      }// might have row or col out of whack here
      // mark upper right as well if its been replaced
      
  if row<gs.boardsize && col<gs.boardsize && isTouching{
    if gs.startincorners { // playing corners
       
      if   ( gs.isCornerCell(row: row, col: col))  ||
        hasAdjacentNeighbor(withStates: [.playedCorrectly,.playedIncorrectly], in: gs.cellstate, for: (row,col)) {
        Circle()
          .fill(Color.blue)
          .frame(width: cellSize/6, height: cellSize/6)
          .offset(x:cellSize/2 - 7,y:-cellSize/2 + 10)
      }
 
    }
    
      if gs.replaced[row][col] != [] {
        Circle()
          .fill(Color.neonRed)
          .frame(width: cellSize/6, height: cellSize/6)
          .offset(x:-cellSize/2 + 10,y:cellSize/2 - 10)
      }
          
        
        // part 4:
        // nice sfsymbols only until 50
        if gs.moveindex[row][col] == -1 {
          Text("???").font(.footnote).opacity(gs.moveindex[row][col] != -1 ? 1.0:0.0)
        } else
        if gs.moveindex[row][col] > 50 {     Text("\(gs.moveindex[row][col])").font(.footnote).opacity(gs.moveindex[row][col] != -1 ? 1.0:0.0)
        }
        else {
          //use the sfsymbol // if cell incorrectly played always use white
          Image(systemName:"\(gs.moveindex[row][col]).circle")
            .font(.largeTitle)
            .opacity(gs.moveindex[row][col] != -1 ? 0.7:0.0)
            .foregroundColor( gs.cellstate[row][col] == .playedIncorrectly ?
                              (colorScheme == .dark ? .white: .black) :
              foregroundColorFrom( backgroundColor:gs.colorForTopic (challenge.topic ).0)
            )
        }
        // part 5:
        // highlight the winning path with a green checkmark overlays
        if gs.onwinpath[row][col] {
          Image(systemName:"checkmark")
            .font(.largeTitle)
            .foregroundColor(.green)
        }
      }// row in bounds
    }
    .sheet(item: $alreadyPlayed) { goo in
      AlreadyPlayedView(ch: challenge,gs:gs,chmgr:chmgr)
    }
    // for some unknown reason, the tap surface area is bigger if placed outside the VStack
    .onTapGesture {
      var  tap = false
      /* if already played  present a dffirent view */
        if gs.isAlreadyPlayed(row:row,col:col)  {
          alreadyPlayed = Sdi(row:row,col:col)
        } else
     if  gs.gamestate == .playingNow { // is the game on
        if  gs.cellstate[row][col] == .unplayed {
          // if we've got to start in corner on firstMove
          if gs.startincorners {
            if firstMove{
              tap =  gs.isCornerCell(row: row,col: col)
            } else {
              tap =  gs.isCornerCell(row: row,col: col) ||      hasAdjacentNeighbor(withStates: [.playedCorrectly,.playedIncorrectly], in: gs.cellstate, for: (row,col))
            }
          }
          else {
            tap = true
          }
        }
      } // actually playing the game
      if tap {
        
        gs.lastmove =    GameMove(row:row,col:col,movenumber: gs.movenumber)
        firstMove =    onSingleTap(row,col)
      }
    }
  }// make one cell
}

#Preview ("No Touching") {
  
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedIncorrectly
      return   SingleCellView(
          gs: GameState.mock,
            chmgr: ChaMan(playData:PlayData.mock),
            row: 0,
            col: 0,
            chidx: 0,
            status: .unplayed,
            cellSize: 250,
            onSingleTap: { _, _ in true },
          firstMove: .constant(false),
          isTouching: .constant(false)
        )
        .previewLayout(.sizeThatFits)
    }

#Preview ("Touching"){
  let gs = GameState.mock
  gs.cellstate[0][0] = .playedCorrectly
        return SingleCellView(
          gs: GameState.mock,
            chmgr: ChaMan(playData:PlayData.mock),
            row: 0,
            col: 0,
            chidx: 0,
            status: .unplayed,
            cellSize: 250,
            onSingleTap: { _, _ in true },
          firstMove: .constant(true),
          isTouching: .constant(true)
        )
        .previewLayout(.sizeThatFits)
    }
