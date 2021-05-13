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
        TitleContentView(title: "Parent Info & Safety") {
            ScrollView {
                Text("Music lessons with Rythmico may be relaxed, but we take our responsibility as teachers very seriously. All tutors are DBS checked with years of experience working with children, both in mainstream schools and those that cater for young people with specialist needs.")
                    .foregroundColor(.rythmicoGray90)
                    .rythmicoTextStyle(.body)
                    .frame(maxWidth: .spacingMax, alignment: .leading)
                    .padding(.horizontal, .spacingMedium)
            }
        }
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
