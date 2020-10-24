import SwiftUI

struct GenderSelectionView: View {
    @Binding var selection: Gender?
    var accentColor = Color.rythmicoPurple

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Gender.allCases, id: \.self) { gender in
                HStack(spacing: 0) {
                    Text(gender.name)
                        .rythmicoFont(textStyle(for: gender))
                        .foregroundColor(textColor(for: gender))
                        .animation(.none)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(decorative: gender.icon.name)
                        .renderingMode(.template)
                        .foregroundColor(iconColor(for: gender))
                }
                .modifier(
                    containerModifier(for: gender)
                        .animation(.rythmicoSpring(duration: .durationShort))
                )
                .contentShape(Rectangle())
                .onTapGesture { selection = gender }
            }
        }
    }

    private func textColor(for gender: Gender) -> Color {
        selection == gender ? accentColor : .rythmicoForeground
    }

    private func textStyle(for gender: Gender) -> RythmicoFontStyle {
        selection == gender ? .bodyBold : .body
    }

    private func iconColor(for gender: Gender) -> Color {
        selection == gender ? accentColor : .rythmicoGray90
    }

    private func containerModifier(for gender: Gender) -> RoundedThickOutlineContainer {
        selection == gender
            ? RoundedThickOutlineContainer(backgroundColor: accentColor, borderColor: accentColor)
            : RoundedThickOutlineContainer()
    }
}

private extension Gender {
    var icon: ImageAsset {
        switch self {
        case .male:
            return Asset.genderSignMale
        case .female:
            return Asset.genderSignFemale
        }
    }
}

#if DEBUG
struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectionView(selection: .constant(.male))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
