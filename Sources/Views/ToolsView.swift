import SwiftUI

struct ToolsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Calculators for the numbers you actually have to hit while the session is running.")
                        .font(.caption)
                        .foregroundColor(Theme.dim)

                    GainTool()
                    LatencyTool()
                    TempoTool()
                    MonitorTool()
                    LoudnessTool()
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(Theme.bg)
            .navigationTitle("Tools")
        }
    }
}

// MARK: - Gain staging

struct GainTool: View {
    @EnvironmentObject var state: AppState
    @State private var peak: Double = -7

    private var verdict: (String, String, Color) {
        switch peak {
        case ..<(-20):
            return ("Too quiet", "Turn the interface gain UP. You are burying the vocal in the noise floor and you will have to add gain later, which adds hiss with it.", Theme.warn)
        case -20 ..< -12:
            return ("A little low", "Safe, but you have more headroom than you need. Nudge the gain up until peaks land near -6.", Theme.warn)
        case -12 ... -4:
            return ("Right where you want it", "Peaks in the sweet spot. Your average should be sitting around -18 dBFS while you rap normally.", Theme.good)
        case -4 ..< -1:
            return ("Getting hot", "One loud ad-lib away from clipping. Back the interface gain off 3-4 dB.", Theme.warn)
        default:
            return ("Too hot — turn it down now", "You will clip on the loudest line and the take is unusable. Lower the interface gain knob, not the fader.", Theme.accent)
        }
    }

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle(text: "Input level check", symbol: "waveform.badge.exclamationmark")
                Text("Perform your loudest line, read the peak number off your DAW meter, and set it here.")
                    .font(.caption).foregroundColor(Theme.dim)

                HStack {
                    Text(String(format: "%.1f dBFS", peak))
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(verdict.2)
                    Spacer()
                    Pill(text: verdict.0.uppercased(), color: verdict.2)
                }

                Slider(value: $peak, in: -40...0, step: 0.5)
                    .tint(verdict.2)

                HStack {
                    Text("-40").font(.caption2).foregroundColor(Theme.faint)
                    Spacer()
                    Text("-6 target").font(.caption2.weight(.bold)).foregroundColor(Theme.good)
                    Spacer()
                    Text("0").font(.caption2).foregroundColor(Theme.faint)
                }

                Text(verdict.1)
                    .font(.footnote)
                    .foregroundColor(Theme.text.opacity(0.9))
                    .lineSpacing(3)
            }
        }
    }
}

// MARK: - Latency

struct LatencyTool: View {
    @State private var buffer: Int = 128
    @State private var rate: Double = 48000

    private let buffers = [32, 64, 128, 256, 512, 1024]
    private let rates: [Double] = [44100, 48000, 96000]

    /// Buffer latency happens twice (in and out), plus roughly 2 ms of converter overhead.
    private var roundTrip: Double {
        (Double(buffer) / rate) * 2 * 1000 + 2
    }

