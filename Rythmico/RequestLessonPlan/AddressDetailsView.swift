import SwiftUI

struct AddressDetailsView: View {
    private let context: RequestLessonPlanContextProtocol
    private let student: Student

    init?(context: RequestLessonPlanContextProtocol) {
        guard let student = context.student else {
            return nil
        }
        self.context = context
        self.student = student
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
