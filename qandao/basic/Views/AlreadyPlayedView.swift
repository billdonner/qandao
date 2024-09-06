//
//  AlreadyTappedVIew.swift
//  basic
//
//  Created by bill donner on 8/1/24.
//
import SwiftUI

struct AlreadyPlayedView : View {
//  let row:Int
//  let col:Int
  let ch:Challenge
  let gs:GameState
  let chmgr: ChaMan
  @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view
  var body: some View {

    if let ansinfo = chmgr.ansinfo[ch.id] {
      let topicColor =   gs.colorForTopic(ch.topic).0
        VStack {
          VStack {
            Button(action:{
              dismiss()
            })
            {
              HStack  {
                Spacer()
                Image(systemName: "x.circle")
                  .font(.title)
                  .foregroundColor(.primary)
              }.padding()
            }
          }
          Spacer()
          VStack (spacing:30){
            Text(ch.question)
              .font(isIpad ? .largeTitle:.title3)
              .padding()//([.top,.horizontal])
              .lineLimit(8)
              .foregroundColor(foregroundColorFrom( backgroundColor: topicColor))

            ScrollView {
            VStack (alignment: .leading){
              HStack{Text ("The correct answer is:").font(.caption);Text(" \(ch.correct)").font(.headline).lineLimit(2);Spacer()}
              HStack{Text ("Your answer was: ").font(.caption); Text("\(ansinfo.answer)").font(.headline).lineLimit(2);Spacer()}
                Text("The other possible answers were: \(joinWithCommasAnd( removeStrings(from: ch.answers, stringsToRemove: [ch.correct,ansinfo.answer])) )").font(.body)
                if ch.hint.count<=1 {
                  Text("There was no hint")
                } else {
                  Text ("The hint was: \(ch.hint)")
                }
              if let exp = ch.explanation,exp.count>1 {
                  Text("The explanation given was: \(exp)")
                } else {
                  Text ("no explanation was given")
                }
                Spacer()
                Text("Played in game \(ansinfo.gamenumber) move \(ansinfo.movenumber) at  (\(ansinfo.row),\(ansinfo.col)) ").font(.footnote)
                Text ("You took \(Int(ansinfo.timetoanswer)) seconds to answer").font(.footnote)
              HStack {
                Text("id: ");
                TextField("id", text:.constant("\(ch.id)")).font(.caption)
                VStack (alignment: .leading){
                  Text ("You answered this question on \(ansinfo.timestamp)").font(.footnote)
            
                }
                Spacer()
              }
              Spacer()
            }.background(Color.gray.opacity(0.2))
            }
          }.padding(.horizontal)
          Spacer()
        }
        .border( ansinfo.answer == ch.correct ? .green:.red,width:10)
      
      
    } else {
      Color.red
    }
  }
}
#Preview {
  AlreadyPlayedView(ch:Challenge.complexMock,  gs: GameState.mock , chmgr: ChaMan.mock)
}
