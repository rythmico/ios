import SwiftUISugar

struct TutorProfileHeaderView: View {
    let tutor: Tutor

    var body: some View {
        HStack(spacing: .grid(4)) {
            TutorAvatarView(tutor, mode: .original)
                .frame(width: .grid(20), height: .grid(20))
                .withDBSCheck()
            VStack(alignment: .leading, spacing: .grid(1)) {
                Text(tutor.name)
                    .rythmicoTextStyle(.largeTitle)
                    .foregroundColor(.rythmico.foreground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(instruments)
                    .rythmicoTextStyle(.callout)
                    .foregroundColor(.rythmico.foreground)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.horizontal, .grid(5))
    }

    private static let instrumentListFormatter = Current.listFormatter()

    private var instruments: String {
        Self.instrumentListFormatter
            .string(from: tutor.instruments.map(\.standaloneName))
            .replacingOccurrences(of: " and ", with: " & ")
    }
}

#if DEBUG
struct TutorProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TutorProfileHeaderView(tutor: .davidStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
