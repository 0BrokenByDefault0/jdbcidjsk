import SwiftUI

struct RootView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            if state.onboarded {
                MainTabs()
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state.onboarded)
    }
}

struct MainTabs: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        TabView {
            WalkthroughView()
                .tabItem { Label("Walkthrough", systemImage: "list.number") }
            ToolsView()
                .tabItem { Label("Tools", systemImage: "dial.medium") }
            ReferenceView()
                .tabItem { Label("Reference", systemImage: "book.closed") }
            SettingsView()
                .tabItem { Label("Setup", systemImage: "gearshape") }
        }
        .tint(state.daw.color)
    }
}

// MARK: - Onboarding

struct OnboardingView: View {
    @EnvironmentObject var state: AppState
    @State private var page = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 40)

            Text("RECORD\nROOM")
                .font(.system(size: 46, weight: .black, design: .rounded))
                .foregroundColor(Theme.text)
                .lineSpacing(-6)

            Text("A step-by-step walkthrough for recording trap, underground and hyperpop vocals — in your DAW, with the actual numbers.")
                .font(.callout)
                .foregroundColor(Theme.dim)
                .padding(.top, 12)
                .padding(.bottom, 32)

            if page == 0 {
                SectionTitle(text: "What are you working in?", symbol: "waveform")
                    .padding(.bottom, 12)
                VStack(spacing: 10) {
                    ForEach(DAW.allCases) { daw in
                        Button {
                            state.daw = daw
                            withAnimation { page = 1 }
                        } label: {
                            HStack {
                                Circle().fill(daw.color).frame(width: 10, height: 10)
                                Text(daw.name).font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right").font(.footnote.bold())
                                    .foregroundColor(Theme.faint)
                            }
                            .foregroundColor(Theme.text)
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(state.daw == daw ? Theme.cardHi : Theme.card)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(state.daw == daw ? daw.color.opacity(0.6) : Theme.stroke, lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            } else {
                SectionTitle(text: "What are you making?", symbol: "flame")
                    .padding(.bottom, 12)
                VStack(spacing: 10) {
                    ForEach(Lane.allCases) { lane in
                        Button {
                            state.lane = lane
                            state.onboarded = true
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(lane.name).font(.headline)
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.footnote.bold())
                                        .foregroundColor(Theme.faint)
                                }
                                Text(lane.blurb)
                                    .font(.caption)
                                    .foregroundColor(Theme.dim)
                                    .multilineTextAlignment(.leading)
                            }
                            .foregroundColor(Theme.text)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.card)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(lane.color.opacity(0.35), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                Button("Back") { withAnimation { page = 0 } }
                    .font(.footnote)
                    .foregroundColor(Theme.faint)
                    .padding(.top, 14)
            }

            Spacer()

            Text("You can change both of these at any time in Setup.")
                .font(.caption2)
                .foregroundColor(Theme.faint)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 22)
    }
}

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var state: AppState
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    SectionTitle(text: "Your DAW", symbol: "waveform")
                    VStack(spacing: 8) {
                        ForEach(DAW.allCases) { daw in
                            Button { state.daw = daw } label: {
                                HStack {
                                    Circle().fill(daw.color).frame(width: 9, height: 9)
                                    Text(daw.name).font(.subheadline.weight(.semibold))
                                    Spacer()
                                    if state.daw == daw {
                                        Image(systemName: "checkmark").font(.footnote.bold())
                                            .foregroundColor(daw.color)
                                    }
                                }
                                .foregroundColor(Theme.text)
                                .padding(14)
                                .background(Theme.card)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.stroke, lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    SectionTitle(text: "Your lane", symbol: "flame")
                    VStack(spacing: 8) {
                        ForEach(Lane.allCases) { lane in
                            Button { state.lane = lane } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(lane.name).font(.subheadline.weight(.semibold))
                                        Spacer()
                                        if state.lane == lane {
                                            Image(systemName: "checkmark").font(.footnote.bold())
                                                .foregroundColor(lane.color)
                                        }
                                    }
                                    Text(lane.blurb).font(.caption).foregroundColor(Theme.dim)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundColor(Theme.text)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.card)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.stroke, lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    SectionTitle(text: "Progress", symbol: "checkmark.circle")
                    Card {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Ring(value: state.overallProgress, color: state.daw.color, size: 52)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(state.completedChapters) of \(Guide.chapters.count) steps complete")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(Theme.text)
                                    Text("\(Guide.totalChecks) checkpoints total")
                                        .font(.caption).foregroundColor(Theme.dim)
                                }
                            }
                            Button(role: .destructive) { confirmReset = true } label: {
                                Text("Reset all progress").font(.footnote.weight(.semibold))
                            }
                        }
                    }

                    Text("Levels and settings in this app are starting points that work, not laws. Trust your ears once you know what the numbers are for.")
                        .font(.caption)
                        .foregroundColor(Theme.faint)
                        .padding(.top, 6)
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Setup")
            .alert("Reset all progress?", isPresented: $confirmReset) {
                Button("Reset", role: .destructive) { state.resetProgress() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Every checklist item across all 15 steps will be cleared.")
            }
        }
    }
}
