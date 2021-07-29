import SwiftUI

struct TutorAcceptedStatusPill: View {
    var tutor: Tutor?

    private var title: String {
        ["Accepted", tutor?.name.firstWord.map { "by \($0)" }]
            .compacted()
            .spaced()
    }

    var body: some View {
        Pill(
            title: title,
            titleColor: .rythmico.tagTextGreen,
            backgroundColor: .rythmico.tagGreen,
            borderColor: .clear
        )
    }
}

#if DEBUG
struct TutorAcceptedStatusPill_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TutorAcceptedStatusPill()
            TutorAcceptedStatusPill(tutor: .davidStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
