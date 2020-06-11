import SwiftUI
import Sugar

protocol AddressDetailsContext {
    func setAddress(_ address: AddressDetails)
}

struct AddressDetailsView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var selectedAddress: AddressDetails?
    }

    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory

    private let student: Student
    private let instrument: Instrument
    @ObservedObject
    private var state: ViewState
    @ObservedObject
    private var coordinator: AddressSearchCoordinator
    private let context: AddressDetailsContext

    init(
        student: Student,
        instrument: Instrument,
        state: ViewState,
        searchCoordinator: AddressSearchCoordinator,
        context: AddressDetailsContext
    ) {
        self.student = student
        self.instrument = instrument
        self.state = state
        self.coordinator = searchCoordinator
        self.context = context
    }

    var subtitle: [MultiStyleText.Part] {
        (UIScreen.main.isLarge && !sizeCategory._isAccessibilityCategory) || addresses?.isEmpty != false
            ? "Enter the address where " + student.name.firstWord?.bold + " will have the " + "\(instrument.name) lessons".bold
            : .empty
    }

    private var addresses: [AddressDetails]? {
        coordinator.state.successValue
    }

    func searchAddresses() {
        coordinator.searchAddresses(withPostcode: state.postcode)
    }

    var nextButtonAction: Action? {
        state.selectedAddress.map { address in
            { self.context.setAddress(address) }
        }
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Address Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                    TitleContentView(title: "Post Code") {
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
                                if coordinator.state.isLoading {
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
        .alert(error: self.coordinator.state.failureValue, dismiss: coordinator.dismissError)
        .onAppear { self.didAppear?(self) }
    }
}

struct AddressDetailsViewPreview: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        let searchCoordinator = Current.addressSearchCoordinator()!
        searchCoordinator.state = .success([.stub])

        let state = AddressDetailsView.ViewState()
        state.selectedAddress = .stub

        return AddressDetailsView(
            student: .davidStub,
            instrument: .guitar,
            state: state,
            searchCoordinator: searchCoordinator,
            context: RequestLessonPlanContext()
        )
        .previewDevices()
    }
}
