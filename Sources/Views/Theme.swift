import SwiftUI

enum Theme {
    static let bg = Color(red: 0.055, green: 0.055, blue: 0.070)
    static let card = Color(red: 0.102, green: 0.106, blue: 0.129)
    static let cardHi = Color(red: 0.145, green: 0.149, blue: 0.180)
    static let stroke = Color.white.opacity(0.08)
    static let text = Color.white
    static let dim = Color.white.opacity(0.62)
    static let faint = Color.white.opacity(0.40)
    static let accent = Color(red: 0.98, green: 0.35, blue: 0.42)
    static let good = Color(red: 0.30, green: 0.85, blue: 0.55)
    static let warn = Color(red: 1.00, green: 0.72, blue: 0.28)
}

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if s.count == 3 { s = s.map { "\($0)\($0)" }.joined() }
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(
            .sRGB,
            red: Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8) & 0xFF) / 255,
            blue: Double(v & 0xFF) / 255,
            opacity: 1
        )
    }
}

extension DAW {
    var color: Color { Color(hex: accentHex) }
}

extension Lane {
    var color: Color {
        switch self {
        case .trap:        return Color(hex: "#FF5C7A")
        case .underground: return Color(hex: "#9B8CFF")
        case .hyperpop:    return Color(hex: "#4FE0C4")
        }
    }
}

// MARK: - Reusable pieces

struct Card<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.stroke, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SectionTitle: View {
    let text: String
    var symbol: String? = nil

    var body: some View {
        HStack(spacing: 8) {
            if let symbol { Image(systemName: symbol).font(.footnote.weight(.bold)) }
            Text(text.uppercased())
                .font(.caption.weight(.heavy))
                .tracking(1.4)
        }
        .foregroundColor(Theme.faint)
    }
}

struct Pill: View {
    let text: String
    var color: Color = Theme.accent

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(color.opacity(0.16))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

struct ProgressBar: View {
    let value: Double
    var color: Color = Theme.accent
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.10))
                Capsule()
                    .fill(color)
                    .frame(width: max(0, min(1, value)) * geo.size.width)
            }
        }
        .frame(height: height)
    }
}

struct Ring: View {
    let value: Double
    var color: Color = Theme.accent
    var size: CGFloat = 44
    var lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.10), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, min(1, value)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int((value * 100).rounded()))")
                .font(.system(size: size * 0.30, weight: .bold, design: .rounded))
                .foregroundColor(Theme.dim)
        }
        .frame(width: size, height: size)
        .animation(.easeInOut(duration: 0.25), value: value)
    }
}
