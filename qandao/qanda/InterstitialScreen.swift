//
//  InterstitialScreen.swift
//  qanda
//
//  Created by bill donner on 2/17/24.
//

import SwiftUI
import ComposableArchitecture
import q20kshare


struct InterstitialScreen1: View {
  let topic: String
  var body: some View {
    ZStack {
      FirefliesVortexScreenOverlay()
      VStack {
        Text("Moving to Level 3")
        Text(topic).font(.system(size: 72))
        Text("Current score")
        HStack{Text("32 ").font(.system(size: 72));Text("Keep Going").font(.headline).foregroundColor(.red)}
      }
    }
  }
}


struct InterstitialScreen2: View {
  let topic1: String
  let topic2: String
  var body: some View {
    ZStack {
      SparkleVortexScreenOverlay()
      VStack {
        Spacer()
        VStack(alignment: .leading){
          Text("Finished Level 3")
          Text(topic1).font(.system(size: 72)).lineLimit(3)
          Text("topic score")
          HStack{Text("41 ").font(.system(size: 72));Text("Good Job").font(.headline).foregroundColor(.red)}
        }
        Spacer()
        VStack(alignment: .leading){
          Text("Next Level 4")
          Text(topic2).font(.system(size: 72)).lineLimit(3)
        }
        Spacer()
        Button(action: {},label: {Label("Next",systemImage: "arrow.right")}).font(.system(size: 36)).padding()
        Spacer()
      }
    }
  }
}

struct InterstitialScreen3: View {
  let topic1: String
  var body: some View {
    ZStack {
      ConfettiVortexScreenOverlay()
      VStack {
        Spacer()
        VStack(alignment: .leading){
          Text("Finished Level6")
          Text(topic1).font(.system(size: 72)).lineLimit(3)
          Text("topic score")
          HStack{Text("77 ").font(.system(size: 72));Text("Great Job").font(.headline).foregroundColor(.red)}
        }
        Spacer()
        VStack(alignment: .leading){
          Text("You Win").font(.system(size: 72)).lineLimit(3)
        }
        Spacer()
        Button(action: {},label: {Label("New Game",systemImage: "arrow.right")}).font(.system(size: 36)).padding()
        
        Button(action: {},label: {Label("Settings",systemImage: "arrow.right")}).font(.system(size: 36)).padding()
        Spacer()
      }
    }
  }
}



struct InterstitialScreen4: View {
  let topic1: String
  var body: some View {
    ZStack {
      RainSplashVortexScreenOverlay()
      VStack {
        Spacer()
        VStack(alignment: .leading){
          Text("Finished Level6")
          Text(topic1).font(.system(size: 72)).lineLimit(3)
          Text("topic score")
          HStack{Text("01 ").font(.system(size: 72));Text("You Suck").font(.headline).foregroundColor(.red)}
        }
        Spacer()
        VStack(alignment: .leading){
          Text("You Lose").font(.system(size: 72)).lineLimit(3)
        }
        Spacer()
        Button(action: {},label: {Label("New Game",systemImage: "arrow.right")}).font(.system(size: 36)).padding()
        
        Button(action: {},label: {Label("Settings",systemImage: "arrow.right")}).font(.system(size: 36)).padding()
        Spacer()
      }
    }
  }
}



struct TopicsChooserView: View {
  @Bindable var store:StoreOf<AppFeature>
  let appState: AppState
  let loginID:String
  @Binding var gd:[GameData]
  @Binding var reset:Bool
  @EnvironmentObject var logManager: LogEntryManager
  
  var body: some View {
    NavigationStack {
Text("""

You are playing at the "Simple" difficulty setting.

Pick any 3 Topics and hit "GO" when ready to play.


""").padding()
      ScrollView {
        ForEach(gd, id: \.self) {   gameData  in
          if let index = appState.indexForTopic(gameData.topic),
             let sbt = appState.scoresByTopic[gameData.topic] {
            SimpleTopicRowView(appState:appState,
                               sbt:sbt,
                               gameData:gameData,
                               logManager:logManager )
                    .applyTintWithProbability()
              .tag(index)
          }
        }
        Spacer()
      }
      Button("GO") {
        
      }.font(.largeTitle)
      .navigationBarItems(trailing:     Button {
 
      } label: {
        HStack {
          Image(systemName: "questionmark.circle")
        }
      })
      .navigationBarTitle("Choose 3 Topics")
      Spacer()
    }
 
  }
}



struct TopicsChooser2View: View {
  @Bindable var store:StoreOf<AppFeature>
  let appState: AppState
  let loginID:String
  @Binding var gd:[GameData]
  @Binding var reset:Bool
  @EnvironmentObject var logManager: LogEntryManager
  
  var body: some View {
    NavigationStack {
Text("""
You are playing at the "Simple" difficulty setting.

Pick any group of 3 Topics by tapping on the first.

Then hit "GO" when ready to play.
""").padding()
      ScrollView {
        ForEach(gd, id: \.self) {   gameData  in
          if let index = appState.indexForTopic(gameData.topic),
             let sbt = appState.scoresByTopic[gameData.topic] {
            SimpleTopicRowView(appState:appState,
                               sbt:sbt,
                               gameData:gameData,
                               logManager:logManager )
            .opacity(index>0 && index<4 ? 1.0:0.5)
            //.tag(index)
          }
        }
        Spacer()
      }
      Button("GO") {
        
      }.font(.largeTitle)
      .navigationBarItems(trailing:     Button {
 
      } label: {
        HStack {
          Image(systemName: "questionmark.circle")
        }
      })
      .navigationBarTitle("Choose First Topic")
      Spacer()
    }
  }
}



struct SplashView : View {
  var body: some View {
    Image("Picture")
  }
}

#Preview {
  SplashView()
}

#Preview {
  TopicsChooserView(store:  Store(initialState: AppFeature.State())
             { AppFeature() },
               appState: SampleData.mock,
               loginID:"MY_LOGIN_UUID",
               gd:.constant(SampleData.gd),
               reset:.constant(false)  )
      .environmentObject(LogEntryManager.mock)
}

#Preview {
  TopicsChooser2View(store:  Store(initialState: AppFeature.State())
             { AppFeature() },
               appState: SampleData.mock,
               loginID:"MY_LOGIN_UUID",
               gd:.constant(SampleData.gd),
               reset:.constant(false)  )
      .environmentObject(LogEntryManager.mock)
}

#Preview {
  InterstitialScreen1(topic: "Criminals")
}

#Preview {
  InterstitialScreen2(topic1: "Crooked Politicians",topic2:"Criminals")
}

#Preview {
  InterstitialScreen3(topic1: "Crooked Politicians" )
}

#Preview {
  InterstitialScreen4(topic1: "Crooked Politicians" )
}
