import SwiftUI
import FirebaseAuth
import SFSafeSymbols
import Auth

// TODO

struct MainTabView: View {
    @State private var selection = 0

    private let viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Color.clear
                    .navigationBarTitle("Lessons")
            }
            .tabItem {
                VStack {
                    Image(systemSymbol: .calendar).font(Font.system(size: 21))
                    Text("LESSONS")
                }
            }
            .tag(0)

            NavigationView {
                VStack {
                    Button("Sign out", action: { try! Auth.auth().signOut() })
                }
                .navigationBarTitle("David Roman")
            }

                .tabItem {
                    VStack {
                        Image(systemSymbol: .person).font(Font.system(size: 21))
                        Text("PROFILE")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel(accessTokenProvider: AuthenticationAccessTokenProviderDummy()))
    }
}
