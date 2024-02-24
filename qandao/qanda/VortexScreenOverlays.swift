//
//  VortexScreenOverlays.swift
//  qanda
//
//  Created by bill donner on 2/19/24.
//

import SwiftUI
import Vortex

struct ConfettiVortexScreenOverlay: View {
  var body: some View {
    VortexViewReader { proxy in
        ZStack {
          //  Text("Tap anywhere to create confetti.")

          VortexView(.confetti.makeUniqueCopy()) {
              Rectangle()
                  .fill(.white)
                  .frame(width: 16, height: 16)
                  .tag("square")

              Circle()
                  .fill(.white)
                  .frame(width: 16)
                  .tag("circle")
          }.ignoresSafeArea(edges:.all)
            .onAppear {// location in
             // proxy.move(to: location)
                proxy.burst()
            }
        }
    }
  }
}
#Preview {
  ConfettiVortexScreenOverlay()
}
struct RainSplashVortexScreenOverlay: View {
  var body: some View {
    ZStack {
      VortexView(.rain.makeUniqueCopy()) {
        Circle()
          .fill(.white)
          .frame(width: 32)
          .tag("circle")
      }
      
      VortexView(.splash.makeUniqueCopy()) {
        Circle()
          .fill(.white)
          .frame(width: 16, height: 16)
          .tag("circle")
      }
    }
    .ignoresSafeArea(edges: .all)
  }
}
#Preview {
  RainSplashVortexScreenOverlay()
}
struct FirefliesVortexScreenOverlay: View {
  var body: some View {
  
      VortexView(.fireflies.makeUniqueCopy()) {
          Circle()
              .fill(.white)
              .frame(width: 32)
              .blur(radius: 3)
              .blendMode(.plusLighter)
              .tag("circle")
      }
    .ignoresSafeArea(edges: .all)
  }
}
#Preview {
  FirefliesVortexScreenOverlay()
}
struct SparkleVortexScreenOverlay: View {
  var body: some View {
    VortexView(.magic.makeUniqueCopy()) {
        Image(.sparkle)
            .blendMode(.plusLighter)
            .tag("sparkle")
    }
    
    .frame(width:100,height:100)
    //.ignoresSafeArea(edges: .all)
  }
}
#Preview {
  SparkleVortexScreenOverlay()
}
