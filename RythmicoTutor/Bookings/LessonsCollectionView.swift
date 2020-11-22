import SwiftUI

struct LessonsCollectionView: View {
    var currentBookings: [Booking]

    var lessons: [Lesson] {
        let allLessons = currentBookings.map(\.lessons).flatten()
        return allLessons
            .filter { Current.date() < $0.schedule.endDate }
            .sorted { $0.schedule.startDate < $1.schedule.startDate }
    }

    var body: some View {
        List(lessons) { lesson in
            // TODO
            Text(lesson.student.name)
        }
        .listStyle(GroupedListStyle())
    }
}
