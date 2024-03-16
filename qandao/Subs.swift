//
//  Subs.swift
//  tcaqa
//
//  Created by bill donner on 7/12/23.
//

import SwiftUI
import q20kshare
enum ShowingState : Codable,Equatable {
  case qanda
  case hint
  case answerWasCorrect
  case answerWasIncorrect
}

enum ChallengeOutcomes : Codable,Equatable{
  case unplayed
  case playedCorrectly
  case playedIncorrectly
}

struct TopicGroupData : Codable,Equatable {
  let topic:String
  let outcomes:[ChallengeOutcomes]
  var time:[TimeInterval]
  var questionNumber:Int
  
  var questionMax: Int {
    return outcomes.count
  }
  
  var highWaterMark : Int {
    outcomes.reduce(0){x,y in x + ((y != .unplayed) ? 1 : 0)}
  }
  var playedCorrectly : Int {
    outcomes.reduce(0){x,y in x + ((y == .playedCorrectly) ? 1 : 0)}
  }
  var playedInCorrectly : Int {
    outcomes.reduce(0){x,y in x + ((y == .playedIncorrectly) ? 1 : 0)}
  }
  var elapsedTime : TimeInterval {
    time.reduce(0.0) {x,y in x + y}
  }
  
  mutating func addToLatestTime(x:TimeInterval) {
    self.time[questionNumber] += x
  }
  
  mutating func setQuestionNumber (_ num:Int) {
    questionNumber = num
  }
  
}// end of topicdata


enum Effect:Equatable {
  case none
  case cancelTimer
  case startTimer
}
enum TopicsActions: Equatable {
  case topicRowTapped(Int)
  case reloadButtonTapped
  //case reloadButtonResponse([GameData])
}
enum ChallengeActions: Equatable {
  case cancelButtonTapped
  case nextButtonTapped
  case previousButtonTapped
  case answer1ButtonTapped
  case answer2ButtonTapped
  case answer3ButtonTapped
  case answer4ButtonTapped
  case answer5ButtonTapped
  case hintButtonTapped
  case infoButtonTapped
  case thumbsUpButtonTapped
  case thumbsDownButtonTapped
  case timeTick
  case virtualTimerButtonTapped
  case onceOnlyVirtualyTapped(Int)
}

enum DifficultyLevels: Int {
  case easy,medium,hard
  
  static  func string(for:Self) -> String {
    switch `for` {
    case .easy:
      return "easy"
    case .medium:
      return "medium"
    case .hard:
      return "hard"
    }
  }
}
public enum GameDataSource : Int {
//
//  case localFull // keep first for easiest testing
  case gameDataSource1
  case gameDataSource2
  case gameDataSource3
  
  static  func string(for:Self) -> String {
    switch `for` {
    case .gameDataSource1:
      return PRIMARY_REMOTE
    case .gameDataSource2:
      return SECONDARY_REMOTE
    case .gameDataSource3:
      return TERTIARY_REMOTE
    }
  }
}

struct TopicState {
  var currentQuestionIndex: Int = 0
  var showingAnswer : Bool = false
  var score: Int = 0
}

enum TopicSheetActions {
  case rowDetailsTapped(Int)
  case longPressTapped(Int)
  case settingsTapped
}
enum ChallengeSheetActions {
  case thumbsDownTapped
  case thumbsUpTapped
  case infoTapped
  case topicInfoTapped
  case settingsTapped
 // case hintTapped
}
struct ChallengeSheetChoices:Identifiable {
  internal init(choice: ChallengeSheetActions) {
    self.choice = choice
  }
  
  let id = UUID()
  let choice:ChallengeSheetActions
}
struct TopicSheetChoices:Identifiable {
  internal init(choice: TopicSheetActions,  index: Int?) {
    self.choice = choice
    self.index = index
  }
  
  let id = UUID()
  let choice:TopicSheetActions
  let index: Int?
}
//"CFBundleVersion"
extension UIApplication {
  static var appVersion: String? {
    let x =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let y =  Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    guard let x=x, let y=y else {
      return nil }
    return x + "." + y
  }
  static var appName: String? {
    return  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
  }
}
struct  TintModifier: ViewModifier {
    @State private var shouldApplyTint = Bool.random()
    func body(content: Content) -> some View {
      content //.background(shouldApplyTint ? Color.clear : Color.gray)
          .opacity(shouldApplyTint ? 1.0:0.5)
    }
}

