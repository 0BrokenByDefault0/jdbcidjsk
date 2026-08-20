import Foundation

enum Guide {

    static let phases: [Phase] = [
        Phase(id: "p1", title: "Set Up",
              caption: "Before a single word is recorded",
              symbol: "slider.horizontal.3",
              chapters: ContentSetup.all),
        Phase(id: "p2", title: "Track",
              caption: "Getting the performance down",
              symbol: "mic.fill",
              chapters: ContentTrack.all),
        Phase(id: "p3", title: "Shape",
              caption: "Tuning, mixing, effects",
              symbol: "waveform.path",
              chapters: ContentShape.all),
        Phase(id: "p4", title: "Finish",
              caption: "Master, export, fix what is broken",
              symbol: "square.and.arrow.up",
              chapters: ContentFinish.all)
    ]

    static let chapters: [Chapter] = phases.flatMap { $0.chapters }

    static var totalChecks: Int { chapters.reduce(0) { $0 + $1.checklist.count } }

    static func chapter(id: String) -> Chapter? { chapters.first { $0.id == id } }

    static func next(after chapter: Chapter) -> Chapter? {
        guard let index = chapters.firstIndex(where: { $0.id == chapter.id }),
              index + 1 < chapters.count else { return nil }
        return chapters[index + 1]
    }

    static var totalMinutes: Int { chapters.reduce(0) { $0 + $1.minutes } }
}

// MARK: - Reference tables

struct ShortcutRow: Identifiable {
    let id = UUID()
    let action: String
    let ableton: String
    let logic: String
    let fl: String

    func value(for daw: DAW) -> String {
        switch daw {
        case .ableton: return ableton
        case .logic:   return logic
        case .fl:      return fl
        }
    }
}

enum Reference {

    static let shortcuts: [ShortcutRow] = [
        ShortcutRow(action: "Play / stop",              ableton: "Space",           logic: "Space",           fl: "Space"),
        ShortcutRow(action: "Record",                   ableton: "F9",              logic: "R",               fl: "R"),
        ShortcutRow(action: "Audio / MIDI settings",    ableton: "Cmd+, > Audio",   logic: "Cmd+, > Audio",   fl: "F10"),
        ShortcutRow(action: "New audio track",          ableton: "Cmd+T",           logic: "Cmd+Opt+N",       fl: "F9 (Mixer) then assign"),
        ShortcutRow(action: "Show input routing",       ableton: "Cmd+Alt+I",       logic: "Channel strip",   fl: "Mixer IN dropdown"),
        ShortcutRow(action: "Loop / cycle",             ableton: "Cmd+L",           logic: "C",               fl: "Playlist selection"),
        ShortcutRow(action: "Metronome",                ableton: "Toggle in bar",   logic: "K",               fl: "Toggle in transport"),
        ShortcutRow(action: "Take lanes / comping",     ableton: "Cmd+Alt+U",       logic: "Take folder",     fl: "Loop recording option"),
        ShortcutRow(action: "Split / slice",            ableton: "Cmd+E",           logic: "Cmd+T",           fl: "Slice tool (C)"),
        ShortcutRow(action: "Consolidate / flatten",    ableton: "Cmd+J",           logic: "Flatten and Merge", fl: "Consolidate track"),
        ShortcutRow(action: "Duplicate",                ableton: "Cmd+D",           logic: "Cmd+D",           fl: "Ctrl+B on a clip"),
        ShortcutRow(action: "Group / bus",              ableton: "Cmd+G",           logic: "Cmd+Shift+D",     fl: "Route to this track only"),
        ShortcutRow(action: "Automation view",          ableton: "A",               logic: "A",               fl: "Automation clip"),
        ShortcutRow(action: "Undo",                     ableton: "Cmd+Z",           logic: "Cmd+Z",           fl: "Ctrl+Z"),
        ShortcutRow(action: "Export audio",             ableton: "Cmd+Shift+R",     logic: "Cmd+B",           fl: "Ctrl+R"),
        ShortcutRow(action: "Freeze track",             ableton: "Right-click header", logic: "Snowflake button", fl: "Smart disable"),
        ShortcutRow(action: "Save",                     ableton: "Cmd+S",           logic: "Cmd+S",           fl: "Ctrl+S")
    ]

    struct Term: Identifiable {
        let id = UUID()
        let word: String
        let meaning: String
    }

