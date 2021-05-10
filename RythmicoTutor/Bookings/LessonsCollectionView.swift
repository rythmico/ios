import SwiftUI

struct LessonsCollectionView: View {
    var currentBookings: [Booking]
    @State private var selectedLesson: Lesson?

    @ObservedObject
    private var navigation = Current.navigation
    private var filter: BookingsTabView.Tab { navigation.scheduleFilter }

    var days: [Date] {
        let unsortedDays = Array(lessons.keys)
        switch filter {
        case .upcoming: return unsortedDays.sorted { $0 < $1 }
        case .past: return unsortedDays.sorted { $0 > $1 }
        }
    }

    var lessons: [Date: [Lesson]] {
        let allLessons = currentBookings.map(\.lessons).flatten()
        let ungroupedLessons: [Lesson]
        switch filter {
        case .upcoming: ungroupedLessons = allLessons.filter { Current.date() < $0.schedule.endDate }
        case .past: ungroupedLessons = allLessons.filter { Current.date() > $0.schedule.endDate }
        }
        return ungroupedLessons.reduce(into: [:]) { acc, c in
            let components = Current.calendar().dateComponents([.year, .month, .day], from: c.schedule.startDate)
            let date = Current.calendar().date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [c]
        }
    }

    var body: some View {
        List {
            ForEach(days, id: \.self) { date in
                if let lessons = lessons[date] {
                    Section(header: Text(dayString(from: date))) {
                        ForEach(lessons) { lesson in
                            LessonSummaryCell(lesson: lesson, selection: $selectedLesson)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE dd MMM"))
    private func dayString(from date: Date) -> String {
        switch true {
        case Current.calendar().isDateInYesterday(date): return "Yesterday"
        case Current.calendar().isDateInToday(date): return "Today"
        case Current.calendar().isDateInTomorrow(date): return "Tomorrow"
        default: return Self.dateFormatter.string(from: date)
        }
    }
}
