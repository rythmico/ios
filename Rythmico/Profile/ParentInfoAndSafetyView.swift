import SwiftUI

struct ParentInfoAndSafetyView: View {
    var body: some View {
        TitleSubtitleView(
            title: "Parent Info & Safety",
            subtitle: [
                "Music lessons with Rythmico may be relaxed, but we take our responsibility as teachers very seriously. All tutors are DBS checked with years of experience working with children, both in mainstream schools and those that cater for young people with specialist needs.".part
            ]
        )
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, .spacingExtraSmall)
        .padding(.horizontal, .spacingMedium)
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
