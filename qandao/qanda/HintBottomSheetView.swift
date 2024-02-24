//
//  HintBottomSheetView.swift
//  qanda
//
//  Created by bill donner on 6/4/23.
//

import SwiftUI
import q20kshare

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
    .background(.blue).opacity(0.7)
    .foregroundColor(.white)
    .ignoresSafeArea()
  }
  
}
