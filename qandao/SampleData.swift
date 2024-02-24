//
//  Data.swift
//  stupido
//
//  Created by bill donner on 7/12/23.
//

import Foundation
import q20kshare

struct SampleData {
  
  static let topicName1 =  "Criminals"
  static let topicBlurb1 = "Mock Topic One"
  static let topic1 = Topic(name:topicName1,subject:topicBlurb1,pic:"lasso",notes:"Extended Notes Here",subtopics:[])
  static let topicData1 = TopicGroup(description: "MockSnarky", version: "99.9.9", author: "xyz", date: "15 Dec 2023", topics: [topic1])
  static let outcomes1:[ ChallengeOutcomes] = [.unplayed,.playedCorrectly]
  static let times1:[Double] = [1.21,2.33]
  
  static let topicName2 =  "Crooked Politicians"
  static let topicBlurb2 = "Mock Topic Two"
  static let topic2 = Topic(name:topicName2,subject:topicBlurb2,pic:"leaf",notes:"Extended Notes Here",subtopics:[])
  static let topicData2 = TopicGroup(description: "Mockity", version: "99.9.9", author: "xyz", date: "25 Dec 2023", topics: [topic2])
  static let outcomes2:[ ChallengeOutcomes] = [.unplayed,.playedCorrectly]
  static let times2:[Double] = [2.22,2.33]
  
  
  static let topicName3 =  "Planes"
  static let topicBlurb3 = "Mock Topic Three"
  static let topic3 = Topic(name:topicName3,subject:topicBlurb3,pic:"leaf",notes:"Extended Notes Here",subtopics:[])
  static let topicData3 = TopicGroup(description: "Mockity", version: "99.9.9", author: "xyz", date: "25 Dec 2023", topics: [topic3])
  static let outcomes3 : [ ChallengeOutcomes] = [.unplayed,.playedCorrectly]
  static let times3:[Double] = [2.22,2.33]
  
  
  static let topicName4 =  "People"
  static let topicBlurb4 = "Mock Topic Four"
  static let topic4 = Topic(name:topicName4,subject:topicBlurb4,pic:"leaf",notes:"Extended Notes Here",subtopics:[])
  static let topicData4 = TopicGroup(description: "Mockity", version: "99.9.9", author: "xyz", date: "25 Dec 2023", topics: [topic4])
  static let outcomes4:[ ChallengeOutcomes] = [.unplayed,.playedCorrectly]
  static let times4:[Double] = [2.22,2.33]
  
  
  static let topicName5 =  "Jokes"
  static let topicBlurb5 = "Mock Topic Five"
  static let topic5 = Topic(name:topicName5,subject:topicBlurb5,pic:"leaf",notes:"Extended Notes Here",subtopics:[])
  static let topicData5 = TopicGroup(description: "Mockity", version: "99.9.9", author: "xyz", date: "25 Dec 2023", topics: [topic5])
  static let outcomes5: [ ChallengeOutcomes] = [.unplayed,.playedCorrectly]
  static let times5:[Double] = [2.22,2.33]
  
  
  
  
  static let scoresByTopic =  [ topicName1 : TopicGroupData(topic:topicName1,outcomes: outcomes1,time:times1, questionNumber: 1),
                                topicName2 : TopicGroupData(topic:topicName2,outcomes: outcomes2,time:times2, questionNumber: 1),
                                topicName3 : TopicGroupData(topic:topicName3,outcomes: outcomes3,time:times3, questionNumber: 1),
                                topicName4 : TopicGroupData(topic:topicName4,outcomes: outcomes4,time:times4, questionNumber: 1),
                                topicName5 : TopicGroupData(topic:topicName5,outcomes: outcomes5,time:times5, questionNumber: 1),
  ]
  
  
  static let prompt11 = "Make up some silly questions for me"
  static let challenge11 = Challenge(question: "Why is the sky blue?", topic: topicName1 , hint: "It's not green", answers: ["good","bad","ugly"], correct: "good", id:"aa849-2339-23bcd", date: Date(), aisource:"billbotv.2")
  
  static let prompt12 = "Make up some difficult questions for me"
  static let challenge12 = Challenge(question: "Why is water blue blue blue blue blue blue blue blue blue blue blue blue blue green green green green green green green green green green green green green?", topic: topicName1, hint: "It's not red", answers: ["red","yellow","green"], correct: "yellow",id:"aa777-2339-23bcd", date: Date(), aisource:"billbotv.2")
  
