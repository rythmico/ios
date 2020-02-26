import SwiftUI
import ViewModel
import KeyboardObserver
import Sugar

struct StudentDetailsViewData {
    var isEditing: Bool
    var selectedInstrumentName: String
    var nameTextFieldViewData: TextFieldViewData
    var dateOfBirthTextFieldViewData: TextFieldViewData
    var datePickerViewData: DatePickerViewData?
    var genderSelection: Binding<Gender?>
    var aboutNameTextPart: MultiStyleText.Part
    var aboutTextFieldViewData: TextFieldViewData
    var nextButtonAction: Action?
}

struct StudentDetailsView: View, ViewModelable {
    @ObservedObject var viewModel: StudentDetailsViewModel

    var body: some View {
        ZStack {
            TitleSubtitleContentView(
                title: "Student Details",
                subtitle: !viewData.isEditing ? subtitle : []
            ) {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: .spacingLarge) {
                                TitleContentView(title: "Full Name") {
                                    TextField(self.viewData.nameTextFieldViewData)
                                        .textContentType(.name)
                                        .autocapitalization(.words)
                                        .rythmicoFont(.body)
                                        .accentColor(.rythmicoPurple)
                                        .modifier(RoundedThinOutlineContainer())
                                }
                                TitleContentView(title: "Date of Birth") {
                                    TextField(self.viewData.dateOfBirthTextFieldViewData)
                                        .rythmicoFont(.body)
                                        .modifier(RoundedThinOutlineContainer())
                                }
                                TitleContentView(title: "Gender") {
                                    GenderSelectionView(selection: self.viewData.genderSelection)
                                }
                                TitleContentView(title: [.init("About "), self.viewData.aboutNameTextPart]) {
                                    MultilineTextField(self.viewData.aboutTextFieldViewData)
                                        .accentColor(.rythmicoPurple)
                                        .modifier(RoundedThinOutlineContainer())
                                }
                            }
                            Rectangle().fill(Color.clear).frame(height: .spacingMedium)
                        }
                    }
                    .avoidingKeyboard()

                    ZStack {
                        self.viewData.nextButtonAction.map {
                            FloatingButton(title: "Next", action: $0)
                            .padding(.horizontal, -.spacingMedium)
                        }

                        self.viewData.datePickerViewData.map {
                            FloatingDatePicker(
                                viewData: $0,
                                doneButtonAction: self.viewModel.endEditingDateOfBirth
                            )
                            .padding(.horizontal, -.spacingMedium)
                        }
                    }
                }
                .animation(.easeInOut(duration: .durationMedium), value: self.viewData.datePickerViewData != nil)
                .animation(.easeInOut(duration: .durationShort), value: self.viewData.nextButtonAction != nil)
            }
            .animation(.easeInOut(duration: .durationMedium), value: viewData.isEditing)
        }
        .onDisappear(perform: UIApplication.shared.endEditing)
    }

    var subtitle: [MultiStyleText.Part] {
        [.init("Enter the details of the student who will learn "), .init(viewData.selectedInstrumentName, weight: .bold)]
    }
}

struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        StudentDetailsView(
            viewModel: StudentDetailsViewModel(
                context: RequestLessonPlanContext(),
                instrument: Instrument(id: "Piano", name: "Piano", icon: Image(decorative: Asset.instrumentIconPiano.name)),
                editingCoordinator: UIApplication.shared
            )
        )
    }
}
