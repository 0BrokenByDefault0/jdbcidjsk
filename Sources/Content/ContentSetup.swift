import Foundation

enum ContentSetup {

    // MARK: - 1. Session setup

    static let session = Chapter(
        id: "ch1",
        number: 1,
        title: "Session Setup",
        subtitle: "Sample rate, bit depth, buffer, tempo, template",
        minutes: 6,
        why: """
        Everything downstream inherits these choices. Sample rate and bit depth decide how the file is written and \
        cannot be changed later without a conversion. Buffer size decides how much latency you hear in the headphones \
        while you rap, which is the single biggest reason people record a flat, behind-the-beat take and blame \
        themselves for it.
        """,
        specs: [
            Spec("Sample rate", "48 kHz", "Match your beat. Only use 44.1 kHz if the instrumental is already 44.1 and you refuse to convert."),
            Spec("Bit depth", "24-bit", "Never record 16-bit. 32-bit float is fine if your interface and DAW both support it."),
            Spec("Buffer while tracking", "64 or 128 samples", "Target under 10 ms round-trip latency."),
            Spec("Buffer while mixing", "512 or 1024 samples", "Raise it once you stop recording so plugins stop crackling."),
            Spec("Tempo", "Exact BPM of the beat", "Trap 130-150 (or half-time 65-75). Underground 80-95. Hyperpop 145-180."),
            Spec("Beat file", "WAV, not MP3", "Ask for the WAV or the stems. MP3 already ate the top end.")
        ],
        steps: [
            .ableton: [
                Step("Open Preferences.", keys: "Cmd+, (Mac) / Ctrl+, (Win)"),
                Step("Audio tab. Set Driver Type to Core Audio (Mac) or ASIO (Win), then pick your interface as both Audio Input and Audio Output Device.", at: "Preferences > Audio"),
                Step("Set Sample Rate to 48000. Set Buffer Size to 128. Read the Overall Latency number underneath it — that is your real round-trip latency.", at: "Preferences > Audio"),
                Step("Record Warp Launch tab: set Record File Type to WAV and Bit Depth to 24.", at: "Preferences > Record Warp Launch"),
                Step("Turn Count-in on and set it to 2 bars.", at: "Preferences > Record Warp Launch > Count-in"),
                Step("Drag the beat WAV into an audio track in Arrangement View.", keys: "Tab switches Session/Arrangement"),
                Step("Select the beat clip, open Clip View, and TURN WARP OFF unless the beat actually needs time-stretching. Then type the beat BPM into the master tempo field top-left."),
                Step("Save as a template so you never do this again: File > Save Live Set, then Preferences > File Folder > Save Current Set as Default Set.")
            ],
            .logic: [
                Step("New empty project. In the New Tracks dialog choose Audio, Input 1, and check Input Monitoring."),
                Step("Open Settings.", keys: "Cmd+,"),
                Step("Audio > Devices: select your interface for Input and Output. Set I/O Buffer Size to 128. Check Software Monitoring is ON.", at: "Settings > Audio > Devices"),
                Step("Project Settings > Audio: set Sample Rate to 48 kHz.", at: "File > Project Settings > Audio"),
                Step("Project Settings > Recording: set Recording File Type to WAVE and Bit Depth to 24-bit.", at: "File > Project Settings > Recording"),
                Step("Turn the metronome and count-in on.", keys: "K for metronome, Shift+K for count-in settings"),
                Step("Drag the beat WAV to a new audio track. When Logic asks about tempo, choose to keep the ORIGINAL tempo of the file, then set the project tempo to the beat BPM by hand."),
                Step("Save as template: File > Save as Template. It shows up in the New Project window forever.")
            ],
            .fl: [
                Step("Open Audio Settings.", keys: "F10"),
                Step("Device: choose FL Studio ASIO or your interface ASIO driver on Windows, or your interface on Mac. Never MME/DirectSound for recording.", at: "Options > Audio Settings"),
                Step("Set Sample rate to 48000 Hz. Set Buffer length to 128 samples (about 3 ms) using the slider.", at: "Options > Audio Settings"),
                Step("Turn on Options > Countdown before recording so you get a bar of clicks before the take."),
                Step("Drag the beat WAV into the Playlist. In the audio clip settings make sure the clip is NOT set to stretch, then type the beat BPM into the tempo box in the transport panel."),
                Step("Right-click the record button and set the recording mode to Audio, into the playlist as an audio clip.", at: "Transport panel"),
                Step("Save as template: File > Save as, and place the file in FL Studio user data > Templates so it appears under File > New from template.")
            ]
        ],
        laneNotes: [
            .trap: "Set the project to the full BPM (140-150), not the half-time feel. Your hi-hat rolls and your vocal grid both live on the real grid.",
            .underground: "If the beat is a loose sampled loop that drifts, turn warping OFF and just record to the audio. Fighting the grid kills the pocket.",
            .hyperpop: "Work at the true tempo even if it feels absurd. You will be chopping and pitching vocals to 1/16 and 1/32 divisions later and you want the grid honest."
        ],
        callouts: [
            Callout(.warn, "If your interface, beat, and project sample rates disagree, your vocal will play back at the wrong pitch and speed. Check all three before the first take."),
            Callout(.tip, "Build the template ONCE with your chain, your bus, your reverb send, and your export settings already in place. Sessions that take 30 seconds to open are sessions you actually finish.")
        ],
        checklist: [
            "Project is 48 kHz / 24-bit",
            "Buffer at 64-128 for tracking",
            "Round-trip latency reads under 10 ms",
            "Project tempo matches the beat exactly",
            "Beat is a WAV, warping off",
            "Count-in enabled (1-2 bars)",
            "Saved as a template"
        ]
    )

