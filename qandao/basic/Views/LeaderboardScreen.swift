import SwiftUI


// MARK: - Views
struct LeaderboardScreen: View {
  let leaderboardService:LeaderboardService

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        leaderboardService.clearScores()
                    }) {
                        Text("Clear Leaderboard")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .padding()

                    Spacer()
                }

                Text("Leaderboard")
                    .font(.largeTitle)
                    .padding()

                List(leaderboardService.scores) { score in
                    HStack {
                        Text(score.playerName)
                        Spacer()
                        Text("\(score.score) pts")
                    }
                }
                .navigationBarTitle("Leaderboard", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: AddScoreView(leaderboardService: leaderboardService)) {
                    Text("Add Score")
                })
            }
        }
    }
}

struct AddScoreView: View {
    let leaderboardService: LeaderboardService
    @State private var playerName = ""
    @State private var score = ""

    var body: some View {
        VStack {
            TextField("Player Name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Score", text: $score)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button("Add Score") {
                if let scoreInt = Int(score) {
                    leaderboardService.addScore(playerName: playerName, score: scoreInt)
                }
                playerName = ""
                score = ""
            }
            .padding()
        }
        .navigationBarTitle("Add New Score", displayMode: .inline)
    }
}

#Preview {
  LeaderboardScreen(leaderboardService: LeaderboardService())
}

