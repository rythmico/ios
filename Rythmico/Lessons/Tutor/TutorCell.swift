import SwiftUI

struct TutorCell: View {
    private enum Const {
        static let avatarSize = .spacingUnit * 14
    }

    var tutor: Tutor

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            TutorAvatarView(tutor, mode: .original)
                .frame(width: Const.avatarSize, height: Const.avatarSize)
                .withSmallDBSCheck()
            Text(tutor.name)
                .rythmicoTextStyle(.subheadlineBold)
                .foregroundColor(.rythmicoForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.spacingMedium)
        .frame(maxWidth: .spacingMax, alignment: .leading)
        .modifier(RoundedShadowContainer())
    }
}

#if DEBUG
struct TutorCell_Previews: PreviewProvider {
    static var previews: some View {
        TutorCell(tutor: .jesseStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
