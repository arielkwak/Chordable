//
//  HomeView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI
import CoreData

import SwiftUI
import CoreData

struct HomeView: View {
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [],
        predicate: nil
    ) var userInfo: FetchedResults<UserInfo>

    var body: some View {
        VStack {
            if let user = userInfo.first {
                Text("Welcome, \(user.user_name ?? "User")")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
            }
            Spacer()
        }
        .padding(.top, 30)
        .navigationTitle("Home")
    }
}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        }
//    }
//}
