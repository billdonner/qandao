//
//  QandAScreenExt.swift
//  basic
//
//  Created by bill donner on 8/3/24.
//

import SwiftUI

extension QandAScreen {
  func questionAndAnswersSectionVue(answers:[String],geometry: GeometryProxy) -> some View {

    VStack(spacing: 15) {
      questionSectionVue(geometry: geometry)
      answerButtonsVue(answers: answers, geometry: geometry)
    }
    .padding(.horizontal)
    .padding(.bottom)
    
    // Invalid frame dimension (negative or non-finite).?
    .frame(maxWidth: max(0, geometry.size.width), maxHeight: max(0, geometry.size.height * 0.8))//make bigger when bottom buttons gone
  }
  
  func questionSectionVue(geometry: GeometryProxy) -> some View {
  //  let paddingWidth = geometry.size.width * 0.1
   // let contentWidth = geometry.size.width - paddingWidth
    let ch = chmgr.everyChallenge[gs.board[row][col]]
    let topicColor =   gs.colorForTopic(ch.topic).0
    
    return ZStack {
      RoundedRectangle(cornerRadius: 10).fill(topicColor.opacity(1.0))
      // Invalid frame dimension (negative or non-finite).?
      
      VStack(spacing:10) {
        buttonRow
          .foregroundColor(foregroundColorFrom( backgroundColor: topicColor ))
          .padding()
          //.frame(width: max(0,contentWidth*0.9),height:buttSize)
          .debugBorder()
   Spacer()
        Text(ch.question)
          .font(.title3)
          .padding()//([.top,.horizontal])
         // .frame(width: max(0,contentWidth), height:max(0,  geometry.size.height * 0.3))//0.2
          .lineLimit(8)
          .fixedSize(horizontal: false, vertical: true)
          .foregroundColor(foregroundColorFrom( backgroundColor: topicColor ))
          .debugBorder()
        Spacer()
      }
    }.debugBorder()
   // .frame(width: max(0,contentWidth), height:max(0,  geometry.size.height * 0.33))
  }
  
  var buttonRow: some View {
    HStack(spacing:10) {
      HStack(spacing:5){
        gimmeeButton
        thumbsUpButton
        thumbsDownButton
      }
      Spacer()
      if freeportButtons {
        markCorrectButton
        markIncorrectButton
        infoButton
      }
      hintButton
    }
  }
  
