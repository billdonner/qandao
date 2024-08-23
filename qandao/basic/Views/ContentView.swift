import SwiftUI

struct ContentView: View {
  @State var restartCount = 0
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @State var current_size: Int = starting_size
  @State var current_topics: [String] = []
  @State var chal: IdentifiablePoint? = nil
  @State var isPresentingDetailView = false
  
  
  @State  var isTouching = false
  
  var body: some View {
     GeometryReader { geometry in
       VStack(spacing:20) {
         GameScreen(gs: gs, chmgr: chmgr, topics: $current_topics, size: $current_size, isTouching: $isTouching) { row, col in
            isPresentingDetailView = true
            chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
            return false
          }
          .frame(width:geometry.size.width, height:geometry.size.width*spareHeightFactor)
          .onAppear {
            if gs.veryfirstgame {
              chmgr.loadAllData(gs: gs)
              chmgr.checkAllTopicConsistency("ContentView onAppear0")
              current_size = gs.boardsize
              if gs.topicsinplay.count == 0 {
                gs.topicsinplay = getRandomTopics(7,//GameState.minTopicsForBoardSize(current_size),
                                                  from: chmgr.everyTopicName)
              }
              current_topics = gs.topicsinplay
              chmgr.checkAllTopicConsistency("ContentView onAppear2")
              // print("//ContentView first onAppear size:\(current_size) topics:\(current_topics) restartcount \(restartCount)")
            } else {
              // print("//ContentView onAppear restart size:\(current_size) topics:\(current_topics) restartcount \(restartCount)")
            }
            restartCount += 1
            gs.veryfirstgame = false
          }
          .onDisappear {
            print("Yikes the ContentView is Disappearing!")
          }
          .sheet(item: $chal) { cha in
            QandAScreen(row: cha.row, col: cha.col,
                        isPresentingDetailView: $isPresentingDetailView, chmgr: chmgr, gs: gs)
          }
          TopicIndexView(gs: gs, chmgr: chmgr)
         ContentViewBottomButtons(gs:gs, chmgr: chmgr, isTouching: $isTouching)
          
        }
      }
  }
}

#Preview ("light"){
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock)
}
#Preview ("dark"){
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock)
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}



