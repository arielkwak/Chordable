import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0  // To keep track of the currently selected tab

    init() {
      let appearance = UITabBarAppearance()
      appearance.backgroundColor = .black
      if #available(iOS 14.0, *) {
           appearance.shadowColor = UIColor(Color(red: 0.14, green: 0, blue: 1))
       } else {
           // Fallback on earlier versions
           appearance.shadowColor = .white
       }
      UITabBar.appearance().scrollEdgeAppearance = appearance
      UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Chords Tab
            ChordsView(viewController: ChordsViewController())
                .tabItem {
                    Image(selectedTab == 0 ? "chords_tab_highlighted" : "chords_tab_grey")
                    Text("Chords")
                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                    .foregroundColor(selectedTab == 0 ? .white : .gray)
                }
                .tag(0)
            
            // Home Tab
            HomeView()
                .tabItem {
                    Image(selectedTab == 1 ? "home_tab_highlighted" : "home_tab_grey")
                    Text("Home")
                    .fontWeight(selectedTab == 1 ? .bold : .regular)
                    .foregroundColor(selectedTab == 1 ? .white : .gray)

                }
                .tag(1)
            
            // Songs Tab
            SongsView()
                .tabItem {
                    Image(selectedTab == 2 ? "song_tab_highlighted" : "song_tab_grey")
                    Text("Songs")
                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                    .foregroundColor(selectedTab == 2 ? .white : .gray)
                }
                .tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
