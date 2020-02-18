import SwiftUI
import FirebaseAuth
import SFSafeSymbols
import ViewModel

struct MainTabViewData {
    var lessonRequestView: LessonRequestView? = nil
}

struct MainTabView: View, ViewModelable {
    private enum Const {
        static let requestLessonButtonImageVerticalPadding: CGFloat = 12
        static let requestLessonButtonImageHorizontalPadding: CGFloat = 28
    }

    @ObservedObject var viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView {
            NavigationView {
                Color.clear
                    .navigationBarTitle("Lessons", displayMode: .large)
                    .navigationBarItems(
                        trailing: Button(action: viewModel.presentRequestLessonFlow) {
                            Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                                .padding(.vertical, Const.requestLessonButtonImageVerticalPadding)
                                .padding(.horizontal, Const.requestLessonButtonImageHorizontalPadding)
                                .offset(x: Const.requestLessonButtonImageHorizontalPadding)
                        }
                        .accessibility(label: Text("Request lessons"))
                        .accessibility(hint: Text("Double tap to request a lesson plan"))
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
                    .accessibility(hint: Text("Double tap to log out of your account"))
                }
                .navigationBarTitle(Text("Profile"), displayMode: .large)
            }
            .tabItem {
                Image(systemSymbol: .person).font(Font.system(size: 21, weight: .semibold))
                Text("PROFILE")
            }
        }
        .accentColor(.rythmicoPurple)
        .betterSheet(item: Binding(get: { self.viewData.lessonRequestView }, set: { _ in self.viewModel.dismissRequestLessonFlow() })) {
            $0.betterSheetIsModalInPresentation(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel(accessTokenProvider: AuthenticationAccessTokenProviderDummy()))
    }
}
