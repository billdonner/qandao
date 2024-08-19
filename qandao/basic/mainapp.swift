//
//  mainapp.swift
//  basic
//
//  Created by bill donner on 7/8/24.
//

import SwiftUI
let playDataFileName = "playdata.json"
let starting_size = 3 // Example size, can be 3 to 8
let spareHeightFactor = 1.37 // controls layout of grid if too small
let cornerradius = 0.0 // something like 8 makes nice rounded cord=ners
var isDebugModeEnabled: Bool = false
var debugBorderColor: Color = .red

extension Color {
  static let offBlack = Color(red: 0.1, green: 0.1, blue: 0.1)
  static let offWhite = Color(red: 0.95, green: 0.95, blue: 0.95)
}
class OrientationLockedViewController: UIViewController {
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}



// Assuming a mock PlayData JSON file in the main bundle


// The app's main entry point
@main
struct ChallengeGameApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("OnboardingDone") private var onboardingdone = false
  @State var showOnboarding = false
  @State var chmgr = ChaMan(playData: PlayData.mock )
  @State var gs = GameState(size: starting_size,
                            topics:[],
                            challenges:Challenge.mockChallenges)
  
  var body: some Scene {
    WindowGroup {
      
      ContentView(gs: gs,chmgr: chmgr)
        .statusBar(hidden: true) // Hide the status b
        //.preferredColorScheme(.dark) // Enforce dark mode for this view
        .sheet(isPresented: $showOnboarding) {
          OnboardingScreen(isPresented: $showOnboarding)
        }
        .onAppear {
          assert(gs.checkVsChaMan(chmgr: chmgr))
          AppDelegate.lockOrientation(.portrait)// ensure applied
          if (onboardingdone == false ) { // if not yet done then trigger it
            showOnboarding = true
            onboardingdone = true// flag it here while running straight swift
          }
        }
    }
  }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  static var orientationLock = UIInterfaceOrientationMask.portrait
  
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    self.orientationLock = orientation
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    // Notify the system to update the orientation
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
  }
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return AppDelegate.orientationLock
  }
}
