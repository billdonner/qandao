//
//  EssentialChallengeView.swift
//  qanda
//
//  Created by bill donner on 1/28/24.
//

import SwiftUI
import q20kshare
import ComposableArchitecture


struct HintBottomSheetView : View {
  let hint:String
  var body: some View {
    VStack {
      Image(systemName:"line.3.horizontal.decrease")
      Spacer()
      HStack{
        Text(hint).font(.headline)
      }
      Spacer()
    }
 .frame(maxWidth:.infinity)
    .background(.blue).opacity(0.4)
    .foregroundColor(.white)
   // .ignoresSafeArea()
  }
}


struct EssentialChallengeView: View {
  @Bindable var store: StoreOf<ChallengesFeature>
  let appState: AppState
  @State private var hintpressed = false
  var body: some View {
  //  assert (topicIndex==appState.currentTopicIndex)
    let tc = appState.thisChallenge
    return ScrollView  {
      withAnimation {
        renderQuestion(appState: appState).font(.title).padding(.horizontal)
      }
      VStack { // a place to hang the nav title
        renderAnswers(appState: appState)
          .task{
            appState.sendChallengeAction(.onceOnlyVirtualyTapped(appState.currentTopicIndex))
          }// task
        Spacer()
        //SHOW Hint and Mark the Answers
        VStack {
          switch appState.showing {
          case .qanda:
            Button("hint") {
              hintpressed.toggle()
            }
          case .hint:
            EmptyView()
          case .answerWasCorrect:
            //            if let explanation = tc.explanation {
            //              RoundedTextViewNoGradient(text:explanation,backgroundColor: .white.opacity(0.15))
            //                .borderedStyleStrong( .green)
            //                .padding(.horizontal)
            //            } else {
            EmptyView() //}
            
          case .answerWasIncorrect:
            //            if let explanation = tc.explanation {
            //              RoundedTextViewNoGradient(text:explanation,backgroundColor: .white.opacity(0.15))
            //                .borderedStyleStrong( .red)
            //                .padding(.horizontal)
            //            } else {
            EmptyView()
          //}
          }
        }.frame(minHeight:200)
      } // place to hang
      .sheet(isPresented:$hintpressed) {
        HintBottomSheetView(hint: tc.hint)
          //.padding()
          .presentationDetents([.fraction(0.33)])
      }
    }//end of scrollview
  }
}

  func renderQuestion(appState:AppState) -> some View {
    let tc = appState.thisChallenge
      switch( appState.thisOutcome ){
      case .unplayed:
        return RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.blue  )
      case .playedCorrectly:
        return  RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.green  )
      case .playedIncorrectly:
        return  RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.red  )
      }
  }

  func renderAnswers(appState:AppState )-> some View {
    let tc = appState.thisChallenge
    func  renderAnswerButton(index:Int,action:ChallengeActions) -> some View {
        let beenPlayed = appState.thisOutcome != .unplayed
        return Button(action:{ appState.sendChallengeAction(action)}){
          withAnimation {
            RoundedTextViewNoGradient(text: tc.answers[index],
                                      backgroundColor: ((beenPlayed && tc.answers[index] == tc.correct) ?
                                                        correctColor : ((beenPlayed) ? incorrectColor : unplayedColor)))
          }
          .border(beenPlayed && tc.answers[index] == tc.correct ? .green:.clear,width:10)
          .padding(.horizontal)
        }
      }
    return  VStack {
      if tc.answers.count>0 {
          renderAnswerButton( index: 0,action:ChallengeActions.answer1ButtonTapped)
        }
      if tc.answers.count>1 {
          renderAnswerButton( index: 1,action:.answer2ButtonTapped)
        }
      if tc.answers.count>2 {
          renderAnswerButton( index: 2,action:.answer3ButtonTapped)
        }
      if tc.answers.count>3 {
          renderAnswerButton( index: 3,action:.answer4ButtonTapped)
        }
      if tc.answers.count>4 {
          renderAnswerButton( index: 4,action:.answer5ButtonTapped)
        }
    }
  }



#Preview {  EssentialChallengeView(store: Store(initialState:ChallengesFeature.State()){ChallengesFeature()},
                                   appState: SampleData.mock)
.environmentObject(  LogEntryManager.mock)
}
#Preview {
  EssentialChallengeView(store: Store(initialState:ChallengesFeature.State()){ChallengesFeature()},
                                      appState: SampleData.mock)
    .environmentObject(  LogEntryManager.mock)
 .preferredColorScheme(.dark)
}

