import SwiftUI

struct PhotoCarouselView: View {
    var photos: [Portfolio.Photo]

    let columns = Array(repeating: GridItem(.flexible(), spacing: .spacingUnit * 2), count: 3)

    @Binding
    var selectedPhoto: Portfolio.Photo?

    var body: some View {
        LazyVGrid(columns: columns, spacing: .spacingUnit * 2) {
            ForEach(photos, id: \.self) { photo in
                PhotoCarouselCell(photo: photo).onTapGesture {
                    selectedPhoto = photo
                }
            }
        }
        .sheet(item: $selectedPhoto) { selectedPhoto in
            PhotoCarouselDetailView(photos: photos, selectedPhoto: $selectedPhoto)
        }
    }
}

private struct PhotoCarouselDetailView: View {
    var photos: [Portfolio.Photo]

    @Binding
    var selectedPhoto: Portfolio.Photo?

    var body: some View {
        TabView {
            ForEach(photos, id: \.self) { photo in
                AsyncImage(.transitional(from: photo.thumbnailURL, to: photo.photoURL)) {
                    if let uiImage = $0 {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Color.black
                    }
                }
                .tag(photo)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

private struct PhotoCarouselCell: View {
    var photo: Portfolio.Photo

    var body: some View {
        AsyncImage(.simple(photo.thumbnailURL)) {
            if let uiImage = $0 {
                GeometryReader { gr in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: gr.size.width)
                }
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: .durationShort)))
            } else {
                Color.rythmicoGray30
                    .scaledToFill()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: .durationShort)))
            }
        }
        .cornerRadius(.spacingUnit * 2, antialiased: true)
    }
}
