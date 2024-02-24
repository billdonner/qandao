//
//  AppState.swift
//  qanda
//
//  Created by bill donner on 8/1/23.
//

import Foundation
import q20kshare


@Observable final class AppState : ObservableObject  {
 required init( gameDatum: [GameData]) {
    self.gameDatum = gameDatum
  }
  var remoteContentID = ""
  var scoresByTopic:[String:TopicGroupData] = [:]
  var currentTopicIndex : Int = 0
  var showing:ShowingState = .qanda 
  
  // gameDatum is never persisted
  @ObservationIgnored
  var gameDatum:[GameData]=[]

  
  func reloadStuff (_ t:AppState,gd:[GameData]) {
    self.gameDatum =  gd
    self.showing = t.showing
    self.scoresByTopic = t.scoresByTopic
    self.remoteContentID = t.remoteContentID
    self.currentTopicIndex = t.currentTopicIndex
    self.clearAllScores()
  }
  
  // the init entry point is only called from reload or init, and really only with no gamedata []
  
  init( currentTopic: String = "",
        remoteContentID : String = "",
        isLoading: Bool = false,
        scoresByTopic: [String : TopicGroupData] = [:],
        showing: ShowingState = .qanda,
        isTimerRunning: Bool = false,
        timerCount: Int = 0 ,
        gameDatum:[GameData])
  
  {
    self.scoresByTopic = scoresByTopic
    self.remoteContentID = remoteContentID
    self.showing = showing
    self.currentTopicIndex = indexForTopic(currentTopic) ?? 0// fix this
    self.gameDatum = gameDatum
    self.clearAllScores()
  }
  // this is the main restoral point from the outside app
  // it is only caled by OuterShellView in an async .task closure
  
  
static func reloadOrInit() -> AppState {
   let x = PersistentData.restoreAS()
    if let x = x {
      return x
    }
  // if that fails just init the world from scratch
    return AppState.init(gameDatum:[])
  }
  
  
  // computed properties
  
  var currentTopic : String {
    //gameDatum might not yet have data so return ""
    if gameDatum.count > 0 {
      return gameDatum[currentTopicIndex].topic
    }
    return "NOTYET"
  }
  
  var topics : [String] {
    scoresByTopic.map {$0.1.topic}
  }
  var topicScore : Int {
    if let sbt = scoresByTopic[currentTopic] {
      return sbt.outcomes.reduce(0) { $0 + ($1 == .playedCorrectly ? 1:0)}
    }
    return 0
  }
  var grandScore : Int {
    scoresByTopic.reduce(0) { $0 + $1.1.playedCorrectly}
  }
  var grandTime : Double {
    scoresByTopic.reduce(0.0) { $0 + $1.1.elapsedTime}
  }
  var questionNumber: Int {
    scoresByTopic[currentTopic]?.questionNumber ?? 0//-1
  }
  var questionMax: Int {
    scoresByTopic[currentTopic]?.questionMax ?? 0//-1
  }
  var thisChallenge: Challenge {
    if gameDatum.count > 0 {
      return gameDatum[currentTopicIndex].challenges[questionNumber]
    } else {
      return Challenge.mock
    }
  }
  var thisOutcome: ChallengeOutcomes {
    scoresByTopic[currentTopic]?.outcomes[questionNumber] ?? .unplayed
  }
  
  func allAnswered () -> Bool {
    var allans = true
    
    func isAnswered(_ g:GameData) -> Bool {
      guard let sbt = scoresByTopic[g.topic] else { return false}
      return g.challenges.count <= sbt.highWaterMark
    }
    
    for g in gameDatum {
      if !isAnswered(g) {
        allans = false
        break
      }
    }
    return allans
  }
  

  /// Theses are called from the views
  
  
  @discardableResult
  func sendTopicAction(_ action:TopicsActions) -> Effect {
    //let state = self
    switch action {
    case .topicRowTapped(let idx):
      self.currentTopicIndex = idx
    //  self.timerCount = 0
  //    self.isTimerRunning = false
      let td:TopicGroupData? = self.scoresByTopic[gameDatum[idx].topic]
      if let td = td {
        self.scoresByTopic[gameDatum[idx].topic] = TopicGroupData(topic: td.topic, outcomes: td.outcomes, time:td.time, questionNumber: td.questionNumber)
      }
      return .none
      
    case .reloadButtonTapped:
      break
    }
    return .none
  }
  
