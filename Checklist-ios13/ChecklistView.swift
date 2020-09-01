import SwiftUI

struct ChecklistView: View {

    // Properties
    // ==========

    @ObservedObject var checklist = Checklist()
    @State var newChecklistItemViewIsVisible = false

    // User interface content and layout
    var body: some View {
        NavigationView {
            List {
                ForEach(checklist.items) { checklistItem in
                    HStack {
                        Text(checklistItem.name)
                        Spacer()
                        Text(checklistItem.isChecked ? "✅" : "🔲")
                    }
                            .background(Color.black) // This makes the entire row clickable
                            .onTapGesture {
                                if let matchingIndex =
                                self.checklist.items.firstIndex(where: { $0.id == checklistItem.id }) {
                                    self.checklist.items[matchingIndex].isChecked.toggle()
                                }
                                self.checklist.printChecklistContents()
                            }
                }
                        .onDelete(perform: checklist.deleteListItem)
                        .onMove(perform: checklist.moveListItem)
            }
                    .navigationBarItems(
                            leading: Button(action: { self.newChecklistItemViewIsVisible = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add items")
                                }
                            },
                            trailing: EditButton()
                    )
                    .navigationBarTitle("Checklist")
                    .onAppear() {
                        self.checklist.printChecklistContents()
                    }
        }
        .sheet(isPresented: $newChecklistItemViewIsVisible) {
            NewChecklistItemView(checklist: self.checklist)
        }

    }




}

// Preview
// =======
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}