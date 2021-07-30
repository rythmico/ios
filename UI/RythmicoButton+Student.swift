import SwiftUISugar

extension RythmicoButtonStyle {
    init(
        layout: Layout,
        textStyle: Font.RythmicoTextStyle,
        foregroundColor: StateColor,
        backgroundColor: StateColor,
        borderColor: StateColor,
        opacity: StateOpacity = .default
    ) {
        self.init(
            layout: layout,
            mapTitle: { AnyView($0.rythmicoTextStyle(textStyle)) },
            cornerStyle: .init(rounding: .continuous, radius: 4),
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            opacity: opacity
        )
    }

    static func primary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout == .contrained(.small) ? .bodyBold : .subheadlineBold,
            foregroundColor: .init(normal: .rythmico.white),
            backgroundColor: .init(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
            borderColor: .init(normal: .clear)
        )
    }

    static func secondary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout == .contrained(.small) ? .bodyMedium : .subheadlineMedium,
            foregroundColor: .init(normal: .rythmico.picoteeBlue, pressed: .rythmico.white),
            backgroundColor: .init(normal: .clear, pressed: .rythmico.picoteeBlue),
            borderColor: .init(normal: .rythmico.picoteeBlue)
        )
    }

    static func tertiary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            textStyle: layout == .contrained(.small) ? .bodyMedium : .subheadlineMedium,
            foregroundColor: .init(normal: .rythmico.foreground),
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
                RythmicoButton("Next", style: .primary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: .primary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: .primary(), action: {})
                RythmicoButton("Next", style: .primary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: .secondary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: .secondary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: .secondary(), action: {})
                RythmicoButton("Next", style: .secondary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: .tertiary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: .tertiary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: .tertiary(), action: {})
                RythmicoButton("Next", style: .tertiary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: .quaternary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: .quaternary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: .quaternary(), action: {})
                RythmicoButton("Next", style: .quaternary(), action: {}).disabled(true)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