    // MARK: - 2. Mic and room

    static let mic = Chapter(
        id: "ch2",
        number: 2,
        title: "Mic and Room",
        subtitle: "Placement, distance, angle, and killing the room",
        minutes: 8,
        why: """
        The mic position is the only part of the recording you can never fix later. Distance sets your low end and \
        your room tone, angle sets your sibilance and plosives, and the surfaces around you decide whether there is \
        a boxy reflection baked into every word. Ten minutes here saves an hour of EQ surgery.
        """,
        specs: [
            Spec("Mouth to mic", "6-8 inches (a fist plus a thumb)", "Closer than 4 inches and proximity effect makes you muddy. Further than 10 and the room shows up."),
            Spec("Pop filter", "2-3 inches from the capsule", "You sit 4-5 inches behind the filter, not touching it."),
            Spec("Angle", "Mic 10-20 degrees off-axis, aimed at the bridge of your nose or the corner of your mouth", "Off-axis is how you fix S and P sounds at the source."),
            Spec("Height", "Capsule at eye level or slightly above, tilted down", "Singing up opens the throat and keeps chin-tuck compression out of the tone."),
            Spec("Behind you", "Something soft within 3 feet", "Duvet on a stand, open closet, moving blanket. The wall BEHIND you matters more than the one behind the mic."),
            Spec("Phantom power", "48V ON for condensers, OFF for dynamics", "Turn it on with the fader down. Ribbon mics: 48V can destroy them.")
        ],
        steps: [
            .ableton: [
                Step("Create an audio track.", keys: "Cmd+T / Ctrl+T"),
                Step("Show the In/Out section so you can see routing.", keys: "Cmd+Alt+I / Ctrl+Alt+I"),
                Step("Set Audio From to Ext. In and pick the input your mic is physically plugged into (1 or 2), then set the channel selector below it to Mono, not Stereo."),
                Step("Set Monitor to In while you position the mic so you can hear what you are doing, then set it back to Auto before you record."),
                Step("Arm the track (the round button in the track header) and speak at performance volume while you move the mic.")
            ],
            .logic: [
                Step("Create an audio track.", keys: "Cmd+Option+N"),
                Step("In the channel strip, click the Input slot and choose the mono input your mic is on. Make sure the track is a MONO track — the format button next to the meter should show a single circle."),
                Step("Enable Input Monitoring (the I button) and Record Enable (the R button) in the track header."),
                Step("Talk at performance volume and move the mic. Watch the channel strip meter, not the waveform.")
            ],
            .fl: [
                Step("Open the Mixer.", keys: "F9"),
                Step("Select an empty insert track, name it VOX, and at the top of that insert choose your mic input from the IN dropdown. Pick the mono input, not the stereo pair."),
                Step("Click the small record-arm dot next to the IN dropdown so the track is armed and monitoring."),
                Step("Speak at performance volume and watch the mixer meter while you adjust the mic.")
            ]
        ],
        laneNotes: [
            .trap: "6-8 inches, straight-ish but slightly off-axis. You want clean, present, and controlled — the vocal is going to sit loud and forward.",
            .underground: "Get closer, 4-6 inches, and lean into proximity effect for chest and weight. A dynamic mic (SM7B, RE20, even an SM58) into a saturated preamp is more the sound than a pristine condenser.",
            .hyperpop: "Cleanliness matters more than you think — hard tuning and formant shifting expose every room reflection and every sibilant edge. Get tight and dead, then destroy it on purpose in the box."
        ],
        callouts: [
            Callout(.tip, "The single cheapest upgrade: stop recording into a corner. Face into the room or into a closet full of clothes, never into a bare parallel wall 2 feet in front of you."),
            Callout(.warn, "Do not record with the mic pointing at your laptop or your speakers. Fan noise and bleed print into the take forever."),
            Callout(.why, "Off-axis placement works because sibilance and plosive blasts are directional. Move the blast past the capsule instead of into it and you have de-essed for free.")
        ],
        checklist: [
            "Mic 6-8 inches from mouth",
            "Pop filter 2-3 inches off the capsule",
            "Mic angled 10-20 degrees off-axis",
            "Capsule at or above eye level",
            "Soft surface behind me",
            "Track set to MONO input",
            "Phantom power correct for my mic",
            "No fan, no AC, no phone on the desk"
        ]
    )

