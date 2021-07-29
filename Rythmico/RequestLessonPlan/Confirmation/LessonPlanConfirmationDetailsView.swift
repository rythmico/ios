import SwiftUI

struct LessonPlanConfirmationDetailsView: View {
    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        VStack(spacing: .grid(4)) {
            HStack(spacing: .grid(3)) {
                Image(decorative: Asset.Icon.Label.info.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmico.foreground)
                Text(separator: .whitespace) {
                    "First Lesson:"
                    Self.dateFormatter.string(from: lessonPlan.schedule.startDate).text.rythmicoFontWeight(.bodyBold)
                    relativeDate().parenthesized()
                }
                .foregroundColor(.rythmico.foreground)
                .rythmicoTextStyle(.body)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: .grid(3)) {
                TutorAvatarView(tutor, mode: .thumbnail)
                    .fixedSize()
                Text(tutor.name)
                    .foregroundColor(.rythmico.foreground)
                    .rythmicoTextStyle(.bodyBold)
            }
        }
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private static let relativeDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .full, precise: true)
    private func relativeDate() -> String {
        // Can't use Current.relativeDateTimeFormatter alone because it needs to be precise in number of days regardless of number of hours.
        let startDate = lessonPlan.schedule.startDate
        let calendar = Current.calendar()
        let today = Current.date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        switch true {
        case calendar.isDate(startDate, inSameDayAs: tomorrow):
            return "Tomorrow"
        case calendar.isDate(startDate, inSameDayAs: today):
            return Self.relativeDateFormatter.localizedString(for: startDate, relativeTo: today)
        default:
            let todayComps = calendar.dateComponents([.year, .month, .day], from: today)
            let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
            let daysDiff = calendar.dateComponents([.day], from: todayComps, to: startDateComps).day!
            return "In \(daysDiff) days"
        }
    }
}
