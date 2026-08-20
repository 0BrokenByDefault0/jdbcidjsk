import SwiftUI

struct WalkthroughView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    // Header
                    Card(padding: 18) {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Recording in \(state.daw.name)")
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(Theme.text)
                                    Text("\(state.lane.name) lane  ·  \(Guide.chapters.count) steps  ·  about \(Guide.totalMinutes) min to read")
                                        .font(.caption)
                                        .foregroundColor(Theme.dim)
                                }
                                Spacer()
                                Ring(value: state.overallProgress, color: state.daw.color, size: 52)
                            }
                            ProgressBar(value: state.overallProgress, color: state.daw.color)
                            if let next = nextUp {
                                NavigationLink(value: next.id) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "play.fill").font(.caption2)
                                        Text(state.overallProgress == 0 ? "Start at step 1" : "Continue — step \(next.number), \(next.title)")
                                            .font(.footnote.weight(.semibold))
                                            .lineLimit(1)
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption2.bold())
                                    }
                                    .foregroundColor(state.daw.color)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(state.daw.color.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }

                    ForEach(Guide.phases) { phase in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                SectionTitle(text: phase.title, symbol: phase.symbol)
                                Spacer()
                                Text("\(Int(state.progress(for: phase) * 100))%")
                                    .font(.caption2.weight(.bold))
                                    .foregroundColor(Theme.faint)
                            }
                            Text(phase.caption)
                                .font(.caption)
                                .foregroundColor(Theme.faint)

                            ForEach(phase.chapters) { chapter in
                                NavigationLink(value: chapter.id) {
                                    ChapterRow(chapter: chapter)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Walkthrough")
            .navigationDestination(for: String.self) { id in
                if let chapter = Guide.chapter(id: id) {
                    ChapterView(chapter: chapter)
                }
            }
        }
    }

    private var nextUp: Chapter? {
        Guide.chapters.first { state.progress(for: $0) < 1.0 } ?? Guide.chapters.first
    }
}

struct ChapterRow: View {
    @EnvironmentObject var state: AppState
    let chapter: Chapter

    private var progress: Double { state.progress(for: chapter) }
    private var complete: Bool { progress >= 1.0 }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(complete ? Theme.good.opacity(0.18) : Color.white.opacity(0.06))
                    .frame(width: 36, height: 36)
                if complete {
                    Image(systemName: "checkmark")
                        .font(.footnote.weight(.heavy))
                        .foregroundColor(Theme.good)
                } else {
                    Text("\(chapter.number)")
                        .font(.footnote.weight(.bold))
                        .foregroundColor(Theme.dim)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(chapter.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Theme.text)
                Text(chapter.subtitle)
                    .font(.caption)
                    .foregroundColor(Theme.dim)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if progress > 0 && !complete {
                    ProgressBar(value: progress, color: state.daw.color, height: 3)
                        .padding(.top, 4)
                }
            }

            Spacer(minLength: 4)
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(Theme.faint)
        }
        .padding(14)
        .background(Theme.card)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.stroke, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
