import StudentDO
import SwiftUIEncore

extension View {
    func onAPIEvent(
        _ event: StudentDTO.KnownAPIEvent,
        listener: APIEventListenerBase<StudentDTO.KnownAPIEvent> = Current.apiEventListener,
        perform action: @escaping () -> Void
    ) -> some View {
        onReceive(
            listener.on(event),
            perform: action
        )
    }
}
