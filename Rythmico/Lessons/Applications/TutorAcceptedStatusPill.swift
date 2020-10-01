import SwiftUI

struct TutorAcceptedStatusPill: View {
    var tutor: LessonPlan.Tutor?

    private var title: String {
        ["Accepted", tutor?.name.firstWord.map { "by \($0)" }]
            .compact()
            .spaced()
    }

    var body: some View {
        Pill(
            title: title,
            titleColor: .rythmicoDarkGreen,
            backgroundColor: .rythmicoLightGreen
        )
    }
}

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