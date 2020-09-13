import SwiftUI
import Sugar

struct LessonPlanTutorAvatarView: View {
    @StateObject
    private var coordinator = Current.imageLoadingCoordinator()

    private let tutor: LessonPlan.Tutor
    private let thumbnail: Bool
    private let backgroundColor: Color

    init(
        _ tutor: LessonPlan.Tutor,
        thumbnail: Bool,
        backgroundColor: Color = AvatarView.Const.defaultBackgroundColor
    ) {
        self.tutor = tutor
        self.thumbnail = thumbnail
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        AvatarView(content, backgroundColor: backgroundColor)
            .onAppear(perform: load)
            .onDisappear(perform: coordinator.cancel)
    }

    private var content: AvatarView.Content {
        coordinator.state.successValue.map(AvatarView.Content.photo)
        ??
        .initials(tutor.name.initials)
    }

    private var photoReference: ImageReference? {
        thumbnail ? tutor.photoThumbnailURL : tutor.photoURL
    }

    private func load() {
        photoReference.map(coordinator.run)
    }
}

extension AvatarStackView where Data.Element == LessonPlan.Tutor, ContentView == LessonPlanTutorAvatarView {
    init(_ data: Data, thumbnails: Bool) {
        self.init(data) { LessonPlanTutorAvatarView($0, thumbnail: thumbnails) }
    }
}
