import SwiftUI

 struct SettingsView: View {
  
  @Bindable var chmgr:ChaMan
  @Bindable var gs:GameState
  let lrdb:LeaderboardService
  @Binding var showSettings: Bool

  @State private var  l_gimms: Int
  @State private var  l_boardsize: Int
  @State private var  l_startInCorners: Bool
  @State private var  l_facedown: Bool
  @State private var  l_doubleDiag: Bool
  @State private var  l_currentScheme:ColorSchemeName
  @State private var  l_difficultyLevel: Int
  @State private var  l_topicsinplay: [String]
  @State private var  l_scheme : ColorSchemeName // hack //summer
   
   init(chmgr:ChaMan,gs:GameState,lrdb:LeaderboardService,showSettings:Binding<Bool>)
   {
     self.chmgr = chmgr
     self.gs = gs
     self.lrdb = lrdb
     self._showSettings =  showSettings
    l_topicsinplay = gs.topicsinplay
    l_facedown = gs.facedown
    l_boardsize = gs.boardsize
    l_doubleDiag = gs.doublediag
    l_currentScheme = gs.currentscheme
    l_difficultyLevel = gs.difficultylevel
    l_startInCorners = gs.startincorners
    l_scheme = gs.currentscheme
    l_gimms = gs.gimmees
   }
   
 
  @State var tappedIndices: Set<Int> = []
  @State var replacedTopics: [Int: String] = [:]
  @State var selectedAdditionalTopics: Set<String> = []
  @State var firstOnAppear = true
  @State var showTopicSelector = false
  @State private var showFreeportSettings = false
  @State private var cpv : [[Color]] = []

  @Environment(\.presentationMode) var presentationMode

  var colorPicker: some View {
    Picker("Color Palette", selection: $l_scheme) {
      ForEach(AppColors.allSchemes.indices.sorted(),id:\.self) { idx in
        Text("\(AppColors.pretty(for:AppColors.allSchemes[idx].name))")
          .tag(idx)
      }
    }
    .pickerStyle(SegmentedPickerStyle())
    .background(colorPaletteBackground(for:l_currentScheme).clipShape(RoundedRectangle(cornerRadius: 10)))
    .padding(.horizontal)
 
  }
  
  var body: some View {
  
      Form {
        Section(header: Text("Topics")) {
          
          Button(action:{showTopicSelector.toggle()}){
            Text("Edit Topics")
          }
          
        }
        Section(header: Text("Board")) {
          VStack(alignment: .center){
            SizePickerView(chosenSize: $l_boardsize)
              .onChange(of:l_boardsize) {
                switch l_boardsize {

                default :l_facedown=true;l_startInCorners=true
                }
              }
            
    
            PreviewGridView(gs: gs, chmgr: chmgr, boardsize:$l_boardsize,scheme:$l_currentScheme)
              .frame(width: 200,height: 200)
            
            colorPicker
              .onChange(of: l_scheme) {
                withAnimation {
                 // gs.currentscheme = colorSchemeName
                  l_currentScheme = l_scheme
                }
              }
            
          }
          
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
            Button(action: { showFreeportSettings.toggle() }) {
              Text("Freeport Settings")
            }
          }
        }
      }
      
      .sheet(isPresented:$showFreeportSettings){
        FreeportSettingsScreen(gs: gs, chmgr: chmgr, lrdb: lrdb,showSettings:$showSettings)
      }
      .sheet(isPresented: $showTopicSelector) {
          TopicSelectorView(allTopics: chmgr.everyTopicName,
                            selectedTopics:  $l_topicsinplay,
                            selectedSchemeIndex:$l_currentScheme,
                            chmgr: chmgr,
                            gs:gs,minTopics:GameState.minTopicsForBoardSize(l_boardsize),
                            maxTopics:
                              GameState.maxTopicsForBoardSize(l_boardsize),gimms: $l_gimms)
      }
      .onAppear {
        if firstOnAppear {
          firstOnAppear = false
          chmgr.checkAllTopicConsistency("GameSettings onAppear")
        }
        cpv = gs.previewColorMatrix(size: l_boardsize,scheme: l_currentScheme)
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
    gs.gimmees = l_gimms // copy in adjustment from topic selector
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















struct SettingsScreen : View {
  @Bindable var chmgr: ChaMan
  @Bindable var gs: GameState
  
  let lrdb:LeaderboardService
  @Binding var showSettings: Bool
  
  var body: some View {
    NavigationView  {
      SettingsView(
        chmgr: chmgr,
        gs:gs,
        lrdb:lrdb,
        showSettings:$showSettings
      )
    }
  }
}
#Preview {
  SettingsScreen(chmgr: ChaMan.mock,gs:GameState.mock,lrdb:LeaderboardService(),showSettings:(.constant(true)))
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
          
//                case 3:l_facedown=false;l_startInCorners=false
//                case 4:l_facedown=false;l_startInCorners=false
//                case 5:l_facedown=true;l_startInCorners=false
//                case 6:l_facedown=true;l_startInCorners=true
//                case 7:l_facedown=true;l_startInCorners=true
