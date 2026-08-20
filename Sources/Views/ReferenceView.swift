import SwiftUI

struct ReferenceView: View {
    @EnvironmentObject var state: AppState
    @State private var tab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $tab) {
                    Text("Shortcuts").tag(0)
                    Text("Mics").tag(1)
                    Text("Export").tag(2)
                    Text("Terms").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        switch tab {
                        case 0: shortcuts
                        case 1: mics
                        case 2: exports
                        default: glossary
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .padding(.top, 8)
            .background(Theme.bg)
            .navigationTitle("Reference")
        }
    }

    // MARK: - Shortcuts

    private var shortcuts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Showing \(state.daw.name). Mac shortcuts use Cmd, Windows uses Ctrl.")
                .font(.caption).foregroundColor(Theme.dim)

            VStack(spacing: 0) {
                ForEach(Array(Reference.shortcuts.enumerated()), id: \.element.id) { index, row in
                    HStack(alignment: .top) {
                        Text(row.action)
                            .font(.footnote)
                            .foregroundColor(Theme.dim)
                        Spacer(minLength: 12)
                        Text(row.value(for: state.daw))
                            .font(.footnote.weight(.bold))
                            .foregroundColor(state.daw.color)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.vertical, 11)
                    if index < Reference.shortcuts.count - 1 { Divider().background(Theme.stroke) }
                }
            }
            .padding(.horizontal, 14)
            .background(Theme.card)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.stroke, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Mics

    private var mics: some View {
        VStack(spacing: 10) {
            ForEach(Reference.mics) { mic in
                Card {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(mic.name).font(.subheadline.weight(.bold)).foregroundColor(Theme.text)
                            Spacer()
                            Pill(text: mic.type.uppercased(), color: Theme.faint)
                        }
                        Text(mic.bestFor).font(.caption.weight(.semibold)).foregroundColor(state.daw.color)
                        Text(mic.notes).font(.caption).foregroundColor(Theme.dim).lineSpacing(2)
                    }
                }
            }
        }
    }

    // MARK: - Export matrix

    private var exports: some View {
        VStack(spacing: 10) {
            Text("What to send, and to who.")
                .font(.caption).foregroundColor(Theme.dim)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(Reference.exports) { row in
                Card {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(row.destination).font(.subheadline.weight(.bold)).foregroundColor(Theme.text)
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "doc").font(.caption2).foregroundColor(Theme.faint)
                            Text(row.format).font(.caption).foregroundColor(Theme.dim)
                        }
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "speaker.wave.2").font(.caption2).foregroundColor(Theme.faint)
                            Text(row.level).font(.caption).foregroundColor(Theme.dim)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Glossary

    private var glossary: some View {
        VStack(spacing: 10) {
            ForEach(Reference.glossary) { term in
                Card(padding: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.word).font(.subheadline.weight(.bold)).foregroundColor(Theme.text)
                        Text(term.meaning).font(.caption).foregroundColor(Theme.dim).lineSpacing(2)
                    }
                }
            }
        }
    }
}
