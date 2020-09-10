import SwiftUI
import Sugar

protocol AddressDetailsContext {
    func setAddress(_ address: Address)
}

struct AddressDetailsView: View, TestableView {
    typealias SearchCoordinator = APIActivityCoordinator<AddressSearchRequest>

    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var selectedAddress: Address?
    }

    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory

    private let student: Student
    private let instrument: Instrument
    @ObservedObject
    private(set) var state: ViewState
    @ObservedObject
    private(set) var coordinator: SearchCoordinator
    private let context: AddressDetailsContext

    init(
        student: Student,
        instrument: Instrument,
        state: ViewState,
        coordinator: SearchCoordinator,
        context: AddressDetailsContext
    ) {
        self.student = student
        self.instrument = instrument
        self.state = state
        self.coordinator = coordinator
        self.context = context
    }

    var subtitle: [MultiStyleText.Part] {
        (UIScreen.main.isLarge && !sizeCategory._isAccessibilityCategory) || addresses?.isEmpty != false
            ? "Enter the address where " + student.name.firstWord?.style(.bodyBold) + " will have the " + "\(instrument.name) lessons".style(.bodyBold)
            : .empty
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var addresses: [Address]? { coordinator.state.successValue.map([Address].init) }

    func searchAddresses() {
        coordinator.run(with: .init(postcode: state.postcode))
    }

    var nextButtonAction: Action? {
        state.selectedAddress.map { address in
            { context.setAddress(address) }
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Address Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                    HeaderContentView(title: "Post Code") {
                        ZStack {
                            CustomTextField(
                                "NW1 7FB",
                                text: $state.postcode,
                                textContentType: .postalCode,
                                autocapitalizationType: .allCharacters,
                                returnKeyType: .search,
                                onCommit: searchAddresses
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                            HStack {
                                Spacer()
                                if isLoading {
                                    ActivityIndicator(style: .medium, color: .rythmicoGray90)
                                    .transition(
                                        AnyTransition
                                            .scale
                                            .animation(.rythmicoSpring(duration: .durationShort, type: .damping))
                                    )
                                }
                                Spacer().frame(width: .spacingExtraSmall)
                            }
                        }
                    }
                    .padding(.horizontal, .spacingMedium)

                    addresses.map { addresses in
                        SectionHeaderContentView(
                            title: "Select Address",
                            padding: .init(horizontal: .spacingMedium)
                        ) {
                            ScrollView {
                                AddressSelectionView(
                                    addresses: addresses,
                                    selection: $state.selectedAddress
                                ).padding([.trailing, .bottom], .spacingMedium)
                            }
                            .padding(.leading, .spacingMedium)
                        }
                        .transition(
                            AnyTransition
                                .opacity
                                .combined(with: .offset(x: 0, y: 25)
                            )
                        )
                    }

                    if addresses == nil {
                        Spacer()
                    }
                }
                .accentColor(.rythmicoPurple)

                nextButtonAction.map { action in
                    FloatingView {
                        Button("Next", action: action).primaryStyle()
                    }
                }
            }
            .animation(.rythmicoSpring(duration: .durationMedium), value: nextButtonAction != nil)
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: addresses)
        .alertOnFailure(coordinator)
        .testable(self)
        .onDisappear(perform: Current.keyboardDismisser.dismissKeyboard)
    }
}

private extension Array where Element == Address {
    init(_ response: AddressSearchRequest.Response) {
        self = response.addresses.map {
            Address(
                latitude: response.latitude,
                longitude: response.longitude,
                line1: $0.line1, line2: $0.line2,
                line3: $0.line3, line4: $0.line4,
                city: $0.city,
                postcode: response.postcode,
                country: $0.country
            )
        }
    }
}

#if DEBUG
struct AddressDetailsViewPreview: PreviewProvider {
    static var previews: some View {
        let state = AddressDetailsView.ViewState()
        state.selectedAddress = .stub

        return AddressDetailsView(
            student: .davidStub,
            instrument: .guitar,
            state: state,
            coordinator: Current.coordinator(for: \.addressSearchService)!,
            context: RequestLessonPlanContext()
        )
        .previewDevices()
    }
}
#endif
