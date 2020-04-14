import SwiftUI
import Sugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

struct SchedulingView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var duration: Duration?
    }

    @ObservedObject private(set) var state: ViewState

    enum EditingFocus {
        case none
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus = .none

    private let instrument: Instrument
    private let context: SchedulingContext
    private let dateFormatter = DateFormatter().then { $0.dateFormat = "EEEE d MMMM" }
    private let timeFormatter = DateFormatter().then { $0.dateFormat = "H:mm" }

    init(
        instrument: Instrument,
        state: ViewState,
        context: SchedulingContext
    ) {
        self.instrument = instrument
        self.state = state
        self.context = context
    }

    var subtitle: [MultiStyleText.Part] {
        "Enter when you want the " + "\(instrument.name) lessons".bold + " to commence and for how long"
    }

    var startDateText: String { state.startDate.map(dateFormatter.string(from:)) ?? .empty }
    var startTimeText: String { state.startDate.map(timeFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration?.title ?? .empty }

    var nextButtonAction: Action? {
        guard
            let startDate = state.startDate,
            let duration = state.duration
        else {
            return nil
        }

        return {
            self.context.setSchedule(
                Schedule(startDate: startDate, duration: duration)
            )
        }
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        TitleContentView(title: "Start Date") {
                            CustomTextField(
                                "Select a date...",
                                text: .constant(startDateText),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture { self.startDateEditingChanged(true) }
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            TitleContentView(title: "Time") {
                                CustomTextField(
                                    "Start time...",
                                    text: .constant(startTimeText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture { self.startTimeEditingChanged(true) }
                            }

                            TitleContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture { self.durationEditingChanged(true) }
                            }
                        }

                        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                            Text("Please note:").rythmicoFont(.callout)
                            Text("Monday-Friday lessons £60 per 45-60 min.").rythmicoFont(.body)
                            Text("Weekend lessons £65 per 45-60 min.").rythmicoFont(.body)
                        }
                    }
                    .inset(.bottom, .spacingMedium)
                    .onBackgroundTapGesture(perform: endEditingAllFields)
                }

                ZStack(alignment: .bottom) {
                    nextButtonAction.map {
                        FloatingButton(title: "Next", action: $0).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isStartDate {
                        FloatingDatePicker(
                            selection: Binding(
                                get: { self.state.startDate ?? Date() },
                                set: { self.state.startDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute],
                            doneButtonAction: { self.startDateEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isStartTime {
                        FloatingDatePicker(
                            selection: Binding(
                                get: { self.state.startDate ?? Date() },
                                set: { self.state.startDate = $0 }
                            ),
                            displayedComponents: .hourAndMinute,
                            doneButtonAction: { self.startDateEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isDuration {
                        FloatingPicker(
                            selection: Binding(
                                get: { self.state.duration ?? .fortyFiveMinutes },
                                set: { self.state.duration = $0 }
                            ),
                            doneButtonAction: { self.durationEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        }
        .onAppear { self.didAppear?(self) }
    }

    func startDateEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .startDate : .none

        if isEditing, state.startDate == nil {
            state.startDate = Date()
        }
    }

    func startTimeEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .startTime : .none

        if isEditing, state.startDate == nil {
            state.startDate = Date()
        }
    }

    func durationEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .duration : .none

        if isEditing, state.duration == nil {
            state.duration = .fortyFiveMinutes
        }
    }

    func endEditingAllFields() {
        editingFocus = .none
    }
}

struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            instrument: .guitarStub,
            state: .init(),
            context: RequestLessonPlanContext()
        ).environment(\.locale, .init(identifier: "en_GB"))
    }
}
