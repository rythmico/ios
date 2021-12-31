import SwiftUIEncore
import TutorDTO

struct LessonPlanApplicationGroupCell: View {
    @Environment(\.isEnabled) private var isEnabled

    private let status: LessonPlanApplication.Status
    private let applicationCount: Int

    init(status: LessonPlanApplication.Status, applications: [LessonPlanApplication]) {
        self.status = status
        self.applicationCount = applications.filter { $0.status == status }.count
    }

    var body: some View {
        HStack(spacing: .grid(4)) {
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(accessory)
                .foregroundColor(.secondary)
                .font(.body)
        }
        .cellAccessory(.disclosure)
        .opacity(isEnabled ? 1 : 0.3)
    }

    private var title: String {
        status.title
    }

    private var accessory: String {
        String(applicationCount)
    }
}

#if DEBUG
struct LessonPlanApplicationGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        // TODO: upcoming
//        LessonPlanApplicationGroupCell(status: .selected, applications: [])
//            .padding(.horizontal, .grid(3))
//            .previewLayout(.sizeThatFits)
    }
}
#endif
