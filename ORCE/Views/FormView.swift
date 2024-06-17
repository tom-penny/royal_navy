import SwiftUI

struct FormView: View {
    
    @State var student = ""
    @State var instructor = ""
    @State var course = ""
    @State var grid : Grid?
    
    var handleSubmit : (ExerciseViewModel.Action) -> Void
    var viewModel : FormViewModel = FormViewModel()
    
    var body: some View {
        VStack {
            FormTextField(text: $student, label: "Student ID")
                .padding(.horizontal, 200)
                .padding(.vertical, 5)
            FormTextField(text: $instructor, label: "Instructor ID")
                .padding(.horizontal, 200)
                .padding(.vertical, 5)
            FormTextField(text: $course, label: "Course")
                .padding(.horizontal, 200)
                .padding(.vertical, 5)
            Picker("Grid", selection: $grid) {
                ForEach(viewModel.grids) { grid in
                    Text(grid.accronym).tag(grid as Grid?)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 200)
            .padding(.vertical, 20)
            
            Button("Start") {
                guard !student.isEmpty, !instructor.isEmpty, !course.isEmpty, let grid else { return }
                
                handleSubmit(.createExercise(student: student, instructor: instructor, course: course, grid: grid))
            }
            .buttonStyle(ORCEButtonStyle())
        }
        .padding()
    }
    
    struct FormTextField : View {
        
        @Binding var text : String
        @FocusState var isFocused : Bool
        
        var label : String
        
        var body: some View {
            HStack {
                Text(label)
                    .frame(width: 100)
                    .padding(10)
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                TextField("", text: $text)
                    .padding(10)
                    .autocorrectionDisabled(true)
                    .focused($isFocused)
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Primary"), lineWidth: 2)
            )
        }
    }
}

struct FormView_Previews: PreviewProvider {
    
    @StateObject static var viewModel = ExerciseViewModel()
    
    static var previews: some View {
        FormView(handleSubmit: Self.viewModel.reduce)
    }
}