    // MARK: - 3. Gain staging

    static let gain = Chapter(
        id: "ch3",
        number: 3,
        title: "Gain and Levels",
        subtitle: "How loud the input should actually be",
        minutes: 5,
        why: """
        24-bit gives you enormous headroom, so recording hot buys you nothing and costs you everything — one \
        ad-lib scream clips and the take is dead. You want the loudest thing you will do in the take to peak around \
        -6 dBFS, with your normal delivery averaging near -18 dBFS. That is the level analog-modelled plugins are \
        calibrated for, so your compressors and saturators will behave the way they are supposed to.
        """,
        specs: [
            Spec("Average level, normal delivery", "-18 dBFS RMS", "The meter should sit around a third to halfway up."),
            Spec("Peaks, loudest ad-lib", "-6 dBFS", "Set gain on your LOUDEST performance, not your talking voice."),
            Spec("Absolute ceiling", "Never touch 0 dBFS", "A single red clip light means redo the gain, not fix it later."),
            Spec("Interface gain knob", "Usually 10 o'clock to 1 o'clock on a condenser", "Dynamics like the SM7B need far more — a cloudlifter or a high-gain preamp."),
            Spec("Pad", "Engage the -10 or -20 dB pad only if you are still clipping at minimum gain", "")
        ],
        steps: [
            .ableton: [
                Step("Arm the track and set Monitor to In."),
                Step("Perform your loudest bar. Watch the track meter and the number that appears at the top of the meter — that is the peak hold value in dB."),
                Step("Turn the physical gain knob on your interface until that peak number reads between -6 and -8. Click the number to reset peak hold and do it again."),
                Step("Leave the Ableton track fader at 0.0 dB. Fader moves do not change recorded level — only the interface knob does."),
                Step("If you need a nudge after recording, drop a Utility device on the track and use Gain there instead of the fader.", at: "Audio Effects > Utility")
            ],
            .logic: [
                Step("Record-enable the track and turn Input Monitoring on."),
                Step("Perform your loudest bar. The number above the channel strip meter holds the peak."),
                Step("Adjust the interface gain knob until that number sits between -6 and -8. Click the number to clear it and repeat."),
                Step("Leave the channel fader at 0.0. If the input needs trimming, use the Gain plugin as the FIRST slot in the channel strip.", at: "Audio FX > Utility > Gain"),
                Step("Turn on the Peak/RMS display: click and hold the meter to switch modes if you want to watch average level instead of peaks.")
            ],
            .fl: [
                Step("Arm the mixer insert and perform your loudest bar."),
                Step("Watch the mixer insert meter. Right-click the meter and enable peak display if you want the numeric hold."),
                Step("Adjust the interface gain knob until peaks land at -6 to -8 dB."),
                Step("Leave the mixer fader at 0 dB (the default detent). Use Fruity Balance or Fruity Bass Boost's volume as a trim if you need one, not the fader."),
                Step("Turn OFF any dithering or limiting on the master while you track — you want to see real levels.")
            ]
        ],
        laneNotes: [
            .trap: "Ad-libs and screamed tags are your real peak. Gain-stage on those, then perform the verse at the same mic distance so the two glue together.",
            .underground: "If you want grit, get it from a saturator plugin after the fact, not from clipping the converter. Converter clipping is thin and ugly, not warm.",
            .hyperpop: "Hard tuning needs a clean, uncompressed input to track pitch correctly. Anything crushed on the way in makes Auto-Tune chase artifacts."
        ],
        callouts: [
            Callout(.warn, "The track fader does NOT change what gets written to disk. If the recorded file clips, only the interface gain knob (or the pad) fixes it."),
            Callout(.why, "-18 dBFS average is the digital equivalent of 0 VU on analog gear. Every emulation plugin you own was voiced at that level.")
        ],
        checklist: [
            "Gain set while performing my LOUDEST line",
            "Peaks landing -6 to -8 dBFS",
            "Average sitting near -18 dBFS",
            "No clip light, not once",
            "Track fader at 0.0",
            "Same mic distance for verse and ad-libs"
        ]
    )

