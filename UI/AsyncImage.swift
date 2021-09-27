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

    var content: Content
    @ViewBuilder
    var label: (UIImage?) -> Label

    var body: some View {
        ZStack {
            label(uiImage)
        }
        .onAppear(perform: load)
        .onAppear(perform: resume)
        .onDisappear(perform: suspend)
    }

    private var uiImage: UIImage? {
        secondaryCoordinator.output?.value ?? primaryCoordinator.output?.value
    }

    private func load() {
        switch content {
        case .simple(let ref):
            primaryCoordinator.start(with: ref)
        case .transitional(let primaryRef, let secondaryRef):
            secondaryCoordinator.start(with: secondaryRef)
            primaryCoordinator.start(with: primaryRef)
        }
    }

    private func resume() {
        secondaryCoordinator.resume()
        primaryCoordinator.resume()
    }

    private func suspend() {
        secondaryCoordinator.suspend()
        primaryCoordinator.suspend()
    }
}
