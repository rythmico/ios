import SwiftUI

struct PhotoCarouselView: View {
    var photos: [Portfolio.Photo]

    let columns = Array(repeating: GridItem(.flexible(), spacing: .spacingUnit * 2), count: 3)

    @State
    private var selectedPhoto: Portfolio.Photo?

    var body: some View {
        LazyVGrid(columns: columns, spacing: .spacingUnit * 2) {
            ForEach(photos, id: \.self) { photo in
                PhotoCarouselCell(photo: photo).onTapGesture {
                    selectedPhoto = photo
                }
            }
        }
        .sheet(item: $selectedPhoto) { selectedPhoto in
            TabView(selection: Binding($selectedPhoto)) {
                ForEach(photos, id: \.self) { photo in
                    AsyncImage(.transitional(from: photo.thumbnailURL, to: photo.photoURL)) {
                        if let uiImage = $0 {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Color.rythmicoGray20
                                .scaledToFit()
                        }
                    }
                    .tag(photo)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

private struct PhotoCarouselCell: View {
    var photo: Portfolio.Photo

    var body: some View {
        AsyncImage(.simple(photo.thumbnailURL)) {
            if let uiImage = $0 {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.rythmicoGray30
            }
        }
        .cornerRadius(.spacingUnit * 2, antialiased: true)
    }
}
