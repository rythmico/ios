import SwiftUI
import Sugar

protocol AddressDetailsContext {
    func setAddress(_ address: Address)
}

struct AddressDetailsView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var addresses: [Address]?
        @Published var selectedAddress: Address?
    }

    private let student: Student
    private let instrument: Instrument
    private let addressProvider: AddressProviderProtocol
    private let context: AddressDetailsContext
    private let keyboardDismisser: KeyboardDismisser

    @ObservedObject var state: ViewState
    @State var isLoading = false
    @State var errorMessage: String?

    init(
        student: Student,
        instrument: Instrument,
        state: ViewState,
        context: AddressDetailsContext,
        addressProvider: AddressProviderProtocol,
        keyboardDismisser: KeyboardDismisser
    ) {
        self.student = student
        self.instrument = instrument
        self.state = state
        self.context = context
        self.addressProvider = addressProvider
        self.keyboardDismisser = keyboardDismisser
    }

    var subtitle: [MultiStyleText.Part] {
        "Enter the address where " + student.name.firstWord?.bold + " will have the " + "\(instrument.name) lessons".bold
    }

    func searchAddresses() {
        isLoading = true
        addressProvider.addresses(withPostcode: state.postcode) { result in
            self.isLoading = false
            switch result {
            case .success(let addresses):
                self.state.addresses = addresses
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
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
                                if isLoading {
                                    ActivityIndicator(style: .medium, color: .rythmicoGray90)
                                    .transition(
                                        AnyTransition
                                            .scale
                                            .combined(with: .opacity)
                                            .animation(
                                                Animation
                                                    .interpolatingSpring(mass: 5, stiffness: 950, damping: 55)
                                                    .speed(2)
                                            )
                                    )
                                }
                                Spacer().frame(width: .spacingExtraSmall)
                            }
                        }
                    }
                    .padding(.horizontal, .spacingMedium)

                    state.addresses.map { addresses in
                        SectionHeaderContentView(
                            title: "Select Address",
                            padding: .init(horizontal: .spacingMedium)
                        ) {
                            ScrollView {
                                AddressSelectionView(
                                    addresses: addresses,
                                    selection: $state.selectedAddress
                                ).padding(.horizontal, .spacingMedium)
                            }
                        }
                        .transition(
                            AnyTransition
                                .opacity
                                .combined(with: .offset(x: 0, y: 25)
                            )
                        )
                    }

                    if state.addresses == nil {
                        Spacer()
                    }
                }
                .accentColor(.rythmicoPurple)

                nextButtonAction.map { action in
                    FloatingView {
                        Button("Next", style: PrimaryButtonStyle(), action: action)
                    }
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: state.addresses)
            .animation(.easeInOut(duration: .durationMedium), value: nextButtonAction != nil)
        }
        .alert(item: $errorMessage) { Alert(title: Text("Error"), message: Text($0)) }
        .onDisappear(perform: keyboardDismisser.dismissKeyboard)
        .onAppear { self.didAppear?(self) }
    }
}

struct AddressDetailsViewPreview: PreviewProvider {
    static var previews: some View {
        let state = AddressDetailsView.ViewState()
        state.addresses = [.stub, .stub, .stub, .stub, .stub, .stub, .stub]
        return AddressDetailsView(
            student: .davidStub,
            instrument: .guitarStub,
            state: state,
            context: RequestLessonPlanContext(),
            addressProvider: AddressProviderStub(result: .success([.stub, .stub, .stub, .stub, .stub, .stub, .stub]), delay: 1),
            keyboardDismisser: UIApplication.shared
        )
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