extension View {
    func applyTintWithProbability() -> some View {
        self.modifier(TintModifier())
    }
}

// Print JSON to Console
func printJSon(_ g:GameData) {
  let encoder = JSONEncoder()
  encoder.outputFormatting = .prettyPrinted
  if let jsonData = try? encoder.encode(g) {
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print(jsonString)
  }
  
  
}
enum AppInfoProvider {
    static func appBundleID(in bundle: Bundle = .main) -> String {
        guard let x = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            fatalError("CFBundleIdentifier missing from info dictionary")
        }
        return x
    }
}

struct ForEachWithIndex<
  Data: RandomAccessCollection,
  Content: View
>: View where Data.Element: Identifiable, Data.Element: Hashable {
  let data: Data
  @ViewBuilder let content: (Data.Index, Data.Element) -> Content
  var body: some View {
    ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
      content(index, element)
    }
  }
}

func fixTopicName(_ name:String)->String {
  name.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "-", with: "'")
}

func timeStringFor(seconds : Int) -> String
{
  formatter.allowedUnits = [.second, .minute, .hour]
  formatter.zeroFormattingBehavior = .pad
  let output = formatter.string(from: TimeInterval(seconds))!
  let x =  seconds < 3600 ? String(output[output.firstIndex(of: ":")!..<output.endIndex]) : output
  return String(x.trimmingCharacters(in: .whitespaces).dropFirst())
}
func decodeStringFromJSON(encodedString: String) -> String {
  let withoutQuotes = encodedString.replacingOccurrences(of: "\"", with: "")
  let decodedString = withoutQuotes.replacingOccurrences(of: "\\\"", with: "\"")
  return decodedString
}


struct Bordered: ViewModifier {
  let opacity: Double
  let color:Color
    func body(content: Content) -> some View {
        content
        .padding()
        .background(color.opacity(opacity))
        .cornerRadius(10)
    }
}
extension View {
  func borderedStyle(_ color:Color = .clear)->some View {
    modifier(Bordered(opacity: 0.04,color:color))
  }
  func borderedStyleStrong(_ color:Color = .clear)->some View {
    modifier(Bordered(opacity: 0.1,color:color))
  }
}

// from chatGPT
enum CustomError: Error {
    case invalidDigits
  case couldNotRestore
}

func convertToFixedColumns(_ val: Int, digits: Int, fillCharacter: Character = "0") throws -> String {
    let numberString = String(val)
    
    // If the number of digits in the input value is already equal or greater than the required digits,
    // then return the string representation of the input value as is
    guard numberString.count <= digits else {
        throw CustomError.invalidDigits
    }
    
    // If the number of digits in the input value is less than the required digits,
    // add leading fill characters to make it the required length
    let leadingFillCharactersToAdd = digits - numberString.count
    let leadingFillCharacters = String(repeating: fillCharacter, count: leadingFillCharactersToAdd)
    
    return leadingFillCharacters + numberString
}

struct  StatsTextView:View  {
  let appState:AppState
  var body: some View {
    let z = 10//appState.timerCount // tenths
    let x = z/10
    let p = Int(appState.grandTime) + x
    // let y = z % 10
    var ss = ""
    var tts = ""
    do {
      ss = try "\(convertToFixedColumns( x,digits:3,fillCharacter: " "))/\(convertToFixedColumns( p,digits:3,fillCharacter: " ")) Secs"
      
      tts = try "Score \(convertToFixedColumns( appState.topicScore,digits:2))/\(convertToFixedColumns(appState.grandScore,digits:3))"
    }
    catch {
    }
    return HStack  {
      Text(ss)
      Spacer()
      Text(tts)
    }.font(.headline).monospaced()
  }
}

enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
       // # 1
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           //   # 2
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            //  # 3
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           //   # 4
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }

        return iconFileName
    }
}
enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let x = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ,
              let y =  bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("CFBundlexxx missing from info dictionary")
        }
      
        return x + "." + y
    }
}
enum AppNameProvider {
    static func appName(in bundle: Bundle = .main) -> String {
        guard let x = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            fatalError("CFBundleName missing from info dictionary")
        }
      
        return x
    }
}
struct AppVersionInformationView: View {
   // # 1
  let name:String
    let versionString: String
    let appIcon: String

