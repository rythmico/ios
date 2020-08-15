import SwiftUI

struct BookingApplicationView: View {
    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var privateNote = ""

    var booking: BookingRequest

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section(header: header, footer: footer) {
                        MultilineTextField(
                            "Add a private note...",
                            text: $privateNote,
                            minHeight: .spacingUnit * 20
                        )
                        .padding(.vertical, .spacingUnit)
                    }
                }
                .listStyle(GroupedListStyle())

                FloatingView {
                    Button("Submit Application (coming next)", action: {}).primaryStyle().disabled(true)
                }
            }
            .navigationBarTitle(Text("Application"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Close", action: dismiss))
        }
        .sheetInteractiveDismissal(interactiveDismissalEnabled)
    }

    private var header: Text {
        Text("Add a private note".uppercased())
    }

    private var footer: Text {
        Text("Increase your chances of being selected by sending a private message detailing your experience and how you intend to teach.")
    }

    private var interactiveDismissalEnabled: Bool {
        privateNote.isEmpty
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct BookingApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationView(booking: .stub)
            .environment(\.colorScheme, .dark)
    }
}
#endif
