import SwiftUI

enum AsyncImageContent {
    case simple(ImageReference)
    case transitional(from: ImageReference, to: ImageReference)
}

struct AsyncImage<Label: View>: View {
    typealias Content = AsyncImageContent

    @StateObject
    private var primaryCoordinator = Current.imageLoadingCoordinator()
    @StateObject
    private var secondaryCoordinator = Current.imageLoadingCoordinator()

    private var content: Content
    private var label: (UIImage?) -> Label

    init(_ content: Content, @ViewBuilder label: @escaping (UIImage?) -> Label) {
        self.content = content
        self.label = label
    }

    var body: some View {
        label(uiImage)
            .onAppear(perform: load)
            .onDisappear(perform: cancel)
    }

    private var uiImage: UIImage? {
        secondaryCoordinator.state.successValue ?? primaryCoordinator.state.successValue
    }

    private func load() {
        switch content {
        case .simple(let ref):
            primaryCoordinator.run(with: ref)
        case .transitional(let primaryRef, let secondaryRef):
            primaryCoordinator.run(with: primaryRef)
            secondaryCoordinator.run(with: secondaryRef)
        }
    }

    private func cancel() {
        primaryCoordinator.cancel()
        secondaryCoordinator.cancel()
    }
}
