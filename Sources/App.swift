import SwiftUI

@main
struct DAWWalkthroughApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .preferredColorScheme(.dark)
        }
    }
}

final class AppState: ObservableObject {

    private enum Keys {
        static let daw = "pref.daw"
        static let lane = "pref.lane"
        static let done = "pref.done"
        static let onboarded = "pref.onboarded"
    }

    @Published var daw: DAW {
        didSet { UserDefaults.standard.set(daw.rawValue, forKey: Keys.daw) }
    }

    @Published var lane: Lane {
        didSet { UserDefaults.standard.set(lane.rawValue, forKey: Keys.lane) }
    }

    @Published private(set) var done: Set<String> {
        didSet { UserDefaults.standard.set(Array(done), forKey: Keys.done) }
    }

    @Published var onboarded: Bool {
        didSet { UserDefaults.standard.set(onboarded, forKey: Keys.onboarded) }
    }

    init() {
        let defaults = UserDefaults.standard
        daw = DAW(rawValue: defaults.string(forKey: Keys.daw) ?? "") ?? .ableton
        lane = Lane(rawValue: defaults.string(forKey: Keys.lane) ?? "") ?? .trap
        done = Set(defaults.stringArray(forKey: Keys.done) ?? [])
        onboarded = defaults.bool(forKey: Keys.onboarded)
    }

    // MARK: - Checklist state

    func isDone(_ key: String) -> Bool { done.contains(key) }

    func toggle(_ key: String) {
        if done.contains(key) { done.remove(key) } else { done.insert(key) }
    }

    func completed(in chapter: Chapter) -> Int {
        (0..<chapter.checklist.count).filter { done.contains(chapter.checkKey($0)) }.count
    }

    func progress(for chapter: Chapter) -> Double {
        guard !chapter.checklist.isEmpty else { return 0 }
        return Double(completed(in: chapter)) / Double(chapter.checklist.count)
    }

    func progress(for phase: Phase) -> Double {
        let total = phase.chapters.reduce(0) { $0 + $1.checklist.count }
        guard total > 0 else { return 0 }
        let hit = phase.chapters.reduce(0) { $0 + completed(in: $1) }
        return Double(hit) / Double(total)
    }

    var overallProgress: Double {
        guard Guide.totalChecks > 0 else { return 0 }
        let hit = Guide.chapters.reduce(0) { $0 + completed(in: $1) }
        return Double(hit) / Double(Guide.totalChecks)
    }

    var completedChapters: Int {
        Guide.chapters.filter { progress(for: $0) >= 1.0 }.count
    }

    func resetProgress() { done.removeAll() }
}
