import SwiftUI

struct LessonsCollectionView: View {
    var currentBookings: [Booking]
    @State private var selectedLesson: Lesson?

    var lessons: [Date: [Lesson]] {
        let allLessons = currentBookings.map(\.lessons).flatten()
        let upcomingLessons = allLessons.filter { Current.date() < $0.schedule.endDate }
        return upcomingLessons.reduce(into: [:]) { acc, c in
            let components = Current.calendar().dateComponents([.year, .month, .day], from: c.schedule.startDate)
            let date = Current.calendar().date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [c]
        }
    }

    var body: some View {
        List {
            ForEach(Array(lessons.keys), id: \.self) { date in
                if let lessons = lessons[date] {
                    Section(header: Text(dayString(from: date)), footer: EmptyView()) {
                        ForEach(lessons) { lesson in
                            LessonSummaryCell(lesson: lesson, selection: $selectedLesson)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }

    private let dateFormatter = Current.dateFormatter(format: .custom("EEEE dd MMM"))
    private func dayString(from date: Date) -> String {
        switch true {
        case Current.calendar().isDateInYesterday(date): return "Yesterday"
        case Current.calendar().isDateInToday(date): return "Today"
        case Current.calendar().isDateInTomorrow(date): return "Tomorrow"
        default: return dateFormatter.string(from: date)
        }
    }
}
