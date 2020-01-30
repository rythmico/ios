import SwiftUI
import FirebaseAuth
import SFSafeSymbols
import Auth

struct MainTabView: View {
    private enum Const {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 28
    }

    private let viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView {
            NavigationView {
                Color.clear
                    .navigationBarTitle("Lessons", displayMode: .large)
                    .navigationBarItems(
                        trailing: Button(action: { print("hey") }) {
                            Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                                .padding(.vertical, Const.verticalPadding)
                                .padding(.horizontal, Const.horizontalPadding)
                                .offset(x: Const.horizontalPadding)
                        }
                    )
            }
            .tabItem {
                Image(systemSymbol: .calendar).font(Font.system(size: 21, weight: .medium))
                Text("LESSONS")
            }

            NavigationView {
                Form {
                    Button(action: { try! Auth.auth().signOut() }) {
                        HStack {
                            Spacer()
                            Text("Log out").rythmicoFont(.body).foregroundColor(.rythmicoRed)
                            Spacer()
                        }
                    }
                    .frame(minHeight: 35)
                }
                .navigationBarTitle(Text("Profile"), displayMode: .large)
            }
            .tabItem {
                Image(systemSymbol: .person).font(Font.system(size: 21, weight: .semibold))
                Text("PROFILE")
            }
        }
        .accentColor(.rythmicoPurple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel(accessTokenProvider: AuthenticationAccessTokenProviderDummy()))
    }
}
