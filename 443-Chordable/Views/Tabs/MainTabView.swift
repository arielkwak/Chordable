import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack(spacing: 0) { // Remove the Spacer and set spacing to 0
            // Content views for different tabs
            if selectedTab == 0 {
                ChordsView(viewController: ChordsViewController())
            } else if selectedTab == 1 {
                HomeView()
            } else if selectedTab == 2 {
                SongsView()
            }

            Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing))
            .frame(height: 2)
            HStack {
                CustomTabBarButton(selectedImageName: "chords_tab_highlighted", unselectedImageName: "chords_tab_grey", title: "Chords", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                CustomTabBarButton(selectedImageName: "home_tab_highlighted", unselectedImageName: "home_tab_grey", title: "Home", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                CustomTabBarButton(selectedImageName: "song_tab_highlighted", unselectedImageName: "song_tab_grey", title: "Songs", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .frame(height: 88)
            .background(Color.black)
        }
        .edgesIgnoringSafeArea(.all)
        .shadow(color: .black.opacity(0.9), radius: 35, x: 0, y: -10)
    }
}

struct CustomTabBarButton: View {
    let selectedImageName: String
    let unselectedImageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(isSelected ? selectedImageName : unselectedImageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.top, 10)
                Text(title)
                    .font(.custom("Barlow-Bold", size: 14))
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : .gray)
                    .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