    var body: some View {
        //# 1
        HStack(alignment: .center, spacing: 12) {
          // # 2
           VStack(alignment: .leading) {
               Text("App")
                   .bold()
               Text("\(name)")
           }
           .font(.caption)
           .foregroundColor(.primary)
            //# 3
            // App icons can only be retrieved as named `UIImage`s
            // https://stackoverflow.com/a/62064533/17421764
            if let image = UIImage(named: appIcon) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
           // # 4
            VStack(alignment: .leading) {
                Text("Version")
                    .bold()
                Text("v\(versionString)")
            }
            .font(.caption)
            .foregroundColor(.primary)
        }
        //# 5
        .fixedSize()
        //# 6
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("App version \(versionString)")
    }
}


struct AppVersionInformationView_Previews: PreviewProvider {
  static var previews: some View {
    AppVersionInformationView(
        name:AppNameProvider.appName(),
        versionString: AppVersionProvider.appVersion(),
        appIcon: AppIconProvider.appIcon()
    )
  }
}


extension Challenge {
  
  static let mock = Challenge(question:Array(repeating: "Q", count: 200).joined(),topic:"NOTYET",
                          hint:"Can we overfill this?\n\n probably not in the normal course of things",answers:["Afdg;lsfg;lsgf;ls;lfsg;lsfg;lsfg;lsf;lsgf;lfsg;lsfg;lfsg;lsfdg;lfgds;lfgds;lfsg;lfgs;lsfg;dlfgds;l;fgsdlfdgs;lfsg;lfdsg;kxxxxxxxsdf/.asdff/.afds/.sfdg/.sfdg/.sfg/.sg/.123123123","afd;ladf;ladf;ladsf;lasdf;lasdf;lafds;laf;ladsf;asdf;lafsd;lfdsa;lfdsa;lfdsa;lfdsa;ldsaf;ldfsa;ldfsa;lsdfa;ldfsa;lfads;lfdsa;lfdsa;lfdsa;ladfs;ldfs;lfdasl;dafs;ldasf;ldsafl;dafsl;dfas;lfdas;lafdsl;adfs;ldfas;ldfsa;lfdsa"],correct:"A",id:"99999999",date:Date(),aisource:"buggerz.ai")
}

/**
func shuffleGameDatum( _ x: [GameData]) -> [GameData] {
  // shuffle within the sorted topics
  let sortedBySubject = x.sorted {$0.topic < $1.topic}
  return sortedBySubject.map { sort in GameData (topic: sort.topic, challenges: sort.challenges.shuffled() ,
                                                 pic: sort.pic ?? nil) }
}

struct RoundedTextView2: View {
    var text: String
    var backgroundColor: Color
    var gradientColor: Color
    var body: some View {
        VStack {
          let font = fontForStringSize(getStringClass(text.count))
            Spacer()
            .font(font)
                .padding()
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [gradientColor.opacity(0.1), backgroundColor.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(radius: 5)
                )
            Spacer()
        }
    }
}

struct RoundedTextViewNoGradient2: View {
    var text: String
    var backgroundColor: Color
    
    var body: some View {
        VStack {
          let font = fontForStringSize(getStringClass(text.count))
            Spacer()
            Text(text)
            .font(font)
                .padding()
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                        .shadow(radius: 5)
                )
            Spacer()
        }
    }
}
  
struct RoundedTextView2_Previews: PreviewProvider {

    static var previews: some View {
      VStack{
        RoundedTextView2(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor: .blue, gradientColor: .green)
        RoundedTextViewNoGradient2(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor: .blue)
      }
    }
  }

 func fontForStringSize (_ ss:StringSize) -> Font {
   switch (ss) {
   case .small:
     return .body
   case .medium:
     return .headline
   case .large:
     return .title
   }
 }
 func getStringClass( _ n:Int) -> StringSize {
   switch  (n) {
   case 0...100: return StringSize.large
   case 101...200: return StringSize.medium
   default: return StringSize.small
   }
 }
 //
 //@MainActor func updateTimer(appState:AppState) async throws {
 //  while appState.isTimerRunning {
 //    do {
 //      try Task.checkCancellation()
 //      try  await Task.sleep(nanoseconds: 100_000_000) // 1x
 //      appState.timerCount += 1
 //    }
 //    catch {
 //      appState.isTimerRunning = false
 //    }
 //  }
 //}
 //func cancelTimer(appState:AppState) async  throws{
 //  appState.isTimerRunning = false
 //  try Task.checkCancellation()
 //}
 
 */
