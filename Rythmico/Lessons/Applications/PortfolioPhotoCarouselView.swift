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
        .cornerRadius(.spacingUnit * 2, antialiased: true)
    }
}

struct PhotoCarouselDetailView: View {
    @Environment(\.presentationMode) private var presentationMode

    var photos: [Portfolio.Photo]
    @Binding
    var selection: Portfolio.Photo?
    @State
    private var latestSelection: Portfolio.Photo

    init?(photos: [Portfolio.Photo], selection: Binding<Portfolio.Photo?>) {
        guard let initialSelection = selection.wrappedValue else {
            return nil
        }
        self.photos = photos
        self._selection = selection
        self._latestSelection = .init(wrappedValue: initialSelection)
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .trailing, spacing: 0) {
                CloseButton(action: dismiss)
                    .padding([.trailing, .bottom], .spacingSmall)
                    .padding(.top, .spacingMedium)
                    .accentColor(.rythmicoWhite)

                PageView(data: photos, selection: Binding($selection) ?? $latestSelection, accentColor: .rythmicoWhite) { photo in
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
                .padding(.bottom, .spacingMedium)
            }
        }
        .onChange(of: selection) { $0.map { latestSelection = $0 } }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