  @discardableResult
  func sendChallengeAction(_ action:ChallengeActions) -> Effect {
    
    switch action {
    case .cancelButtonTapped:
      return .none  
    case .nextButtonTapped:
      if self.questionNumber < gameDatum[self.currentTopicIndex].challenges.count - 1 {
        self.setQuestionNumber(self.questionNumber + 1 )
      //  self.timerCount = 0
        self.showing = .qanda
        self.save() // save all changes
        return .startTimer
      }
      
    case .previousButtonTapped:
      if self.questionNumber > 0 {
        self.setQuestionNumber(self.questionNumber - 1 )
      //  self.timerCount = 0
        self.showing = .qanda
        self.save() // save all changes
        return .startTimer
      }
    case .answer1ButtonTapped:
      answerButtonTapped(0)
      return .cancelTimer
    case .answer2ButtonTapped:
      answerButtonTapped(1)
      return .cancelTimer
    case .answer3ButtonTapped:
      answerButtonTapped(2)
      return .cancelTimer
    case .answer4ButtonTapped:
      answerButtonTapped(3)
      return .cancelTimer
    case .answer5ButtonTapped:
      answerButtonTapped(4)
      return .cancelTimer
    case .hintButtonTapped:
      if self.showing == .qanda
      {self.showing = .hint} // dont stop timer
    case .timeTick:
    //  self.timerCount += 1
      return .none
    case .virtualTimerButtonTapped:
      return .startTimer
    case .onceOnlyVirtualyTapped(let topicIndex):
      self.currentTopicIndex = topicIndex
     // self.timerCount = 0
      self.showing = .qanda
      return .startTimer
    case .infoButtonTapped:
      return .none
    case .thumbsUpButtonTapped:
      return .none
    case .thumbsDownButtonTapped:
      return .none
    }
    
    return .none
  }
  
 private  func answerButtonTapped( _ idx:Int) {
    let thisChallenge = gameDatum[self.currentTopicIndex].challenges[self.questionNumber]
    let t =  thisChallenge.correct == thisChallenge.answers[idx]
    var outcomes = self.scoresByTopic[self.currentTopic]?.outcomes ?? Array(repeating:.unplayed,count:gameDatum[self.currentTopicIndex].challenges.count)
    let times = self.scoresByTopic[self.currentTopic]?.time ?? Array(repeating:0.0,count:gameDatum[self.currentTopicIndex].challenges.count)
    let oc =  t ? ChallengeOutcomes.playedCorrectly : .playedIncorrectly
    // if unplayed
    if outcomes [self.questionNumber] == ChallengeOutcomes.unplayed {
      // adjust the outcome
      outcomes [self.questionNumber] = oc
      // adjust the time
      
      self.scoresByTopic[self.currentTopic] =
      TopicGroupData(topic:self.currentTopic,outcomes: outcomes, time: times, questionNumber: self.questionNumber)
     // self.addTime(self.currentTopic, timeInSecs: Double(self.timerCount)/10.0)// get the time
      
    }
    self.showing = t ? .answerWasCorrect : .answerWasIncorrect
   // self.isTimerRunning = false
    self.save() // save all changes
  }
  
  
  
  func indexForTopic(_ topic:String)  -> Int? {
    var idx = 0
  // print("*** **** \(gameDatum.count) ***")
    for g in gameDatum {
      if g.topic == topic { return idx}
      else { idx += 1 }
    }
    return nil
  }
  func addTime (_ topic:String,timeInSecs:TimeInterval) {
     self.scoresByTopic[topic]?.addToLatestTime(x: timeInSecs )
   }

// save app state
  func save() {
    PersistentData(ap:self).saveInternalCodable()  // save only selected bits
  }
  ///// these are all private here
    private   func setQuestionNumber(_ num:Int) {
      scoresByTopic[currentTopic]?.setQuestionNumber(num)
    }
  private func dump() {
    print("+++++++++++++++++++")
    for x in scoresByTopic
    {
      print (x.0,terminator:" ")
      print (x.1.outcomes.reduce(0) { $0 + ($1 == ChallengeOutcomes.playedCorrectly ? 1:0)})
    }
    print("grandScore:", grandScore)
    print("currentTopicIndex:", currentTopicIndex)
    print("currentTopic:", currentTopic)
    print("questionNumber:", questionNumber)
    print("questionMax:", questionMax)
    print("thisChallenge.question:", thisChallenge.question)
    print("thisOutcome:",thisOutcome)
    print("-------------------")
  }
  
 private func idxForTopic(_ t:String) -> Int {
    let tp = topics
    for idx in 0 ..< tp.count {
      if t == tp[idx] { return idx}
    }
    fatalError("Cant get current topic index")
    // return -1
  }

  private func clearAllScores() {
    self.scoresByTopic = [:]
    for gd in  gameDatum {
      self.scoresByTopic[gd.topic]=TopicGroupData(topic:gd.topic,
                                             outcomes:Array(repeating: ChallengeOutcomes.unplayed,
                                                            count: gd.challenges.count),
                                             time: Array(repeating: 0.0,
                                                         count: gd.challenges.count),
                                             questionNumber: 0)
    }
  }
  
  
  
  
}//
