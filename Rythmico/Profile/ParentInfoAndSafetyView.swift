import SwiftUI
import ComposableNavigator

struct ParentInfoAndSafetyScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                ParentInfoAndSafetyScreen.self,
                content: { ParentInfoAndSafetyView() }
            )
        }
    }
}

struct ParentInfoAndSafetyView: View {
    var body: some View {
        TitleContentView("Parent Info & Safety") { padding in
            ScrollView {
                Text("Music lessons with Rythmico may be relaxed, but we take our responsibility as teachers very seriously. All tutors are DBS checked with years of experience working with children, both in mainstream schools and those that cater for young people with specialist needs.")
                    .foregroundColor(.rythmico.foreground)
                    .rythmicoTextStyle(.body)
                    .frame(maxWidth: .grid(.max), alignment: .leading)
                    .padding(padding)
            }
        }
        .backgroundColor(.rythmico.background)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
struct ParentInfoAndSafetyView_Previews: PreviewProvider {
    static var previews: some View {
        ParentInfoAndSafetyView()
    }
}
#endif