    private var verdict: (String, Color) {
        switch roundTrip {
        case ..<10:  return ("Invisible — record on this", Theme.good)
        case 10..<15: return ("Noticeable. Fine for singing, tight for rapping.", Theme.warn)
        default:     return ("You will drag behind the beat. Lower the buffer.", Theme.accent)
        }
    }

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle(text: "Latency calculator", symbol: "timer")
                Text("Estimated round-trip: mic in, through the computer, back to your headphones.")
                    .font(.caption).foregroundColor(Theme.dim)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(String(format: "%.1f", roundTrip))
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(verdict.1)
                    Text("ms").font(.headline).foregroundColor(Theme.dim)
                }
                Text(verdict.0)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(verdict.1)

                Text("BUFFER SIZE").font(.caption2.weight(.heavy)).tracking(1).foregroundColor(Theme.faint)
                HStack(spacing: 5) {
                    ForEach(buffers, id: \.self) { size in
                        Button { buffer = size } label: {
                            Text("\(size)")
                                .font(.caption2.weight(.bold))
                                .padding(.vertical, 7).frame(maxWidth: .infinity)
                                .background(buffer == size ? Theme.good.opacity(0.18) : Theme.cardHi)
                                .foregroundColor(buffer == size ? Theme.good : Theme.dim)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                Text("SAMPLE RATE").font(.caption2.weight(.heavy)).tracking(1).foregroundColor(Theme.faint)
                HStack(spacing: 5) {
                    ForEach(rates, id: \.self) { value in
                        Button { rate = value } label: {
                            Text("\(Int(value / 1000))k" + (value == 44100 ? ".1" : ""))
                                .font(.caption2.weight(.bold))
                                .padding(.vertical, 7).frame(maxWidth: .infinity)
                                .background(rate == value ? Theme.good.opacity(0.18) : Theme.cardHi)
                                .foregroundColor(rate == value ? Theme.good : Theme.dim)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                Text("Real latency also depends on your driver and any plugins on the monitored path. If the number here is fine but it still feels late, freeze your plugins or switch to hardware direct monitoring.")
                    .font(.caption2).foregroundColor(Theme.faint).lineSpacing(2)
            }
        }
    }
}

// MARK: - Tempo maths

struct TempoTool: View {
    @State private var bpm: Double = 140

    private var quarter: Double { 60000 / bpm }

    private var rows: [(String, Double)] {
        [
            ("1/4 note", quarter),
            ("1/8 note", quarter / 2),
            ("1/8 dotted  (the rap default)", quarter * 0.75),
            ("1/8 triplet", quarter / 3),
            ("1/16 note", quarter / 4),
            ("1/16 dotted", quarter * 0.375),
            ("1 bar (4/4)", quarter * 4)
        ]
    }

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle(text: "Delay and pre-roll times", symbol: "metronome")
                Text("Set your beat tempo. Use these millisecond values for delay, pre-delay, and compressor release.")
                    .font(.caption).foregroundColor(Theme.dim)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(Int(bpm))")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(Theme.text)
                    Text("BPM").font(.headline).foregroundColor(Theme.dim)
                    Spacer()
                    Text("half-time feel: \(Int(bpm / 2))")
                        .font(.caption2).foregroundColor(Theme.faint)
                }
                Slider(value: $bpm, in: 60...200, step: 1).tint(Theme.accent)

                VStack(spacing: 0) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        HStack {
                            Text(row.0).font(.footnote).foregroundColor(Theme.dim)
                            Spacer()
                            Text(String(format: "%.0f ms", row.1))
                                .font(.footnote.weight(.bold).monospacedDigit())
                                .foregroundColor(Theme.text)
                        }
                        .padding(.vertical, 8)
                        if index < rows.count - 1 { Divider().background(Theme.stroke) }
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("PUNCH-IN PRE-ROLL")
                        .font(.caption2.weight(.heavy)).tracking(1).foregroundColor(Theme.faint)
                    Text(String(format: "Roll from %.1f s (1 bar) to %.1f s (2 bars) before the punch point.",
                                quarter * 4 / 1000, quarter * 8 / 1000))
                        .font(.footnote).foregroundColor(Theme.text.opacity(0.9))
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Monitoring

struct MonitorTool: View {
    @State private var spl: Double = 76

    private var verdict: (String, String, Color) {
        switch spl {
        case ..<65:
            return ("Too quiet", "You will over-push and sing sharp, and you will strain your voice by take four. Bring it up.", Theme.warn)
        case 65..<70:
            return ("Slightly quiet", "Fine for a soft, conversational underground delivery. Too quiet for hype ad-libs.", Theme.warn)
        case 70...80:
            return ("Right in the pocket", "Loud enough to feel the beat, quiet enough that you still hear your own voice acoustically through the cups. This is where you want to live.", Theme.good)
        case 80..<88:
            return ("Loud", "You will start under-singing because your brain thinks you are already loud. Also fatiguing — you will lose the top of your ears within an hour.", Theme.warn)
        default:
            return ("Turn it down", "Hearing damage territory over a full session, and you will consistently sing flat.", Theme.accent)
        }
    }

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle(text: "Headphone level", symbol: "headphones")
                Text("How loud you should hear yourself. No meter on your cans? Use the reference below.")
                    .font(.caption).foregroundColor(Theme.dim)

                HStack {
                    Text("\(Int(spl)) dB SPL")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(verdict.2)
                    Spacer()
                    Pill(text: verdict.0.uppercased(), color: verdict.2)
                }
                Slider(value: $spl, in: 55...100, step: 1).tint(verdict.2)

                Text(verdict.1)
                    .font(.footnote).foregroundColor(Theme.text.opacity(0.9)).lineSpacing(3)

                Divider().background(Theme.stroke)

                VStack(alignment: .leading, spacing: 7) {
                    Text("NO METER? USE THIS TEST")
                        .font(.caption2.weight(.heavy)).tracking(1).foregroundColor(Theme.faint)
                    ForEach([
                        "Speak at normal volume with the cans on and the beat playing.",
                        "If you cannot hear your own voice AT ALL through the cups, it is too loud.",
                        "If your voice is louder to you than the beat, it is too quiet.",
                        "Set the cue level before you warm up, then do not touch it again."
                    ], id: \.self) { line in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(Theme.faint).frame(width: 4, height: 4).padding(.top, 6)
                            Text(line).font(.footnote).foregroundColor(Theme.dim)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Loudness

struct LoudnessTool: View {
    @EnvironmentObject var state: AppState

    private func target(for lane: Lane) -> (String, String) {
        switch lane {
        case .trap:        return ("-8 to -6 LUFS", "Competitive and loud without killing the 808 transient.")
        case .underground: return ("-10 to -8 LUFS", "Keeps the dynamics that make a raw record hit.")
        case .hyperpop:    return ("-6 to -4 LUFS", "Deliberately crushed. Clipping is part of the sound.")
        }
    }

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle(text: "Loudness targets", symbol: "speaker.wave.3")

                VStack(spacing: 8) {
                    ForEach(Lane.allCases) { lane in
                        let value = target(for: lane)
                        HStack(alignment: .top, spacing: 12) {
                            Circle().fill(lane.color).frame(width: 8, height: 8).padding(.top, 5)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(lane.name).font(.footnote.weight(.bold)).foregroundColor(Theme.text)
                                    Spacer()
                                    Text(value.0)
                                        .font(.footnote.weight(.heavy).monospacedDigit())
                                        .foregroundColor(lane.color)
                                }
                                Text(value.1).font(.caption2).foregroundColor(Theme.faint)
                            }
                        }
                        .padding(11)
                        .background(state.lane == lane ? Theme.cardHi : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                Divider().background(Theme.stroke)

                HStack {
                    Text("True peak ceiling").font(.footnote).foregroundColor(Theme.dim)
                    Spacer()
                    Text("-1.0 dBTP").font(.footnote.weight(.heavy)).foregroundColor(Theme.text)
                }
                HStack {
                    Text("Limiter gain reduction").font(.footnote).foregroundColor(Theme.dim)
                    Spacer()
                    Text("2-4 dB max").font(.footnote.weight(.heavy)).foregroundColor(Theme.text)
                }
                HStack {
                    Text("Mix bus before mastering").font(.footnote).foregroundColor(Theme.dim)
                    Spacer()
                    Text("-6 dBFS peak").font(.footnote.weight(.heavy)).foregroundColor(Theme.text)
                }

                Text("Streaming platforms turn everything down to roughly -14 LUFS on playback anyway. Past about -8, extra loudness costs you punch and buys you nothing.")
                    .font(.caption2).foregroundColor(Theme.faint).lineSpacing(2).padding(.top, 4)
            }
        }
    }
}
