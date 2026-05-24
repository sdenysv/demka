import SwiftUI

struct Theme: Identifiable, Equatable {
    let name: String
    let bg: Color
    let surface: Color
    let ink: Color
    let ink2: Color
    let mute: Color
    let line: Color
    let active: Color
    let visited: Color

    var id: String { name }

    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.name == rhs.name }
}

extension Theme {
    static let stone = Theme(
        name: "Stone",
        bg:      Color(hex: "#dbdad7"),
        surface: Color(hex: "#eeedea"),
        ink:     Color(hex: "#1a1a18"),
        ink2:    Color(hex: "#5a5a56"),
        mute:    Color(hex: "#9a9a95"),
        line:    Color(hex: "#b8b7b3"),
        active:  Color(hex: "#2e2e2a"),
        visited: Color(hex: "#c8c7c3")
    )
    static let midnight = Theme(
        name: "Midnight",
        bg:      Color(hex: "#111112"),
        surface: Color(hex: "#1d1d20"),
        ink:     Color(hex: "#edede9"),
        ink2:    Color(hex: "#9a9a96"),
        mute:    Color(hex: "#5a5a58"),
        line:    Color(hex: "#2e2e32"),
        active:  Color(hex: "#c8c8c4"),
        visited: Color(hex: "#3a3a3f")
    )
    static let amber = Theme(
        name: "Amber",
        bg:      Color(hex: "#1c1c1c"),
        surface: Color(hex: "#242422"),
        ink:     Color(hex: "#d9a441"),
        ink2:    Color(hex: "#b08838"),
        mute:    Color(hex: "#6b5528"),
        line:    Color(hex: "#2e2c28"),
        active:  Color(hex: "#f0b84d"),
        visited: Color(hex: "#363330")
    )

    static let all: [Theme] = [.stone, .midnight, .amber]
}

extension Color {
    init(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if h.hasPrefix("#") { h = String(h.dropFirst()) }
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double( rgb        & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