  static let challenges1 = [challenge11,challenge12]
  
  
  static let prompt21 = "Make up some fun questions for me"
  static let challenge21 = Challenge(question: "Why is the sky blue?", topic: topicName2 , hint: "It's not green", answers: ["good","bad","ugly"], correct: "good", id:"aa849-2339-23bcd", date: Date(), aisource:"billbotv.2")
  
  static let prompt22 = "Make up some hard questions for me"
  static let challenge22 = Challenge(question: "Why is water blue blue blue blue blue blue blue blue blue blue blue blue blue green green green green green green green green green green green green green?", topic: topicName2, hint: "It's not red", answers: ["red","yellow","green"], correct: "yellow",id:"aa777-2339-23bcd", date: Date(), aisource:"billbotv.2")
  
  static let challenges2 = [challenge21,challenge22]
  
  static let prompt31 = "Make up some fun questions for me"
  static let challenge31 = Challenge(question: "Why is the sky blue?", topic: topicName3 , hint: "It's not green", answers: ["good","bad","ugly"], correct: "good", id:"aa849-3339-33bcd", date: Date(), aisource:"billbotv.3")
  
  static let prompt32 = "Make up some hard questions for me"
  static let challenge32 = Challenge(question: "Why is water blue blue blue blue blue blue blue blue blue blue blue blue blue green green green green green green green green green green green green green?", topic: topicName3, hint: "It's not red", answers: ["red","yellow","green"], correct: "yellow",id:"aa777-3339-33bcd", date: Date(), aisource:"billbotv.3")
  
  static let challenges3 = [challenge31,challenge32]
  
  
  static let prompt41 = "Make up some fun questions for me"
  static let challenge41 = Challenge(question: "Why is the sky blue?", topic: topicName4 , hint: "It's not green", answers: ["good","bad","ugly"], correct: "good", id:"aa849-4449-44bcd", date: Date(), aisource:"billbotv.4")
  
  static let prompt42 = "Make up some hard questions for me"
  static let challenge42 = Challenge(question: "Why is water blue blue blue blue blue blue blue blue blue blue blue blue blue green green green green green green green green green green green green green?", topic: topicName4, hint: "It's not red", answers: ["red","yellow","green"], correct: "yellow",id:"aa777-4449-44bcd", date: Date(), aisource:"billbotv.4")
  
  static let challenges4 = [challenge41,challenge42]
  
  static let prompt51 = "Make up some fun questions for me"
  static let challenge51 = Challenge(question: "Why is the sky blue?", topic: topicName5 , hint: "It's not green", answers: ["good","bad","ugly"], correct: "good", id:"aa859-5559-55bcd", date: Date(), aisource:"billbotv.5")
  
  static let prompt52 = "Make up some hard questions for me"
  static let challenge52 = Challenge(question: "Why is water blue blue blue blue blue blue blue blue blue blue blue blue blue green green green green green green green green green green green green green?", topic: topicName5, hint: "It's not red", answers: ["red","yellow","green"], correct: "yellow",id:"aa777-5559-55bcd", date: Date(), aisource:"billbotv.5")
  
  static let challenges5 = [challenge51,challenge52]
  
  
  static let gd = [GameData(topic: topicName1, challenges: challenges1),
                   GameData(topic: topicName2, challenges: challenges2),
                   GameData(topic: topicName3, challenges: challenges3),
                   GameData(topic: topicName4, challenges: challenges4),
                   GameData(topic: topicName5, challenges: challenges5),]
  
  static let mock = AppState(
    currentTopic:topicName1,
    isLoading: true,
    scoresByTopic: scoresByTopic,
    showing:.qanda,
    isTimerRunning: false,
    timerCount: 0,
    gameDatum:gd )
  
  
  static func makeMock()  -> AppState? {
    
    func decodeJSONFile<T: Codable>(fileName: String, type: T.Type) -> T? {
      guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        let _ =     print("File \(fileName) not found in main bundle.")
        return nil
      }
      do {
        let data = try Data(contentsOf: fileUrl)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
      } catch {
        let _ =     print("Error decoding JSON file: \(error)")
        return nil
      }
    }
    
    
    if  let playData = decodeJSONFile(fileName: "readyforios2", type: PlayData.self) {
      // convert playData to appstate
      return    AppState( currentTopic:playData.gameDatum[0].topic,
                          isLoading: true,
                          scoresByTopic: [:],
                          showing:.qanda,
                          isTimerRunning: false,
                          timerCount: 0,
                          gameDatum:playData.gameDatum)
    }   else {
      let _ = print("Mock Could not restore playData")
    }
    return nil
  }
}
