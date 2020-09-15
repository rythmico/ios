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
                    VStack(spacing: 0) {
                        Text(tab.rawValue.uppercased(with: Current.locale))
                            .rythmicoFont(.calloutBold)
                            .foregroundColor(selection == tab ? .rythmicoPurple : .rythmicoGray90)
                            .padding(.bottom, .spacingSmall)
                        if selection == tab {
                            Capsule(style: .circular)
                                .fill(Color.rythmicoPurple)
                                .frame(height: selectedTabHeight)
                                .matchedGeometryEffect(id: "shown", in: selectionAnimation)
                        } else {
                            Capsule(style: .circular)
                                .hidden()
                                .frame(height: selectedTabHeight)
                                .matchedGeometryEffect(id: "hidden", in: selectionAnimation)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .animation(.rythmicoSpring(duration: .durationShort), value: selection.rawValue)
                    .contentShape(Rectangle())
                    .onTapGesture { selection = tab }
                }
            }
            .padding(.horizontal, .spacingExtraLarge)

            Divider().accentColor(.rythmicoGray20)
        }
    }
}
