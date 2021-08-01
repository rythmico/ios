import SwiftUISugar

extension RythmicoButtonStyle {
    init(
        layout: Layout,
        textStyle: Font.RythmicoTextStyle,
        foregroundColor: StateColor,
        backgroundColor: StateColor,
        borderColor: StateColor,
        opacity: StateOpacity = .init(normal: 1)
    ) {
        self.init(
            shape: .squircle(radius: 4, style: .continuous),
            layout: layout,
            mapTitle: { AnyView($0.rythmicoTextStyle(textStyle)) },
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            opacity: opacity
        )
    }

    static func primary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout.map(expansive: .subheadlineBold, constrainedS: .bodyBold, constrainedXS: .calloutBoldWide),
            foregroundColor: .init(normal: .rythmico.white, pressed: .rythmico.inverted(\.foreground)),
            backgroundColor: .init(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
            borderColor: .init(normal: .clear)
        )
    }

    static func secondary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout.map(expansive: .subheadlineMedium, constrainedS: .bodyMedium, constrainedXS: .calloutBoldWide),
            foregroundColor: .init(normal: .rythmico.picoteeBlue, pressed: .rythmico.white),
            backgroundColor: .init(normal: .clear, pressed: .rythmico.picoteeBlue),
            borderColor: .init(normal: .rythmico.picoteeBlue)
        )
    }

    static func tertiary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout.map(expansive: .subheadlineMedium, constrainedS: .bodyMedium, constrainedXS: .calloutBoldWide),
            foregroundColor: .init(normal: .rythmico.picoteeBlue),
            backgroundColor: .init(normal: .clear, pressed: .rythmico.outline),
            borderColor: .init(normal: .rythmico.outline)
        )
    }

    static func quaternary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: .bodyMedium,
            foregroundColor: .init(normal: .rythmico.foreground),
            backgroundColor: .init(normal: .clear),
            borderColor: .init(normal: .clear),
            opacity: .init(normal: 1, pressed: 0.5)
        )
    }
}

#if DEBUG
struct Button_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: .grid(4)) {
                allVariants(for: RythmicoButtonStyle.primary)
            }
            VStack(spacing: .grid(4)) {
                allVariants(for: RythmicoButtonStyle.secondary)
            }
            VStack(spacing: .grid(4)) {
                allVariants(for: RythmicoButtonStyle.tertiary)
            }
            VStack(spacing: .grid(4)) {
                allVariants(for: RythmicoButtonStyle.quaternary)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }

    @ViewBuilder
    static func allVariants(for styleFromLayout: (RythmicoButtonStyle.Layout) -> RythmicoButtonStyle) -> some View {
        RythmicoButton("Next", style: styleFromLayout(.constrained(.s)), action: {})
        RythmicoButton("Next", style: styleFromLayout(.constrained(.m)), action: {})
        RythmicoButton("Next", style: styleFromLayout(.expansive), action: {})
        RythmicoButton("Next", style: styleFromLayout(.expansive), action: {}).disabled(true)
    }
}
#endif
