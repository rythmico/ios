import StudentDTO
import SwiftUIEncore

struct AddressDetailsView: View, TestableView {
    typealias SearchCoordinator = APIActivityCoordinator<AddressSearchRequest>

    final class ViewState: ObservableObject {
        @Published var postcode = String()
        @Published var selectedAddress: AddressLookupItem?
    }

    var student: Student
    var instrument: Instrument
    @ObservedObject
    private(set) var state: ViewState
    @ObservedObject
    private(set) var coordinator: SearchCoordinator
    var setter: Binding<AddressLookupItem>.Setter

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter the address where"
        if let studentName = student.name.firstWord {
            studentName.text.rythmicoFontWeight(.subheadlineMedium)
        } else {
            "the student"
        }
        "will have the"
        "\(instrument.assimilatedName) lessons".text.rythmicoFontWeight(.subheadlineMedium)
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { postcodeError ?? coordinator.output?.error }
    var addresses: [AddressLookupItem]? { coordinator.output?.value }

    @State
    private(set) var postcodeError: Error?

    func searchAddresses() {
        do {
            try coordinator.run(with: .init(postcode: state.postcode))
        } catch {
            self.postcodeError = error
        }
    }

    var nextButtonAction: Action? {
        state.selectedAddress.mapToAction(setter)
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView("Address Details", subtitle) { padding in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .grid(5)) {
                        Group {
                            InfoBanner(text: "You can also arrange for online lessons. Just let your prospective tutor know about your preference in the final step.")
                            TextFieldHeader("Postcode", accessory: {
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
                                            inputMode: .keyboard(contentType: .postalCode, autocapitalization: .allCharacters, returnKey: .search),
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
                            SectionHeaderContentView("Select Address", style: .plain) {
                                ChoiceList(
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
                    .padding([.trailing, .bottom], padding.trailing)
                }
                .padding(.leading, padding.leading)

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

#if DEBUG
struct AddressDetailsViewPreview: PreviewProvider {
    static var previews: some View {
        let state = AddressDetailsView.ViewState()
        state.selectedAddress = .stub

        return AddressDetailsView(
            student: .davidStub,
            instrument: .stub(.guitar),
            state: state,
            coordinator: Current.addressSearchCoordinator(),
            setter: { _ in }
        )
    }
}
#endif
