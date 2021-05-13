import SwiftUI
import MultiModal
import FoundationSugar

struct ProfileCalendarSyncCell: View {
    @ObservedObject
    private var coordinator = Current.calendarSyncCoordinator

    var body: some View {
        ProfileCell("Calendar Sync", disclosure: disclosure, action: goToCalendarAction, accessory: toggleButton)
            .multiModal {
                $0.alert(item: promptBinding)
                $0.alert(error: error, dismiss: dismissError)
            }
    }

    var disclosure: Bool {
        coordinator.enableCalendarSyncAction == nil
    }

    var goToCalendarAction: Action? {
        coordinator.goToCalendarAction
    }

    @ViewBuilder
    private func toggleButton() -> some View {
        if coordinator.isSyncingCalendar {
            ActivityIndicator()
        } else if let action = enableAction {
            Toggle("", isOn: .constant(coordinator.isSyncingCalendar))
                .labelsHidden()
                .onTapGesture(perform: action)
        }
    }

    var enableAction: Action? {
        coordinator.enableCalendarSyncAction
    }

    var promptBinding: Binding<Alert?> {
        $coordinator.permissionsNeededAlert
    }

    var error: Error? {
        coordinator.error
    }

    func dismissError() {
        coordinator.dismissError()
    }
}
