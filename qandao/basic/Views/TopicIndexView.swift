import SwiftUI

struct Tdi: Identifiable {
    let name: String
    let id = UUID()
}

struct TopicIndexView: View {
    let gs: GameState
    let chmgr: ChaMan
    @Environment(\.colorScheme) var colorScheme // System light/dark
    @State var succ = false
    @State var topicDetailInfo: Tdi? = nil

    var body: some View {
       // GeometryReader { geometry in
            //let isIpad = geometry.size.width > 600
            
          ScrollView(.horizontal, showsIndicators: false)  {
             // Text("      ") // push this down a bit
              //  LazyVGrid(columns: columns, spacing: 8) {
             HStack  {
                    ForEach(gs.basicTopics(), id: \.name) { topic in
                        HStack {
                            RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 3.0))
                                .frame(width: isIpad ? 25 : 15, height: isIpad ? 25 : 15)
                                .foregroundStyle(gs.colorForTopic(topic.name).0)
                            Text(truncatedText(topic.name, count: isIpad ? 60 : 30))
                                .lineLimit(1)
                                .font(isIpad ? .headline : .caption2)
                                .foregroundColor(textColor)
                        }
                       // .frame(width: geometry.size.width / 3 /// (1.0 * //1.1
                          //CGFloat(columns.count))
                              // ,
                              // height: isIpad ? 30 : 24)
                        .padding(.horizontal, isIpad ? 8 : 4)
                        .background(Color.clear)
                        //.cornerRadius(8)
                        .onTapGesture {
                            topicDetailInfo = Tdi(name: topic.name)
                        }
                    }
                }
                .padding(4)
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
         // .frame(height:50)
            .sheet(item: $topicDetailInfo) { tdi in
                TopicDetailsView(topic: tdi.name, gs: gs, chmgr: chmgr)
            }
       // }
        .debugBorder()
    }

    // Computed properties for background and text colors
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.96)
    }

    private var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }


}

// Assuming you have the ChaMan and colorSchemes to preview the view
struct TopicIndexView_Previews: PreviewProvider {
    static var previews: some View {
        TopicIndexView(
          gs: GameState.mock,
            chmgr: ChaMan.mock
        )
    }
}
