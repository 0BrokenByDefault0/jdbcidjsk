import Foundation

// MARK: - Core enums

enum DAW: String, CaseIterable, Identifiable, Codable {
    case ableton, logic, fl

    var id: String { rawValue }

    var name: String {
        switch self {
        case .ableton: return "Ableton Live"
        case .logic:   return "Logic Pro"
        case .fl:      return "FL Studio"
        }
    }

    var shortName: String {
        switch self {
        case .ableton: return "Live"
        case .logic:   return "Logic"
        case .fl:      return "FL"
        }
    }

    var accentHex: String {
        switch self {
        case .ableton: return "#F2C94C"
        case .logic:   return "#7AB8FF"
        case .fl:      return "#F58F4C"
        }
    }
}

enum Lane: String, CaseIterable, Identifiable, Codable {
    case trap, underground, hyperpop

    var id: String { rawValue }

    var name: String {
        switch self {
        case .trap:        return "Trap"
        case .underground: return "Underground"
        case .hyperpop:    return "Hyperpop"
        }
    }

    var blurb: String {
        switch self {
        case .trap:
            return "Clean, loud, forward. Tight low end, controlled sibilance, vocal sits on top of the beat."
        case .underground:
            return "Grit is the point. Saturation, room, tape-ish noise, vocal glued into the beat instead of over it."
        case .hyperpop:
            return "Everything is an effect. Hard tune, formant shifts, stacked octaves, deliberate clipping and distortion."
        }
    }
}

// MARK: - Content building blocks

/// A single numbered instruction. `keys` is the exact shortcut, `where` is the exact UI location.
struct Step: Identifiable, Codable {
    var id = UUID()
    var text: String
    var keys: String? = nil
    var location: String? = nil

    init(_ text: String, keys: String? = nil, at location: String? = nil) {
        self.text = text
        self.keys = keys
        self.location = location
    }
}

/// A hard number the user should be hitting: level, distance, time, setting.
struct Spec: Identifiable, Codable {
    var id = UUID()
    var name: String
    var value: String
    var note: String? = nil

    init(_ name: String, _ value: String, _ note: String? = nil) {
        self.name = name
        self.value = value
        self.note = note
    }
}

enum CalloutKind: String, Codable {
    case tip, warn, why
}

struct Callout: Identifiable, Codable {
    var id = UUID()
    var kind: CalloutKind
    var text: String

    init(_ kind: CalloutKind, _ text: String) {
        self.kind = kind
        self.text = text
    }
}

struct Chapter: Identifiable, Codable {
    var id: String
    var number: Int
    var title: String
    var subtitle: String
    var minutes: Int
    /// Plain-language explanation of what this step is actually for.
    var why: String
    var specs: [Spec] = []
    var steps: [DAW: [Step]] = [:]
    var laneNotes: [Lane: String] = [:]
    var callouts: [Callout] = []
    var checklist: [String] = []

    /// Stable per-item key so checklist progress survives relaunches.
    func checkKey(_ index: Int) -> String { "\(id).check.\(index)" }
}

struct Phase: Identifiable {
    var id: String
    var title: String
    var caption: String
    var symbol: String
    var chapters: [Chapter]
}
