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
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
