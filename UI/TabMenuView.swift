import SwiftUI

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
                        .rythmicoTextStyle(.calloutBold)
                        .foregroundColor(selection == tab ? .rythmico.purple : .rythmico.gray90)
                        .frame(maxWidth: .infinity, minHeight: .grid(13), alignment: .center)
                        .background(
                            Group {
                                if selection == tab {
                                    Capsule(style: .circular)
                                        .fill(Color.rythmico.purple)
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
            .padding(.horizontal, .grid(5))

            Divider().overlay(Color.rythmico.gray20)
        }
    }
}

#if DEBUG
struct TabMenuViewPreviewContent: View {
    enum Tab: String, CaseIterable {
        case x, y, z
    }

    @State
    private var selectedTab: Tab = .x

    var body: some View {
        TabMenuView(tabs: Tab.allCases, selection: $selectedTab)
    }
}

struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuViewPreviewContent()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
