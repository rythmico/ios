import SwiftUI
import ComposableNavigator

struct PhotoCarouselView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var photos: [Portfolio.Photo]

    let columns = Array(repeating: GridItem(.flexible(), spacing: .grid(2)), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: .grid(2)) {
            ForEach(photos, id: \.self) { photo in
                PhotoCarouselCell(photo: photo).onTapGesture { openGallery(photo) }
            }
        }
    }

    private func openGallery(_ initialPhoto: Portfolio.Photo) {
        navigator.go(to: PhotoCarouselDetailScreen(photos: photos, selection: initialPhoto), on: currentScreen)
    }
}

private struct PhotoCarouselCell: View {
    var photo: Portfolio.Photo

    var body: some View {
        AsyncImage(content: .simple(photo.thumbnailURL)) {
            if let uiImage = $0 {
                GeometryReader { gr in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: gr.size.width)
                }
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
            } else {
                Color.rythmicoGray30
                    .scaledToFill()
                    .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
            }
        }
        .cornerRadius(.grid(2), antialiased: true)
    }
}

struct PhotoCarouselDetailScreen: Screen {
    var photos: [Portfolio.Photo]
    var selection: Portfolio.Photo
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: PhotoCarouselDetailScreen) in
                    PhotoCarouselDetailView(photos: screen.photos, selection: screen.selection)
                }
            )
        }
    }
}

struct PhotoCarouselDetailView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var photos: [Portfolio.Photo]
    @State
    var selection: Portfolio.Photo

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .trailing, spacing: 0) {
                CloseButton(action: dismiss)
                    .padding([.trailing, .bottom], .grid(4))
                    .padding(.top, .grid(5))
                    .accentColor(.rythmicoWhite)

                PageView(data: photos, selection: $selection, accentColor: .rythmicoWhite) { photo in
                    AsyncImage(content: .transitional(from: photo.thumbnailURL, to: photo.photoURL)) {
                        if let uiImage = $0 {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Color.black
                        }
                    }
                }
                .padding(.bottom, .grid(5))
            }
        }
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }
}
