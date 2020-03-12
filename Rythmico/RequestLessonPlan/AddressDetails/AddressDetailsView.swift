import SwiftUI
import Sugar

protocol AddressDetailsContext {
    func setAddress(_ address: Address)
}

struct AddressDetailsView: View {
    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var addresses: [Address]?
        @Published var selectedAddress: Address?
    }

    private let student: Student
    private let instrument: Instrument
    private let addressProvider: AddressProviderProtocol
    private let context: AddressDetailsContext
    private let editingCoordinator: EditingCoordinator
    private let dispatchQueue: DispatchQueue?

    @ObservedObject var state: ViewState
    @State var isLoading = false
    @State var errorMessage: String?

    init(
        student: Student,
        instrument: Instrument,
        state: ViewState,
        context: AddressDetailsContext,
        addressProvider: AddressProviderProtocol,
        editingCoordinator: EditingCoordinator,
        dispatchQueue: DispatchQueue?
    ) {
        self.student = student
        self.instrument = instrument
        self.state = state
        self.context = context
        self.addressProvider = addressProvider
        self.editingCoordinator = editingCoordinator
        self.dispatchQueue = dispatchQueue
    }

    var subtitle: [MultiStyleText.Part] {
        "Enter the address where " + student.name.firstWord?.bold + " will have the " + "\(instrument.name) lessons".bold
    }

    func searchAddresses() {
        isLoading = true
        addressProvider.addresses(withPostcode: state.postcode) { result in
            let showResult = {
                self.isLoading = false
                switch result {
                case .success(let addresses):
                    self.state.addresses = addresses
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
            self.dispatchQueue?.async(execute: showResult) ?? showResult()
        }
    }

    var nextButtonAction: Action? {
        state.selectedAddress.map { address in
            { self.context.setAddress(address) }
        }
    }

    var body: some View {
        TitleSubtitleContentView(title: "Address Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                    TitleContentView(title: "Post Code") {
                        ZStack(alignment: .trailing) {
                            CustomTextField(
                                "NW1 7FB",
                                text: $state.postcode,
                                textContentType: .postalCode,
                                autocapitalizationType: .allCharacters,
                                returnKeyType: .search,
                                onCommit: searchAddresses
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                            if isLoading {
                                ActivityIndicator(style: .medium, color: .rythmicoGray90)
                                    .padding(.trailing, .spacingSmall)
                                    .transition(
                                        AnyTransition
                                            .scale
                                            .combined(with: .opacity)
                                            .animation(.interpolatingSpring(mass: 5, stiffness: 950, damping: 55))
                                    )
                            }
                        }
                    }
                    state.addresses.map { addresses in
                        AnyView(
                            SectionHeaderContentView(title: "Select Address") {
                                ScrollView(showsIndicators: false) {
                                    AddressSelectionView(
                                        addresses: addresses,
                                        selection: $state.selectedAddress
                                    )
                                    .inset(.bottom, .spacingMedium)
                                }
                            }
                        )
                    } ?? AnyView(Spacer())
                }
                .accentColor(.rythmicoPurple)

                nextButtonAction.map {
                    FloatingButton(title: "Next", action: $0).padding(.horizontal, -.spacingMedium)
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: nextButtonAction != nil)
        }
        .alert(item: $errorMessage) { Alert(title: Text("Error"), message: Text($0)) }
        .onDisappear(perform: editingCoordinator.endEditing)
    }
}

struct AddressDetailsViewPreview: PreviewProvider {
    static var mockAddress: Address {
        Address(
            latitude: 0,
            longitude: 0,
            line1: "Apartment 22",
            line2: "321 Holloway Road",
            line3: "",
            line4: "",
            city: "London",
            postcode: "N7 9FU",
            country: "England"
        )
    }

    static var previews: some View {
        let state = AddressDetailsView.ViewState()
//        state.addresses = [mockAddress]
        return AddressDetailsView(
            student: Student(
                name: "David",
                dateOfBirth: Date(),
                gender: .male,
                about: ""
            ),
            instrument: Instrument(
                id: "",
                name: "Guitar",
                icon: Image(systemSymbol: ._00Circle)
            ),
            state: state,
            context: RequestLessonPlanContext(),
            addressProvider: AddressProviderStub(result: .success([mockAddress]), delay: 5),
            editingCoordinator: UIApplication.shared,
            dispatchQueue: nil
        ).environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