    static let glossary: [Term] = [
        Term(word: "dBFS", meaning: "Decibels relative to full scale. 0 dBFS is the digital ceiling — go past it and the signal clips."),
        Term(word: "LUFS", meaning: "Loudness Units Full Scale. How loud something actually sounds to a human over time. Streaming services normalise to it."),
        Term(word: "True peak (dBTP)", meaning: "The real analog peak between digital samples. Lossy encoders can push it above what your meter shows, which is why you leave -1.0 dB."),
        Term(word: "Headroom", meaning: "The space between your loudest peak and 0 dBFS. Room for processing to work in."),
        Term(word: "Gain staging", meaning: "Keeping levels sensible at every point in the chain so nothing clips and every plugin sees the level it expects."),
        Term(word: "Proximity effect", meaning: "The bass boost you get from being very close to a directional mic. Great for weight, terrible for mud."),
        Term(word: "Off-axis", meaning: "Aiming the mic slightly past your mouth. Reduces plosives and sibilance at the source."),
        Term(word: "Round-trip latency", meaning: "Mic in, through the computer, back to your headphones. Under 10 ms is invisible."),
        Term(word: "Buffer size", meaning: "How many samples the computer processes at a time. Low = less latency, more CPU strain. High = the reverse."),
        Term(word: "Punch in", meaning: "Recording over one piece of an existing take, leaving the rest untouched."),
        Term(word: "Comping", meaning: "Building one perfect take out of the best pieces of several takes."),
        Term(word: "Pre-roll", meaning: "Playback before the punch point so you are in the flow when recording starts."),
        Term(word: "Retune speed", meaning: "How fast a pitch corrector snaps to the target note. 0 ms is the hard-tune sound."),
        Term(word: "Formant", meaning: "The resonance of your throat and mouth, separate from pitch. Shift it and you get chipmunk or demon."),
        Term(word: "Sidechain", meaning: "Using one signal to trigger processing on another — like ducking the beat 1-2 dB whenever the vocal hits."),
        Term(word: "Parallel compression", meaning: "Blending a heavily compressed copy under the original to add density without losing dynamics."),
        Term(word: "De-esser", meaning: "A compressor that only reacts to sibilance, usually 5-9 kHz."),
        Term(word: "Clipper", meaning: "Cuts the tips off transients instantly. Used before a limiter so the limiter has less work to do."),
        Term(word: "Dither", meaning: "Tiny noise added when reducing bit depth to mask quantisation error. Only once, only at the very end."),
        Term(word: "Stems", meaning: "Grouped bounces (all vocals, all drums) all starting at the same point, for a mixer or a feature."),
        Term(word: "Acapella", meaning: "The vocals alone, no instrumental."),
        Term(word: "Direct monitoring", meaning: "Hearing the mic through the interface hardware instead of the computer. Zero latency, no plugins.")
    ]

    struct MicRow: Identifiable {
        let id = UUID()
        let name: String
        let type: String
        let bestFor: String
        let notes: String
    }

    static let mics: [MicRow] = [
        MicRow(name: "Shure SM7B", type: "Dynamic", bestFor: "Underground, aggressive delivery, untreated rooms",
               notes: "Rejects room noise. Needs 60 dB+ of clean gain — use a preamp booster if your interface is weak."),
        MicRow(name: "Shure SM58 / SM57", type: "Dynamic", bestFor: "Anyone starting out, loud rooms",
               notes: "Cheap, indestructible, and used on more hit records than people admit."),
        MicRow(name: "Audio-Technica AT2020 / AT2035", type: "Condenser", bestFor: "Trap, clear modern rap",
               notes: "Bright and detailed. Needs 48V phantom power and a quieter room."),
        MicRow(name: "Rode NT1 / NT1-A", type: "Condenser", bestFor: "Trap and hyperpop stacks",
               notes: "Very low self-noise. The NT1-A is bright — watch the sibilance."),
        MicRow(name: "Neumann TLM 103 / U87", type: "Condenser", bestFor: "Studio sessions with a treated room",
               notes: "Will expose everything about your room. Not automatically better in a bedroom."),
        MicRow(name: "Any USB mic", type: "USB condenser", bestFor: "Demos, writing, reference takes",
               notes: "Fine to start. The limitation is usually the room, not the mic.")
    ]

    struct ExportRow: Identifiable {
        let id = UUID()
        let destination: String
        let format: String
        let level: String
    }

    static let exports: [ExportRow] = [
        ExportRow(destination: "Distributor (DistroKid, TuneCore)", format: "WAV 24-bit, project sample rate", level: "-1.0 dBTP, mastered"),
        ExportRow(destination: "Mastering engineer", format: "WAV 24-bit, master chain OFF", level: "Peaks at -6 dBFS"),
        ExportRow(destination: "Mix engineer", format: "Stems, WAV 24-bit, from bar 1", level: "Dry, no bus processing"),
        ExportRow(destination: "Feature artist", format: "Instrumental + rough vocal WAV", level: "Include a tempo and key note"),
        ExportRow(destination: "SoundCloud / YouTube", format: "WAV 24-bit (they encode it)", level: "-1.0 dBTP"),
        ExportRow(destination: "Group chat / phone check", format: "MP3 320 kbps", level: "Same master"),
        ExportRow(destination: "DJ / live show", format: "WAV 16-bit 44.1 kHz, dithered", level: "-0.3 dBTP acceptable"),
        ExportRow(destination: "Sync / licensing", format: "Master + instrumental + clean + acapella", level: "All at the same level")
    ]
}
