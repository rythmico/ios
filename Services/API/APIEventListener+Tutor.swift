import TutorDO
import SwiftUIEncore

extension View {
    func onAPIEvent(
        _ event: TutorDTO.KnownAPIEvent,
        listener: APIEventListenerBase<TutorDTO.KnownAPIEvent> = Current.apiEventListener,
        perform action: @escaping () -> Void
    ) -> some View {
        onReceive(
            listener.on(event),
            perform: action
        )
    }
}
