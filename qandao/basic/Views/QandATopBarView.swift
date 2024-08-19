import SwiftUI
struct QandATopBarView: View {
    let gs:GameState
   // let geometry: GeometryProxy
    let topic: String
    let hint:String
    let handlePass: () -> Void
    let handleGimmee: () -> Void
    let toggleHint: () -> Void
  
  @Binding var elapsedTime: TimeInterval   // Elapsed time in seconds
  @Binding var killTimer: Bool
  
  @State private var timer: Timer? = nil  // Timer to track elapsed time 
 // @State   var gimmeeAlert = false
  func startTimer() {
    elapsedTime = 0
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      elapsedTime += 1
    }
  }

  public func stopTimer() {
    
    // guard against doing this twice
    if timer != nil {
      gs.totaltime += elapsedTime
      timer?.invalidate()
      timer = nil
    }
  }
  
  var formattedElapsedTime: String {
    let minutes = Int(elapsedTime) / 60
    let seconds = Int(elapsedTime) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
    var body: some View {
     // let _ = print("//QandATopBarView \(formattedElapsedTime)")
     
      VStack(alignment:.leading, spacing:0) {
        HStack {
          Spacer()
         passButton
            .padding(.trailing, 20)
        }
        VStack(alignment:.leading) {
          Text(topic).multilineTextAlignment(.leading)
            .font(.headline)
            .lineLimit(2)//,reservesSpace: true)
            .foregroundColor(.primary)
          elapsedTimeView
          additionalInfoView
        }.padding().debugBorder()
 
      }.debugBorder()
        //.padding(.top)

        .onAppear {
          startTimer()
        }
        .onDisappear {
          stopTimer()
        }
        .onChange(of: killTimer) { oldValue, newValue in
          stopTimer()
        }
    }
    
    var passButton: some View {
        Button(action: {
            handlePass()
        }) {
            Image(systemName: "xmark")
               // .font(.title)
                .foregroundColor(.primary)
               // .frame(width: buttSize, height: buttSize)
               // .background(Color.gray)
                //.cornerRadius(10)
        }
    }

    var elapsedTimeView: some View {
        Text("time to answer: \(formattedElapsedTime)")
            .font(.footnote)
            .foregroundColor(.secondary)
    }

    var additionalInfoView: some View {
      Text("total time:\(Int(gs.totaltime)) score:\(gs.totalScore()) gimmees:\(gs.gimmees)")
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}

#Preview {

    QandATopBarView(
      gs: GameState.mock,
      topic: "American History running and running to great lengths",
      hint: "What can we say about history?",
      handlePass:{}, handleGimmee: {}, toggleHint: {},
      elapsedTime: .constant(23984923.0),
      killTimer:.constant(false)
    )
  }
#Preview ("dark"){

    QandATopBarView(
      gs: GameState.mock,
      topic: "American History running and running to great lengths",
      hint: "What can we say about history?",
      handlePass:{}, handleGimmee: {}, toggleHint: {},
      elapsedTime: .constant(23984923.0),
      killTimer:.constant(false)
    )
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }