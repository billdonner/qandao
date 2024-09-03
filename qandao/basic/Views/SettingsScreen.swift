import SwiftUI

fileprivate struct SettingsView: View {
  
  @Bindable var chmgr:ChaMan
  @Bindable var gs:GameState
  
  let lrdb:LeaderboardService

  internal init(chmgr:ChaMan,gs:GameState,lrdb:LeaderboardService)//,
  {
    self.gs = gs
    self.chmgr = chmgr
    self.lrdb = lrdb
    self.ourTopics =    chmgr.playData.allTopics
   // let remainingTopics = removeElements(from:chmgr.playData.allTopics,elementsToRemove:gs.topicsinplay)
    l_topicsinplay = gs.topicsinplay//State(initialValue: chosenTopics)
    l_facedown = gs.facedown
    l_boardsize = gs.boardsize
    l_doubleDiag = gs.doublediag
    l_currentScheme = gs.currentscheme
    l_difficultyLevel = gs.difficultylevel
    l_startInCorners = gs.startincorners
  }
  let ourTopics: [String]
  @State private var  l_boardsize: Int
  @State private var  l_startInCorners: Bool
  @State private var  l_facedown: Bool
  @State private var  l_doubleDiag: Bool
  @State private var  l_currentScheme:ColorSchemeName
  @State private var  l_difficultyLevel: Int
  @State private var  l_topicsinplay: [String]
  
  // @State var selectedTopics: [String]
 // @State var availableTopics: [String]
  @State var tappedIndices: Set<Int> = []
  @State var replacedTopics: [Int: String] = [:]
  @State var selectedAdditionalTopics: Set<String> = []
  @State var firstOnAppear = true
 // @State var showLeaderboard = false
  @State private var showSettings = false
  
  
  @State var colorSchemeName : ColorSchemeName = 2//.summer // hack //summer
  @Environment(\.presentationMode) var presentationMode

  
  var body: some View {
    VStack {
      
      Form {
//        Button(action: {showLeaderboard.toggle()}){
//          Text("Visit the Leaderboard")
//        }
        Section(header: Text("Complexity")) {
          SizePickerView(chosenSize: $l_boardsize)
            .onChange(of:l_boardsize) {
              switch l_boardsize {
              case 3:l_facedown=false;l_startInCorners=false
              case 4:l_facedown=false;l_startInCorners=false
              case 5:l_facedown=true;l_startInCorners=false
              case 6:l_facedown=true;l_startInCorners=true
              case 7:l_facedown=true;l_startInCorners=true
              default :l_facedown=true;l_startInCorners=true
              }
            }
        }
        Section(header: Text("Topics")) {
          
       
          
            TopicSelectorView(allTopics: chmgr.everyTopicName,
                              selectedTopics:  $l_topicsinplay,
                              selectedSchemeIndex:$l_currentScheme,
                              chmgr: chmgr, gs:gs, boardSize:l_boardsize)
        }
        Section(header:Text("About QANDA")) {
          VStack{
            HStack { Spacer()
              AppVersionInformationView(
                name:AppNameProvider.appName(),
                versionString: AppVersionProvider.appVersion(),
                appIcon: AppIconProvider.appIcon()
              )
              Spacer()
            }
            Button(action: { showSettings.toggle() }) {
              Text("Freeport Settings")
            }
            Picker("Color Palette", selection: $colorSchemeName) {
              ForEach(AppColors.allSchemes.indices.sorted(),id:\.self) { idx in
                Text("\(AppColors.pretty(for:AppColors.allSchemes[idx].name))")
                  .tag(idx)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(colorPaletteBackground(for:gs.currentscheme).clipShape(RoundedRectangle(cornerRadius: 10)))
            .padding(.horizontal)
            
            .onChange(of: colorSchemeName) {
              withAnimation {
                gs.currentscheme = colorSchemeName
              }
            }
          }
        }
      }
      }
      .sheet(isPresented:$showSettings){
        FreeportSettingsScreen(gs: gs, chmgr: chmgr, lrdb: lrdb)
      }
//      .sheet(isPresented: $showLeaderboard) {
//        LeaderboardScreen(leaderboardService:lrdb)
//      }
      .onAppear {
        if firstOnAppear {
          firstOnAppear = false
          chmgr.checkAllTopicConsistency("GameSettings onAppear")
        }
      }
      .navigationBarTitle("Game Settings", displayMode: .inline)
      .navigationBarItems(
        leading: Button("Cancel") {
          // dont touch anything
          self.presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("Done") {
          onDonePressed() // update global state
          self.presentationMode.wrappedValue.dismiss()
        }
      )

    }
 
  private func onDonePressed() {
    // copy every change into gameState
    gs.doublediag = l_doubleDiag
    gs.difficultylevel = l_difficultyLevel
    gs.startincorners = l_startInCorners
    gs.facedown = l_facedown
    gs.boardsize = l_boardsize
    gs.board = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
    gs.cellstate = Array(repeating: Array(repeating: .unplayed, count: l_boardsize), count: l_boardsize)
    gs.moveindex = Array(repeating: Array(repeating: -1, count: l_boardsize), count: l_boardsize)
    gs.onwinpath = Array(repeating: Array(repeating: false, count: l_boardsize), count: l_boardsize)
    gs.replaced = Array(repeating: Array(repeating: [], count: l_boardsize), count: l_boardsize)
    gs.topicsinplay = l_topicsinplay // //*****2
    gs.currentscheme =  l_currentScheme 
    chmgr.checkAllTopicConsistency("GameSettingScreen onDonePressed")
    gs.saveGameState()
  }
}

struct SettingsScreen :
  View {
  @Bindable var chmgr: ChaMan
  @Bindable var gs: GameState
  
  let lrdb:LeaderboardService

 // let onExit: ([String])->()
  
  var body: some View {
    NavigationView  {
      SettingsView(
        chmgr: chmgr,
        gs:gs,
        lrdb:lrdb//,
       // onExit: onExit
      )
    }
  }
}
#Preview {
  SettingsScreen(chmgr: ChaMan.mock,gs:GameState.mock,lrdb:LeaderboardService())
}
/*
 Picker("Board Size", selection: $l_boardsize) {
   Text("3x3").tag(3)
   Text("4x4").tag(4)
   Text("5x5").tag(5)
   Text("6x6").tag(6)
   Text("7x7").tag(7)
   Text("8x8").tag(8)
 }
 .pickerStyle(SegmentedPickerStyle())
 Picker("Difficulty Level", selection: $l_difficultyLevel) {
   Text("Easy").tag(1)
   Text("Normal").tag(2)
   Text("Hard").tag(3)
 }
 .pickerStyle(SegmentedPickerStyle())
 .background(Color(.systemBackground).clipShape(RoundedRectangle(cornerRadius: 10)))
 
 
 HStack {
   Text("Loose")
   Spacer()
   Toggle("", isOn: startInCorners())
     .labelsHidden()
  // .disabled(l_boardsize>6)
   Spacer()
   Text("Strict")
 }
 .frame(maxWidth: .infinity)
 
 
 HStack {
   Text("Face Up")
   Spacer()
   Toggle("", isOn:faceDown())
     //.disabled(l_boardsize>4)
     .labelsHidden()
   Spacer()
   Text("Face Down")
 }
   .frame(maxWidth: .infinity)
 
 */
//          NavigationLink(destination: TopicsChooserScreen(
//            allTopics:chmgr.everyTopicName,
//            schemes: AppColors.allSchemes,
//            boardsize: gs.boardsize,
//            topicsinplay: gs.topicsinplay,
//            chmgr: chmgr,
//            currentScheme: $l_currentScheme,
//            selectedTopics: $l_topicsinplay))
//          {
//            Text("Choose Topics")
//          }
          
