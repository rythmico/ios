import SwiftUI
import Sugar

struct LessonPlanTutorAvatarView: View {
    enum Mode {
        case thumbnail
        case original
        case thumbnailToOriginal
    }

    @StateObject
    private var thumbnailCoordinator = Current.imageLoadingCoordinator()
    @StateObject
    private var originalCoordinator = Current.imageLoadingCoordinator()

    private let tutor: LessonPlan.Tutor
    private let mode: Mode
    private let backgroundColor: Color

    init(
        _ tutor: LessonPlan.Tutor,
        mode: Mode,
        backgroundColor: Color = AvatarView.Const.defaultBackgroundColor
    ) {
        self.tutor = tutor
        self.mode = mode
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        AvatarView(content, backgroundColor: backgroundColor)
            .onAppear(perform: load)
            .onDisappear(perform: cancel)
    }

    private var content: AvatarView.Content {
        let content: AvatarView.Content?
        switch mode {
        case .thumbnail:
            content = thumbnailCoordinator.state.successValue.map(AvatarView.Content.photo)
        case .original:
            content = originalCoordinator.state.successValue.map(AvatarView.Content.photo)
        case .thumbnailToOriginal:
            content =
                originalCoordinator.state.successValue.map(AvatarView.Content.photo)
                ??
                thumbnailCoordinator.state.successValue.map(AvatarView.Content.photo)
        }
        return content ?? .initials(tutor.name.initials)
    }

    private func load() {
        switch mode {
        case .thumbnail:
            tutor.photoThumbnailURL.map(thumbnailCoordinator.run)
        case .original:
            tutor.photoURL.map(originalCoordinator.run)
        case .thumbnailToOriginal:
            tutor.photoThumbnailURL.map(thumbnailCoordinator.run)
            tutor.photoURL.map(originalCoordinator.run)
        }
    }

    private func cancel() {
        thumbnailCoordinator.cancel()
        originalCoordinator.cancel()
    }
}

extension AvatarStackView where Data.Element == LessonPlan.Tutor, ContentView == LessonPlanTutorAvatarView {
    init(_ data: Data, thumbnails: Bool) {
        self.init(data) { LessonPlanTutorAvatarView($0, mode: .thumbnail) }
    }
}
