import SwiftUI

struct ContentView: View {
  @State var restartCount = 0
  @Bindable var gs: GameState
  @Bindable var chmgr: ChaMan
  @State var current_size: Int = starting_size
  @State var current_topics: [String] = []
  @State var chal: IdentifiablePoint? = nil
  @State var isPresentingDetailView = false
  

  
  var body: some View {
     GeometryReader { geometry in
       VStack(spacing:20) {
          GameScreen(gs: gs, chmgr: chmgr, topics: $current_topics, size: $current_size) { row, col in
            isPresentingDetailView = true
            chal = IdentifiablePoint(row: row, col: col, status: chmgr.stati[row * gs.boardsize + col])
            return false
          }
          .frame(width:geometry.size.width, height:geometry.size.width*1.37)
          .onAppear {
            if gs.veryfirstgame {
              chmgr.loadAllData(gs: gs)
              chmgr.checkAllTopicConsistency("ContentView onAppear0")
              current_size = gs.boardsize
              if gs.topicsinplay.count == 0 {
                gs.topicsinplay = getRandomTopics(GameState.minTopicsForBoardSize(current_size),
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
          ContentViewBottomButtons(gs:gs, chmgr: chmgr)
          
        }
      }
  }
}
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

#Preview {
  ContentView(gs: GameState.mock, chmgr: ChaMan.mock)
}


