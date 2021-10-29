import CoreDTO
import StudentDTO
import SwiftUIEncore

struct ReviewRequestView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    var coordinator: Coordinator
    var flow: RequestLessonPlanFlow
    var instrument: Instrument
    var student: Student
    var address: AddressLookupItem
    var schedule: Schedule
    var privateNote: String

    func submitRequest() {
        coordinator.run(
            with: .init(
                instrument: instrument,
                student: student,
                address: address,
                schedule: schedule,
                privateNote: privateNote
            )
        )
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView("Review Proposal", spacing: .grid(5)) { _ in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: .grid(4)) {
                        SectionHeaderContentView(
                            "Chosen Instrument",
                            style: .box,
                            accessory: { editButton(action: resetInstrument) }
                        ) {
                            InstrumentView(instrument: instrument)
                        }

                        SectionHeaderContentView(
                            "Student Details",
                            style: .box,
                            accessory: { editButton(action: resetStudentDetails) }
                        ) {
                            RythmicoLabel(asset: Asset.Icon.Label.info, title: Text(studentDetails)) {
                                studentAbout.padding(.top, .grid(2))
                            }
                        }

                        SectionHeaderContentView(
                            "Address Details",
                            style: .box,
                            accessory: { editButton(action: resetAddressDetails) }
                        ) {
                            Text(address.condensedFormattedString)
                                .rythmicoTextStyle(.body)
                                .foregroundColor(.rythmico.foreground)
                        }

                        SectionHeaderContentView(
                            "Lesson Schedule",
                            style: .box,
                            accessory: { editButton(action: resetSchedule) }
                        ) {
                            LessonPlanRequestedScheduleView(schedule, tutor: nil)
                        }

                        SectionHeaderContentView(
                            "Private Note",
                            style: .box,
                            accessory: { editButton(action: resetPrivateNote) }
                        ) {
                            privateNoteView
                        }
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding(.trailing, .grid(4))
                    .padding(.bottom, .grid(5))
                }
                .padding(.leading, .grid(4))

                FloatingView {
                    RythmicoButton("Confirm Details", style: .primary(), action: submitRequest)
                }
            }
        }
        .testable(self)
    }

    private func editButton(action: @escaping Action) -> some View {
        RythmicoButton(
            "EDIT",
            style: .tertiary(layout: .constrained(.xs)),
            action: action
        )
    }

    private func resetInstrument() { flow.instrument = nil }
    private func resetStudentDetails() { flow.student = nil }
    private func resetAddressDetails() { flow.address = nil }
    private func resetSchedule() { flow.schedule = nil }
    private func resetPrivateNote() { flow.privateNote = nil }

    private var studentDetails: String {
        [
            student.name,
            studentAge(from: student.dateOfBirth),
        ].filter(\.isEmpty.not).joined(separator: .newline)
    }

    private func studentAge(from dateOfBirth: DateOnly) -> String {
        let dateOfBirthString = dateOfBirth.formatted(style: .short, locale: Current.locale())
        let age = try! Current.dateOnly() - (dateOfBirth, .year)
        return [dateOfBirthString, "(\(age) years old)"].compacted().spaced()
    }

    @ViewBuilder
    private var studentAbout: some View {
        if let about = student.about.nilIfBlank {
            Text(separator: .newline) {
                Text(["About", student.name.firstWord].compacted().spaced() + .colon)
                    .rythmicoFontWeight(.bodyMedium)
                about
            }
            .rythmicoTextStyle(.body)
        }
    }

    @ViewBuilder
    private var privateNoteView: some View {
        if let privateNote = privateNote.nilIfBlank {
            Text(privateNote)
                .rythmicoTextStyle(.body)
                .foregroundColor(.rythmico.foreground)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text("No private note.")
                .rythmicoTextStyle(.body)
                .foregroundColor(.rythmico.textPlaceholder)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture(perform: resetPrivateNote)
        }
    }
}

#if DEBUG
struct ReviewRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestView(
            coordinator: Current.lessonPlanRequestCoordinator(),
            flow: RequestLessonPlanFlow(),
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
        )
        .background(Color.rythmico.backgroundSecondary.edgesIgnoringSafeArea(.all))
//        .environment(\.colorScheme, .dark)
    }
}
#endif