    // MARK: - 4. Monitoring

    static let monitoring = Chapter(
        id: "ch4",
        number: 4,
        title: "Monitoring and Latency",
        subtitle: "How loud you should hear yourself, and how to kill delay",
        minutes: 7,
        why: """
        How you hear yourself changes how you perform. Too loud in the cans and you will under-sing, go flat, and \
        lose energy because your body thinks it is already loud enough. Too quiet and you will over-push, strain, and \
        go sharp. And if there is delay between your mouth and your ears, you will unconsciously drag behind the beat \
        on every take.
        """,
        specs: [
            Spec("Headphone SPL", "70-80 dB SPL", "Loud enough to feel the beat, quiet enough that you can still hear your own voice acoustically through the cups."),
            Spec("Vocal vs beat in the cue", "Vocal 3-6 dB louder than it will sit in the final mix", "You need pitch and diction reference, not a finished mix."),
            Spec("Round-trip latency", "Under 10 ms is invisible. 10-15 ms is noticeable. Over 20 ms will wreck your timing.", ""),
            Spec("Cue reverb", "Short plate, 15-25% wet, monitored only — never printed", "A little verb makes people sing more confidently and reach further."),
            Spec("One ear off?", "Only if you are struggling with pitch", "Slipping one cup gives you your natural voice as reference. It also lets beat bleed into the mic — keep the level down.")
        ],
        steps: [
            .ableton: [
                Step("Set the armed track Monitor to In while you dial the cue. Set it to Auto once you are recording so you only hear input when armed.", at: "Track In/Out section"),
                Step("Lower the buffer for tracking.", keys: "Cmd+, > Audio > Buffer Size = 64 or 128"),
                Step("Check the Overall Latency readout under the buffer setting. If it is over 12 ms, lower the buffer or use your interface's direct/zero-latency monitoring instead."),
                Step("If your interface has a DIRECT MONITOR knob, use it: set the Ableton track Monitor to Off, and blend mic vs playback with the hardware knob. Zero latency, always."),
                Step("Build the cue reverb: create a Return track, put a Reverb on it, and send the vocal to it. Since it lives on a return, it is never printed into your recorded file.", keys: "Cmd+Alt+T creates a return track"),
                Step("Freeze or deactivate heavy plugins on other tracks while recording so latency stays low.", keys: "Deactivate = 0 on a selected device")
            ],
            .logic: [
                Step("Settings > Audio > Devices: I/O Buffer Size 64 or 128, Software Monitoring ON.", keys: "Cmd+,"),
                Step("Turn Low Latency Mode ON while tracking. Settings > Audio > General > Low Latency Mode, and set the limit to 5 ms. It bypasses high-latency plugins automatically.", at: "Settings > Audio > General"),
                Step("Enable Input Monitoring (I) on the vocal track only."),
                Step("Build the cue reverb as a Bus send: click the Sends slot, choose Bus 1, and Logic makes an Aux with a Space Designer or ChromaVerb on it. Send level to taste, around -18 dB."),
                Step("If you want the singer's cue louder without changing the mix, use the Sends on Faders trick or duplicate to a separate cue bus feeding a different output."),
                Step("Interface has direct monitoring? Turn Logic's Input Monitoring OFF and blend on the hardware.")
            ],
            .fl: [
                Step("Open Audio Settings and drag Buffer length to 128 samples or lower.", keys: "F10"),
                Step("Make sure the armed mixer insert's monitor arrow is lit so you hear the mic through the mixer chain."),
                Step("Create the cue reverb on a separate insert: put Fruity Reeverb 2 on an empty insert, then route your VOX insert to it with a small send amount using the send knob on the routing arrow."),
                Step("Turn off Options > Plugin delay compensation issues by keeping heavy plugins off the master while tracking. A single slow plugin on the master adds latency to what you hear."),
                Step("If you have direct hardware monitoring, disarm FL monitoring and use the interface knob.")
            ]
        ],
        laneNotes: [
            .trap: "Beat forward, vocal just on top. Hi-hats and 808 need to be felt or your flow drifts. Keep a touch of slap delay in the cue for confidence.",
            .underground: "Drier cue, beat a little quieter. This is a conversational, in-the-pocket delivery and you need to hear your own consonants.",
            .hyperpop: "Monitor through the actual Auto-Tune you will use, at the retune speed you will use. The hard-tune sound changes how you place notes, so you have to perform INTO it."
        ],
        callouts: [
            Callout(.warn, "If you keep landing behind the beat, it is almost never you. Check round-trip latency before you record a fourth take."),
            Callout(.tip, "Set the cue level BEFORE the artist warms up, then leave it. Constantly riding the headphone knob mid-take destroys the vibe."),
            Callout(.why, "The reason cue reverb is not printed is simple: verb baked into the file cannot be removed, and you will want a different verb by mixdown.")
        ],
        checklist: [
            "Headphones at 70-80 dB SPL",
            "Vocal 3-6 dB above beat in the cue",
            "Round-trip latency under 10 ms",
            "Cue reverb on a send, not the track",
            "Heavy plugins frozen or bypassed",
            "Direct monitoring used if available",
            "Cue level set and left alone"
        ]
    )

    static let all: [Chapter] = [session, mic, gain, monitoring]
}
