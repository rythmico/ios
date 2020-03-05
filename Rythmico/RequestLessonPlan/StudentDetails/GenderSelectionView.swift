import SwiftUI

struct GenderSelectionView: View {
    @Binding var selection: Gender?

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Gender.allCases, id: \.self) { gender in
                HStack(spacing: 0) {
                    Text(gender.name)
                        .rythmicoFont(self.textStyle(for: gender))
                        .foregroundColor(self.textColor(for: gender))
                        .animation(.none)
                    Spacer()
                    gender.icon
                        .renderingMode(.template)
                        .foregroundColor(self.iconColor(for: gender))
                }
                .modifier(
                    self.containerModifier(for: gender)
                        .animation(.easeInOut(duration: .durationShort))
                )
                .contentShape(Rectangle())
                .onTapGesture { self.selection = gender }
            }
        }
    }

    private func textColor(for gender: Gender) -> Color {
        selection == gender ? .accentColor : .rythmicoForeground
    }

    private func textStyle(for gender: Gender) -> Font.TextStyle {
        selection == gender ? .callout : .body
    }

    private func iconColor(for gender: Gender) -> Color {
        selection == gender ? .accentColor : .rythmicoGray90
    }

    private func containerModifier(for gender: Gender) -> RoundedThickOutlineContainer {
        selection == gender
            ? RoundedThickOutlineContainer(backgroundColor: .accentColor, borderColor: .accentColor)
            : RoundedThickOutlineContainer()
    }
}

private extension Gender {
    var name: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }

    var icon: Image {
        switch self {
        case .male:
            return Image(decorative: Asset.genderSignMale.name)
        case .female:
            return Image(decorative: Asset.genderSignFemale.name)
        }
    }
}
