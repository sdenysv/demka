import SwiftUI

struct HelpView: View {
    @EnvironmentObject var vm: DeckViewModel
    @Environment(\.dismiss) private var dismiss

    private let gestures: [(String, String)] = [
        ("Tap card",           "Activate card / start presenting"),
        ("Swipe left / Tap",   "Next bullet, then next card"),
        ("Swipe right",        "Previous card"),
        ("Swipe down",         "Exit presentation"),
        ("Drag canvas",        "Pan"),
        ("Pinch",              "Zoom in / out"),
        ("→ Edit / ← Edit",   "Switch between editor and deck"),
        ("Present button",     "Enter presentation mode"),
        ("⊞ Fit button",       "Fit all cards on screen"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Gestures
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Gestures")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundColor(vm.theme.mute)
                            .padding(.bottom, 10)

                        ForEach(gestures, id: \.0) { gesture, desc in
                            HStack(alignment: .top, spacing: 16) {
                                Text(gesture)
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundColor(vm.theme.ink)
                                    .frame(width: 150, alignment: .leading)
                                Text(desc)
                                    .font(.system(size: 13))
                                    .foregroundColor(vm.theme.ink2)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            Divider().background(vm.theme.line)
                        }
                    }

                    // Layout modes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Layout modes")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundColor(vm.theme.mute)

                        layoutRow(.timeline, name: "Timeline",
                                  desc: "Horizontal spine with H1/H2 nodes; H3 hangs below")
                        layoutRow(.map, name: "Map",
                                  desc: "Mind-map: H1 center, H2s split left/right")
                        layoutRow(.logic, name: "Logic",
                                  desc: "Left-to-right tree")
                    }

                    // Version
                    HStack {
                        Spacer()
                        Text("demka for iOS · v1.0")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(vm.theme.mute)
                        Spacer()
                    }
                }
                .padding(24)
            }
            .background(vm.theme.surface.ignoresSafeArea())
            .navigationTitle("demka — help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(vm.theme.active)
                }
            }
        }
        .preferredColorScheme(vm.theme.name == "Stone" ? .light : .dark)
    }

    @ViewBuilder
    private func layoutRow(_ mode: ViewMode, name: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ViewModeIcon(mode: mode, color: vm.theme.active)
                .frame(width: 24, height: 17)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(vm.theme.ink)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(vm.theme.ink2)
            }
        }
    }
}
