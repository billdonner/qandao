//
//  HappyGloomyView.swift
//  qandao
//
//  Created by bill donner on 8/19/24.
//

import SwiftUI
struct HappySmileyView : View {
  let color:Color
  @Environment(\.colorScheme) var colorScheme //system light/dark
  var body: some View {
    ZStack {
      colorScheme == .dark ? Color.offBlack : Color.offWhite
      Circle().foregroundStyle(color)
    }
  }
}



struct GloomyView: View {
  let color:Color
  let fudge = 3.0
  @Environment(\.colorScheme) var colorScheme //system light/dark
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Black background
                colorScheme == .dark ? Color.offBlack : Color.offWhite
                // White diagonal line
                Path { path in
                    let size = geometry.size
                    path.move(to: CGPoint(x: fudge, y: fudge))
                    path.addLine(to: CGPoint(x: size.width-fudge, y: size.height-fudge))
                  path.move(to: CGPoint(x:  size.width-fudge, y: fudge))
                  path.addLine(to: CGPoint(x:fudge, y: size.height-fudge))
                }
                .stroke(color, lineWidth: 5)
            }
        }
    }
}





#Preview ("Happy") {
  HappySmileyView(color: .blue)
    .frame(width: 100, height: 100) // Set the size of the square
}

 
#Preview ("Gloomy"){
  GloomyView(color:.red)
    .frame(width: 100, height: 100) // Set the size of the square
}
