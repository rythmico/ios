import SwiftUISugar

struct ProfileLessonPlansCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var body: some View {
        ProfileCell("Lesson Plans", disclosure: true) {
            navigator.go(to: LessonPlansScreen(), on: currentScreen)
        }
    }
}