  func answerButtonsVue(answers:[String] ,geometry: GeometryProxy) -> some View {
 
      let paddingWidth = geometry.size.width * 0.1
      let contentWidth = geometry.size.width - paddingWidth
      
      if answers.count >= 5 {
          let buttonWidth = (contentWidth / 2.5) - 10 // Adjust width to fit 2.5 buttons
          let buttonHeight = buttonWidth * 1.57 // 57% higher than the four-answer case
          return AnyView(
              VStack {
                  ScrollView(.horizontal) {
                      HStack(spacing: 15) {
                          ForEach(Array(answers.enumerated()), id: \.offset) { index, answer in
                              answerButtonVue(answer: answer, row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight, taller: true)
                          }
                      }
                      .padding(.horizontal)
                      .disabled(questionedWasAnswered)  // Disable all answer buttons after an answer is given
                  }
                  Image(systemName: "arrow.right")
                      .foregroundColor(.gray)
                      .padding(.top, 10)
              }
              .frame(width: contentWidth) // Set width of the scrolling area
          )
      } else if answers.count == 3 {
          return AnyView(
              VStack(spacing: 15) {
                  answerButtonVue(answer: answers[0], row: row, col: col, buttonWidth: contentWidth / 2, buttonHeight: contentWidth / 2)
                  HStack {
                      answerButtonVue(answer: answers[1], row: row, col: col, buttonWidth: contentWidth / 2.5, buttonHeight: contentWidth / 2.5)
                      answerButtonVue(answer: answers[2], row: row, col: col, buttonWidth: contentWidth / 2.5, buttonHeight: contentWidth / 2.5)
                  }
              }
              .padding(.horizontal)
              .disabled(questionedWasAnswered)  // Disable all answer buttons after an answer is given
          )
      } else {
          let buttonWidth = min(geometry.size.width / 3 - 20, 100) * 1.5
          let buttonHeight = buttonWidth * 0.8 // Adjust height to fit more lines
          return AnyView(
              VStack(spacing: 15) {
                  HStack {
                      answerButtonVue(answer: answers[0], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
                      answerButtonVue(answer: answers[1], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
                  }
                  HStack {
                      answerButtonVue(answer: answers[2], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
                      answerButtonVue(answer: answers[3], row: row, col: col, buttonWidth: buttonWidth, buttonHeight: buttonHeight)
                  }
              }
              .padding(.horizontal)
              .disabled(questionedWasAnswered)  // Disable all answer buttons after an answer is given
          )
      }
  }
  func answerButtonVue(answer: String,row:Int,col:Int, buttonWidth: CGFloat, buttonHeight: CGFloat, taller: Bool = false) -> some View {
    func ff()->some View {
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      if answerGiven {
        if answer == selectedAnswer {
          return answerCorrect == true ? Color.green : Color.red
        } else if answerCorrect == true {
          return Color.red
        } else if showCorrectAnswer && answer == ch.correct {
          return Color.green
        }  else {
          return Color.blue
        }
      }
      return Color.blue
    }
    return  Button(action: {
      handleAnswerSelection(answer: answer,row:row,col:col)
    })
    {
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      Text(answer)
        .font(.body)
        .foregroundColor(.white)
        .padding()
      .frame(width:max(20, buttonWidth*0.9), height: max(20,buttonHeight*0.9)) // clamp up
        .background(.blue
        )
        .cornerRadius(5)  // Make the buttons rounded rectangles
        .minimumScaleFactor(0.5)  // Adjust font size to fit
        .lineLimit(8)
        //.rotationEffect(showCorrectAnswer && answer == ch.correct ? .degrees(360) : .degrees(0))
        .overlay(
          RoundedRectangle(cornerRadius: 5)  // Match the corner radius
            .stroke(showBorders && answer == selectedAnswer && !answerCorrect ? Color.red : showBorders && answer == ch.correct && answerCorrect == false ? Color.green : Color.clear, lineWidth: 5)
        )
        //.animation(.easeInOut(duration: showCorrectAnswer ? 1.0 : 0.5), value: showCorrectAnswer)
        .animation(.easeInOut(duration: answerGiven ? 1.0 : 0.5), value: animateBackToBlue)
        //.animation(.easeInOut(duration: 0.5), value: showBorders)
    }
  }
} 
extension QandAScreen {
  
func handleDismissal(toRoot:Bool) {
    if toRoot {
      withAnimation(.easeInOut(duration: 0.75)) { // Slower dismissal
        isPresentingDetailView = false
        dismiss()
      }
    } else {
      answerGiven = false //showAnsweredAlert = false
      showHint=false //  showHintAlert = false
    }
  }
  
  func toggleHint() {
    if chmgr.everyChallenge[gs.board[row][col]]
      .hint.count > 1  { // guard against short hints
      showHint.toggle()
    }
  }
  
  func handleGimmee() {

    killTimer = true
     
    let idx = gs.board[row][col]
    let result = chmgr.replaceChallenge(at:idx)
    switch result {
    case .success(let index):
      gs.gimmees -= 1
      gs.board[row][col] = index[0]
      gs.cellstate[row][col] = .unplayed
      gs.replaced[row][col] += [idx] // keep track of what we are replacing
      gs.replacedcount += 1
      print("Gimmee realloation successful \(index)")
      
    case .error(let error):
      print("Couldn't handle gimmee reallocation \(error)")
    }
    gs.saveGameState()
    dismiss()
  }
  
  func handlePass() {
    killTimer=true
    dismiss()
  }
  
  func answeredCorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark correct before")
    assert(gs.checkVsChaMan(chmgr: chmgr))
    answerCorrect = true
    answerGiven = true
    showBorders = true
    gs.movenumber += 1
    gs.moveindex[row][col] = gs.movenumber
    gs.cellstate[row][col] = .playedCorrectly
    gs.rightcount += 1
    chmgr.bumpRightcount(topic: ch.topic)
    chmgr.stati[gs.board[row][col]] = .playedCorrectly  // ****
    chmgr.ansinfo[ch.id]  =
    AnsweredInfo(id: ch.id, answer: answered, outcome:.playedCorrectly,
                 timestamp: Date(), timetoanswer:elapsedTime, gamenumber: gs.gamenumber, movenumber: gs.movenumber,row:row,col:col)
    killTimer=true
    gs.saveGameState()
    chmgr.save()
    chmgr.checkAllTopicConsistency("mark correct after")
  }
  func answeredIncorrectly(_ ch:Challenge,row:Int,col:Int,answered:String) {
    chmgr.checkAllTopicConsistency("mark incorrect before")
    assert(gs.checkVsChaMan(chmgr: chmgr))
    answerCorrect = false
    answerGiven = true
    showCorrectAnswer = false
    showBorders = true
    gs.movenumber += 1
    gs.moveindex[row][col] = gs.movenumber
    gs.cellstate[row][col] = .playedIncorrectly
    gs.wrongcount += 1
    chmgr.bumpWrongcount(topic: ch.topic)
    chmgr.stati[gs.board[row][col]] = .playedIncorrectly  // ****
    chmgr.ansinfo[ch.id]  =
    AnsweredInfo(id: ch.id, answer: answered, outcome:.playedIncorrectly,
                 timestamp: Date(), timetoanswer: elapsedTime, gamenumber: gs.gamenumber, movenumber: gs.movenumber,row:row,col:col)

    killTimer=true
    chmgr.save()
    gs.saveGameState()
    chmgr.checkAllTopicConsistency("mark incorrect after")
  }
  func handleAnswerSelection(answer: String,row:Int,col:Int) {
    if !questionedWasAnswered { // only allow one answer
      let ch = chmgr.everyChallenge[gs.board[row][col]]
      selectedAnswer = answer
      answerCorrect = (answer == ch.correct)
      answerGiven = true
      
      switch answerCorrect {
      case true: answeredCorrectly(ch,row:row,col:col,answered:answer)
      case false: answeredIncorrectly(ch,row:row,col:col,answered: answer)
      }
      questionedWasAnswered = true
    } else {
      print("dubl tap \(answer)")
    }
  }
}
