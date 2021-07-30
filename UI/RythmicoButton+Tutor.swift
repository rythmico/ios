import SwiftUISugar

extension RythmicoButtonStyle {
    init(
        layout: Layout,
        font: Font,
        foregroundColor: StateColor,
        backgroundColor: StateColor,
        borderColor: StateColor,
        opacity: StateOpacity = .default
    ) {
        self.init(
            layout: layout,
            mapTitle: { AnyView($0.font(font)) },
            cornerStyle: .init(rounding: .continuous, radius: 8),
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            opacity: opacity
        )
    }

    static func primary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            font: .body.weight(.semibold),
            foregroundColor: .init(normal: .white, pressed: .white),
            backgroundColor: .init(normal: .blue, pressed: .blue),
            borderColor: .init(normal: .clear, pressed: .clear)
        )
    }

    static func secondary(layout: Layout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            font: .body.weight(.semibold),
            foregroundColor: .init(normal: .blue, pressed: .white),
            backgroundColor: .init(normal: .clear, pressed: .blue),
            borderColor: .init(normal: .blue, pressed: .blue)
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
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }

    @ViewBuilder
    static func allVariants(for styleFromLayout: (RythmicoButtonStyle.Layout) -> RythmicoButtonStyle) -> some View {
        RythmicoButton("Next", style: styleFromLayout(.contrained(.small)), action: {})
        RythmicoButton("Next", style: styleFromLayout(.contrained(.medium)), action: {})
        RythmicoButton("Next", style: styleFromLayout(.expansive), action: {})
        RythmicoButton("Next", style: styleFromLayout(.expansive), action: {}).disabled(true)
    }
}
#endif
