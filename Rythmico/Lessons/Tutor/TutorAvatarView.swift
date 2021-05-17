import SwiftUI
import FoundationSugar

struct TutorAvatarView: View {
    enum Mode {
        case thumbnail
        case original
    }

    private let tutor: Tutor
    private let mode: Mode
    private let backgroundColor: Color

    init(
        _ tutor: Tutor,
        mode: Mode,
        backgroundColor: Color = AvatarView.Const.defaultBackgroundColor
    ) {
        self.tutor = tutor
        self.mode = mode
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        if let asyncContent = asyncContent {
            AsyncImage(content: asyncContent, label: avatarView)
        } else {
            avatarView(with: nil)
        }
    }

    @ViewBuilder
    private func avatarView(with uiImage: UIImage?) -> some View {
        AvatarView(
            uiImage.map(AvatarView.Content.photo) ?? .initials(tutor.name.initials),
            backgroundColor: backgroundColor
        )
    }

    private var asyncContent: AsyncImageContent? {
        switch mode {
        case .thumbnail:
            return tutor.thumbnailURL.map(AsyncImageContent.simple)
        case .original:
            switch (tutor.thumbnailURL, tutor.photoURL) {
            case (let thumbnail?, let original?):
                return .transitional(from: thumbnail, to: original)
            case (let ref?, _), (_, let ref?):
                return .simple(ref)
            case (nil, nil):
                return nil
            }
        }
    }
}

extension AvatarStackView where Data.Element == Tutor, ContentView == TutorAvatarView {
    init(data: Data, thumbnails: Bool) {
        self.init(data: data) { TutorAvatarView($0, mode: .thumbnail) }
    }
}
