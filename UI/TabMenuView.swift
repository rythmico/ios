import SwiftUIEncore

// TODO: implement as Picker with custom PickerStyle, maybe someday when API is open.
struct TabMenuView<Tab: RawRepresentable>: View where Tab.RawValue == String {
    var tabs: [Tab]
    @Binding
    var selection: Tab
    private let selectedTabHeight: CGFloat = 2
    @Namespace
    private var selectionAnimation

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Text(tab.rawValue.uppercased(with: Current.locale))
                        .rythmicoTextStyle(.calloutBoldWide)
                        .foregroundColor(selection == tab ? .rythmico.picoteeBlue : .rythmico.foreground)
                        .frame(maxWidth: .infinity, minHeight: .grid(13), alignment: .center)
                        .background(
                            Group {
                                if selection == tab {
                                    Capsule(style: .circular)
                                        .fill(Color.rythmico.picoteeBlue)
                                        .frame(height: selectedTabHeight)
                                        .matchedGeometryEffect(id: "selection", in: selectionAnimation)
                                }
                            },
                            alignment: .bottom
                        )
                        .animation(.rythmicoSpring(duration: .durationShort), value: selection.rawValue)
                        .contentShape(Rectangle())
                        .onTapGesture { selection = tab }
                }
            }
            .frame(maxWidth: .grid(.max))
            .padding(TitleContentViewHorizontalPadding)

            HDivider()
        }
    }
}

#if DEBUG
struct TabMenuView_Previews: PreviewProvider {
    enum Tab: String, CaseIterable {
        case x, y, z
    }

    static var previews: some View {
        StatefulView(Tab.x) { $selectedTab in
            TabMenuView(tabs: Tab.allCases, selection: $selectedTab)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
