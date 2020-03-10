import SwiftUI

struct AddressDetailsView: View {
    private let student: Student
    private let instrument: Instrument

    init(
        student: Student,
        instrument: Instrument
    ) {
        self.student = student
        self.instrument = instrument
    }

    var body: some View {
        TitleSubtitleContentView(
            title: "Address Details",
            subtitle: []
        ) {
            VStack {
                Spacer()
                Text("Coming next!").rythmicoFont(.body)
                Spacer()
            }
        }
    }
}
