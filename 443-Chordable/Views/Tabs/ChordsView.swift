import SwiftUI

struct ChordsView: View {
  @ObservedObject var viewController: ChordsViewController
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 10) {
          VStack {
            Text("CHORDS")
              .padding(.top,30)
              .padding(.bottom, 10)
              .font(.custom("Barlow-Bold", size: 32))
              .frame(maxWidth: .infinity, alignment: .leading)
              .kerning(1.6)
              .foregroundColor(.white)
              .padding(.leading, 25)
          }
          .background(Color.black)
          
          ZStack {
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: Color(red: 0.14, green: 0, blue: 1).opacity(0.49), radius: 10, x: 0, y: -10)
            VStack{
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 190/255, green: 180/255, blue: 255/255), Color.black]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 5)
                .padding(.horizontal, 30)

              // styling for searchbar & complete/incomplete buttons
              VStack {
                SearchBar(text: $viewController.searchQuery)
                
                HStack {
                  // button styling for incomplete
                  Button(action: {
                    viewController.filterOnCompleted = false
                  }) {
                    Text("Incomplete")
                      .font(viewController.filterOnCompleted ? .custom("Barlow-Regular", size: 22) : .custom("Barlow-Bold", size: 22))
                      .padding(.trailing, 50)
                      .overlay { !viewController.filterOnCompleted ?
                        LinearGradient(
                          colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255), Color(red: 127 / 255, green: 0, blue: 255 / 255)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Incomplete")
                          .font(!viewController.filterOnCompleted ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                          .padding(.trailing, 50)
                        )
                        :
                        LinearGradient(
                          colors: [Color(red: 0.63, green: 0.63, blue: 0.63), Color(red: 0.63, green: 0.63, blue: 0.63)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Incomplete")
                          .font(!viewController.filterOnCompleted ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                          .padding(.trailing, 50)
                        )
                      }
                  }
                  
                  // button styling for complete
                  Button(action: {
                    viewController.filterOnCompleted = true
                  }) {
                    Text("Complete")
                      .font(viewController.filterOnCompleted ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                      .padding(.leading, 50)
                      .overlay { viewController.filterOnCompleted ?
                        LinearGradient(
                          colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255), Color(red: 127 / 255, green: 0, blue: 255 / 255)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Complete")
                          .font(viewController.filterOnCompleted ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                          .padding(.leading, 50)
                        )
                        :
                        LinearGradient(
                          colors: [Color(red: 0.63, green: 0.63, blue: 0.63), Color(red: 0.63, green: 0.63, blue: 0.63)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Complete")
                          .font(viewController.filterOnCompleted ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                          .padding(.leading, 50)
                        )
                      }
                  }
                }
                .padding([.leading, .trailing])
                
                // underline for buttons when pressed
                Spacer()
                  GeometryReader { geometry in
                    HStack {
                      Rectangle()
                      .fill(!viewController.filterOnCompleted ?
                          AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing)) :
                          AnyShapeStyle(Color.clear)
                      )
                      .frame(width: geometry.size.width / 2, height: 5)
                      Spacer()
                      Rectangle()
                      .fill(viewController.filterOnCompleted ?
                          AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing)) :
                          AnyShapeStyle(Color.clear)
                      )
                      .frame(width: geometry.size.width / 2, height: 5)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                  }.padding(.bottom, -15)
              }
            }
          }
           
          VStack{
            VStack{
              ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
                VStack(alignment: .leading) {
                  Text(difficulty.capitalized)
                    .font(.custom("Barlow-Medium", size: 24))
                    .padding(.top, 30)
                    .padding(.leading, 25)
                    .foregroundColor(.white)
                  
                  LazyVGrid(columns: Array(repeating: GridItem(.fixed(114), spacing: 8), count: 3), spacing: 10) {
                    ForEach(viewController.displayedChords.filter { $0.difficulty == difficulty }, id: \.self) { chord in
                      let displayableName = chord.displayable_name ?? "Unknown Chord"
                      let chordParts = displayableName.components(separatedBy: "#")
                      NavigationLink(destination: ChordDetailView(chord: chord)) {
                        VStack {
                          HStack {
                            if let firstPart = chordParts.first {
                              Text(firstPart)
                                .font(.custom("Barlow-BlackItalic", size: 64))
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                            if chordParts.count > 1 {
                              Text("#" + chordParts[1])
                                .font(.custom("Barlow-BlackItalic", size: 32))
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .offset(x:-5, y: -10)
                            }
                          }.frame(width:90, height: 50)
                            .padding(.top, 8)
                          Text(chord.quality ?? "Major or Minor")
                            .font(.custom("Barlow-Regular", size: 24))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 8)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .cornerRadius(15)
                        //                    .onTapGesture {
                        //                      viewController.completeChord(chord)
                        //                    }
                      }
                    }
                  }
                }
              }
              Spacer()
            }.padding(.bottom, 40)
            .frame(minHeight: 520)
          }
          .background(Color(red: 35 / 255.0, green: 35 / 255.0, blue: 35 / 255.0))
        }
      }
      .background(Color.black)
    }
  }
}


struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")  
                .foregroundColor(.black)
                .padding(.horizontal, 15)
            
            TextField("Search for chords...", text: $text)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(.black)
                .font(Font.custom("Barlow-regular", size: 16))
        }
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
    }
}
