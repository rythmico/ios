import SwiftUI

struct LessonsCollectionView: View {
    var currentBookings: [Booking]

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
                    Section(header: Text(dateFormatter.string(from: date)), footer: EmptyView()) {
                        ForEach(lessons) { lesson in
                            LessonSummaryCell(lesson: lesson)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }

    private let dateFormatter = Current.dateFormatter(format: .custom("EEEE dd MMM"), relativeToNow: true)
}
