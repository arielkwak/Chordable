import SwiftUI

struct ChordsView: View {
  @ObservedObject var viewController: ChordsViewController
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 10) {
          Text("CHORDS")
            .font(.largeTitle)
            .padding()
          
          HStack {
            Button(action: {
              viewController.filterOnCompleted = true
            }) {
              Text("Completed")
                .padding()
                .background(viewController.filterOnCompleted ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Button(action: {
              viewController.filterOnCompleted = false
            }) {
              Text("Incomplete")
                .padding()
                .background(viewController.filterOnCompleted ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
          }.padding([.leading, .trailing])
          
          ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
            VStack {
              Text(difficulty.capitalized)
                .font(.title2)
                .padding(.top)
              
              LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(viewController.displayedChords.filter { $0.difficulty == difficulty }, id: \.self) { chord in
                  NavigationLink(destination: ChordDetailView(chord: chord)) {
                    VStack {
                      Text(chord.displayableName)
                        .font(.title)
                      Text(chord.quality ?? "Major or Minor")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                  }
                }.padding([.leading, .trailing])
              }
            }
          }
        }
      }
    }
  }
}
