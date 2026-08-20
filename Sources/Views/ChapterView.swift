import SwiftUI

struct ChapterView: View {
    @EnvironmentObject var state: AppState
    let chapter: Chapter

    /// Lets you peek at another DAW's steps without changing your global choice.
    @State private var viewDAW: DAW? = nil

    private var shownDAW: DAW { viewDAW ?? state.daw }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {

                header
                whyCard

                if !chapter.specs.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionTitle(text: "Set it to this", symbol: "dial.high")
                        VStack(spacing: 8) {
                            ForEach(chapter.specs) { spec in SpecRow(spec: spec) }
                        }
                    }
                }

                stepsSection

                if let note = chapter.laneNotes[state.lane] {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionTitle(text: "\(state.lane.name) specifics", symbol: "flame")
                        Card {
                            Text(note)
                                .font(.subheadline)
                                .foregroundColor(Theme.text.opacity(0.92))
                                .lineSpacing(3)
                        }
                        .overlay(alignment: .leading) {
                            Rectangle().fill(state.lane.color).frame(width: 3)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                        }
                    }
                }

                if !chapter.callouts.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(chapter.callouts) { CalloutView(callout: $0) }
                    }
                }

                checklistSection
                nextUp
            }
            .padding(20)
            .padding(.bottom, 30)
        }
        .background(Theme.bg)
        .navigationTitle("Step \(chapter.number)")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Pieces

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Pill(text: "STEP \(chapter.number)", color: state.daw.color)
                Pill(text: "\(chapter.minutes) MIN", color: Theme.faint)
            }
            Text(chapter.title)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(Theme.text)
            Text(chapter.subtitle)
                .font(.subheadline)
                .foregroundColor(Theme.dim)
        }
    }

    private var whyCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 8) {
                SectionTitle(text: "Why this matters", symbol: "questionmark.circle")
                Text(chapter.why)
                    .font(.subheadline)
                    .foregroundColor(Theme.text.opacity(0.9))
                    .lineSpacing(4)
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SectionTitle(text: "Do this", symbol: "hand.tap")
                Spacer()
            }

            // DAW switcher — defaults to your pick, lets you compare.
            HStack(spacing: 6) {
                ForEach(DAW.allCases) { daw in
                    Button {
                        viewDAW = (daw == state.daw) ? nil : daw
                    } label: {
                        Text(daw.shortName)
                            .font(.caption.weight(.bold))
                            .padding(.vertical, 7)
                            .frame(maxWidth: .infinity)
                            .background(shownDAW == daw ? daw.color.opacity(0.20) : Theme.card)
                            .foregroundColor(shownDAW == daw ? daw.color : Theme.faint)
                            .overlay(RoundedRectangle(cornerRadius: 9)
                                .stroke(shownDAW == daw ? daw.color.opacity(0.5) : Theme.stroke, lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                }
            }

            if let steps = chapter.steps[shownDAW] {
                VStack(spacing: 8) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        StepRow(index: index + 1, step: step, color: shownDAW.color)
                    }
                }
            }
        }
    }

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SectionTitle(text: "Before you move on", symbol: "checklist")
                Spacer()
                Text("\(state.completed(in: chapter))/\(chapter.checklist.count)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(Theme.faint)
            }
            VStack(spacing: 0) {
                ForEach(Array(chapter.checklist.enumerated()), id: \.offset) { index, item in
                    let key = chapter.checkKey(index)
                    Button {
                        state.toggle(key)
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: state.isDone(key) ? "checkmark.square.fill" : "square")
                                .font(.body)
                                .foregroundColor(state.isDone(key) ? Theme.good : Theme.faint)
                            Text(item)
                                .font(.subheadline)
                                .foregroundColor(state.isDone(key) ? Theme.dim : Theme.text)
                                .strikethrough(state.isDone(key), color: Theme.faint)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 11)
                    }
                    if index < chapter.checklist.count - 1 {
                        Divider().background(Theme.stroke)
                    }
                }
            }
            .padding(.horizontal, 14)
            .background(Theme.card)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.stroke, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    @ViewBuilder
    private var nextUp: some View {
        if let next = Guide.next(after: chapter) {
            NavigationLink(value: next.id) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("NEXT — STEP \(next.number)")
                            .font(.caption2.weight(.heavy)).tracking(1.2)
                            .foregroundColor(Theme.faint)
                        Text(next.title)
                            .font(.headline)
                            .foregroundColor(Theme.text)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.body.bold())
                        .foregroundColor(state.daw.color)
                }
                .padding(16)
                .background(Theme.cardHi)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.stroke, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Rows

struct SpecRow: View {
    let spec: Spec

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(spec.name)
                    .font(.footnote)
                    .foregroundColor(Theme.dim)
                Spacer(minLength: 12)
                Text(spec.value)
                    .font(.footnote.weight(.bold))
                    .foregroundColor(Theme.text)
                    .multilineTextAlignment(.trailing)
            }
            if let note = spec.note, !note.isEmpty {
                Text(note)
                    .font(.caption2)
                    .foregroundColor(Theme.faint)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        .overlay(RoundedRectangle(cornerRadius: 11).stroke(Theme.stroke, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 11))
    }
}

struct StepRow: View {
    let index: Int
    let step: Step
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index)")
                .font(.caption.weight(.black))
                .foregroundColor(color)
                .frame(width: 22, height: 22)
                .background(color.opacity(0.14))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 7) {
                Text(step.text)
                    .font(.subheadline)
                    .foregroundColor(Theme.text.opacity(0.94))
                    .lineSpacing(3)
                    .multilineTextAlignment(.leading)

                if step.keys != nil || step.location != nil {
                    HStack(spacing: 6) {
                        if let keys = step.keys {
                            Label(keys, systemImage: "keyboard")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Color.white.opacity(0.07))
                                .foregroundColor(Theme.dim)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        if let location = step.location {
                            Label(location, systemImage: "location")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Color.white.opacity(0.07))
                                .foregroundColor(Theme.dim)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.stroke, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CalloutView: View {
    let callout: Callout

    private var color: Color {
        switch callout.kind {
        case .tip:  return Theme.good
        case .warn: return Theme.warn
        case .why:  return Color(hex: "#7AB8FF")
        }
    }

    private var symbol: String {
        switch callout.kind {
        case .tip:  return "lightbulb.fill"
        case .warn: return "exclamationmark.triangle.fill"
        case .why:  return "info.circle.fill"
        }
    }

    private var label: String {
        switch callout.kind {
        case .tip:  return "TIP"
        case .warn: return "WATCH OUT"
        case .why:  return "WHY"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Image(systemName: symbol)
                .font(.footnote)
                .foregroundColor(color)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption2.weight(.heavy)).tracking(1.1)
                    .foregroundColor(color)
                Text(callout.text)
                    .font(.subheadline)
                    .foregroundColor(Theme.text.opacity(0.9))
                    .lineSpacing(3)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(color.opacity(0.25), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}
