import SwiftUISugar

struct AddressDetailsView: View, TestableView {
    typealias SearchCoordinator = APIActivityCoordinator<AddressSearchRequest>

    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var selectedAddress: Address?
    }

    var student: Student
    var instrument: Instrument
    @ObservedObject
    private(set) var state: ViewState
    @ObservedObject
    private(set) var coordinator: SearchCoordinator
    var setter: Binding<Address>.Setter

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter the address where"
        if let studentName = student.name.firstWord {
            studentName.text.rythmicoFontWeight(.bodyBold)
        } else {
            "the student"
        }
        "will have the"
        "\(instrument.assimilatedName) lessons".text.rythmicoFontWeight(.bodyBold)
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var addresses: [Address]? { coordinator.state.successValue.map([Address].init) }

    func searchAddresses() {
        coordinator.run(with: .init(postcode: state.postcode))
    }

    var nextButtonAction: Action? {
        state.selectedAddress.map { address in
            { setter(address) }
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Address Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .grid(5)) {
                        Group {
                            InfoBanner(text: "You can also arrange for online lessons. Just let your prospective tutor know about your preference in the final step.")
                            HeaderContentView(title: "Postcode", titleAccessory: {
                                InfoDisclaimerButton(
                                    title: "Why Postcode?",
                                    message: "We only show prospective tutors the postcode area, so they have a better idea of where they need to travel to."
                                )
                            }) {
                                ZStack {
                                    Container(style: .field) {
                                        CustomTextField(
                                            "NW1 7FB",
                                            text: $state.postcode,
                                            inputMode: KeyboardInputMode(contentType: .postalCode, autocapitalization: .allCharacters, returnKey: .search),
                                            onCommit: searchAddresses
                                        )
                                    }
                                    HStack {
                                        Spacer()
                                        if isLoading {
                                            ActivityIndicator(color: .rythmico.foreground)
                                        }
                                        Spacer().frame(width: .grid(3))
                                    }
                                }
                            }
                        }

                        if let addresses = addresses {
                            SectionHeaderContentView(title: "Select Address") {
                                SelectableList(
                                    data: addresses,
                                    id: \.self,
                                    selection: $state.selectedAddress,
                                    content: \.condensedFormattedString
                                )
                            }
                            .transition(.offset(y: 25) + .opacity)
                        } else {
                            Spacer()
                        }
                    }
                    .accentColor(.rythmico.picoteeBlue)
                    .frame(maxWidth: .grid(.max))
                    .padding([.trailing, .bottom], .grid(5))
                }
                .padding(.leading, .grid(5))

                nextButtonAction.map { action in
                    FloatingView {
                        RythmicoButton("Next", style: .primary(), action: action)
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
            coordinator: Current.addressSearchCoordinator(),
            setter: { _ in }
        )
    }
}
#endif
