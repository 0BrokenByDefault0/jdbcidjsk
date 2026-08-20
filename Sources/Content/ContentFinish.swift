import Foundation

enum ContentFinish {

    // MARK: - 13. Master

    static let master = Chapter(
        id: "ch13",
        number: 13,
        title: "Master Chain and Loudness",
        subtitle: "Clipper, limiter, LUFS targets, true peak",
        minutes: 8,
        why: """
        Streaming platforms normalise playback, so chasing maximum loudness past a point only costs you dynamics and \
        buys you nothing. But rap is not mixed for the loudness meter — it is mixed to hit. The move is to use a \
        clipper to shave transients BEFORE the limiter, so the limiter never has to work hard enough to pump.
        """,
        specs: [
            Spec("Integrated LUFS, trap / rap", "-8 to -6 LUFS", "Competitive without destroying the transients."),
            Spec("Integrated LUFS, underground", "-10 to -8 LUFS", "More dynamic range suits the aesthetic."),
            Spec("Integrated LUFS, hyperpop", "-6 to -4 LUFS", "Deliberately crushed. Clipping is a texture here."),
            Spec("True peak ceiling", "-1.0 dBTP", "Never 0.0. Lossy encoding (AAC, MP3) creates peaks above what you see."),
            Spec("Limiter gain reduction", "2-4 dB", "If the limiter is doing 8 dB, the mix is the problem, not the master."),
            Spec("Clipper before limiter", "1-3 dB of clipping on transients", "Shaves the 808 and snare peaks so the limiter can breathe."),
            Spec("Master EQ moves", "Under 1.5 dB, wide Q only", "If you need more than that, go fix the mix."),
            Spec("Master bus comp", "1.5:1, 1-2 dB GR, slow attack 30 ms, release auto", "Glue only.")
        ],
        steps: [
            .ableton: [
                Step("Master chain order: Utility (trim) > EQ Eight (broad tone) > Glue Compressor > Saturator (as clipper) > Limiter."),
                Step("Glue Compressor: Ratio 2, Attack 30 ms, Release Auto, 1-2 dB reduction."),
                Step("Saturator as a clipper: choose the Analog Clip curve, set Dry/Wet to 100%, and push Drive until you see 1-3 dB of peak reduction. Use the Output to compensate."),
                Step("Limiter last: set Ceiling to -1.0 dB and turn on Auto Release. Push the Gain until you see 2-4 dB of gain reduction on the loudest section."),
                Step("Check loudness: Live 11+ shows LUFS in the export dialog. For live metering, use a third-party meter or check after a test export."),
                Step("A/B against a level-matched reference. Toggle the whole master chain on and off — it should sound louder AND better, not just louder.")
            ],
            .logic: [
                Step("Stereo Out chain order: Gain (trim) > Channel EQ > Compressor > Clip Distortion or Adaptive Limiter > Limiter > Loudness Meter."),
                Step("Compressor: Platinum Digital, Ratio 2:1, Attack 30 ms, Release Auto, 1-2 dB reduction."),
                Step("Adaptive Limiter as a soft clipper stage: pull Gain up for 1-3 dB of shaving, set its Out Ceiling to -0.5 dB."),
                Step("Limiter last: Output Level -1.0 dB, Lookahead default, push Gain for 2-4 dB reduction."),
                Step("Add the Loudness Meter as the FINAL slot. Play the whole song and read the Integrated LUFS value at the end."),
                Step("Adjust the limiter gain until Integrated LUFS matches your lane target, then re-check True Peak stays under -1.0.")
            ],
            .fl: [
                Step("Master insert chain: Fruity Balance (trim) > Fruity Parametric EQ 2 > Fruity Limiter (COMP mode for glue) > Fruity Soft Clipper > Fruity Limiter (LIMIT mode)."),
                Step("Glue stage: Fruity Limiter on the COMP tab, Ratio 2:1, Attack 30 ms, Release auto, 1-2 dB reduction."),
                Step("Fruity Soft Clipper: raise Pre-gain for 1-3 dB of clipping. Watch the meter, listen for the 808 losing definition — back off when it does."),
                Step("Final Fruity Limiter on the LIMIT tab: set Ceiling to -1.0 dB, Attack around 1 ms, Release around 100 ms, and push Gain for 2-4 dB reduction."),
                Step("Alternative: Maximus on the Master preset does multiband limiting in one plugin, but it is easy to over-squash. Start from the Clear Master preset."),
                Step("Check LUFS with Wave Candy (Options > Add Wave Candy) or a third-party meter on the master.")
            ]
        ],
        laneNotes: [
            .trap: "808 defines the loudness. If the 808 is eating all the headroom, sidechain it against the kick and clip it individually before you touch the master limiter.",
            .underground: "Leave it dynamic. -9 or -10 LUFS with real transients beats a crushed -6 every time in this lane.",
            .hyperpop: "Clip on purpose, hard, and often multiple times in series. Just protect the true peak ceiling so streaming codecs do not add their own ugly distortion on top of your intentional distortion."
        ],
        callouts: [
            Callout(.warn, "True peak is not the same as sample peak. A file peaking at exactly 0.0 dBFS can hit +1.5 dBTP after MP3/AAC encoding, which distorts on playback."),
            Callout(.why, "A clipper removes the very tips of transients instantly, so the limiter's gain reduction never has to duck the whole mix. That is why clipped masters feel louder at the same LUFS.")
        ],
        checklist: [
            "Clipper before limiter",
            "Limiter doing only 2-4 dB",
            "True peak ceiling at -1.0 dBTP",
            "Integrated LUFS matches the lane target",
            "A/B against level-matched references",
            "Master chain makes it better, not just louder"
        ]
    )

    // MARK: - 14. Export

    static let export = Chapter(
        id: "ch14",
        number: 14,
        title: "Exporting",
        subtitle: "Settings for masters, distribution, features, and stems",
        minutes: 7,
        why: """
        Every destination wants a different file. Distributors want a 24-bit WAV at the project sample rate. Mastering \
        engineers want an unmastered mix with headroom. Features want dry stems with no processing. Sending the wrong \
        one is the most common way an amateur session announces itself.
        """,
        specs: [
            Spec("Master for distribution", "WAV, 24-bit, 48 kHz (or 44.1 if that is the project), no dither", "Only dither when converting DOWN to 16-bit."),
            Spec("Mix for a mastering engineer", "WAV 24-bit, master chain OFF, peaks at -6 dBFS", "Include a reference of your rough master."),
            Spec("Stems for a feature or a mixer", "WAV 24-bit, all starting at bar 1, dry or clearly labelled wet", "Same length, same start point, no exceptions."),
            Spec("MP3 for the group chat", "320 kbps", "Never send a 128 kbps as a demo."),
            Spec("Dither", "Only on the final 16-bit conversion, once", "Never dither twice."),
            Spec("Tails", "Leave 2-4 bars after the last sound", "Cut-off reverb tails sound broken."),
            Spec("Normalisation", "OFF", "You set your levels deliberately. Do not let the exporter undo that."),
            Spec("File naming", "Artist - Title (Mix v3) 48k24.wav", "Version numbers save relationships.")
        ],
        steps: [
            .ableton: [
                Step("Set the loop brace to cover the whole song plus 2-4 bars of tail, or select the full arrangement.", keys: "Cmd+A selects all"),
                Step("Open Export Audio/Video.", keys: "Cmd+Shift+R / Ctrl+Shift+R"),
                Step("Rendered Track: Master. Render Start / Length: confirm it covers the tail."),
                Step("File Type WAV, Sample Rate 48000, Bit Depth 24, Dither Options set to No Dither."),
                Step("Normalize: OFF. Convert to Mono: OFF."),
                Step("For stems: change Rendered Track to All Individual Tracks, and Live renders every track from bar 1 to the same length."),
                Step("Check the Loudness readout Live shows after the render if you want to confirm LUFS.")
            ],
            .logic: [
                Step("Set the cycle region over the full song plus the tail, or Logic will use the project length."),
                Step("File > Bounce > Project or Section.", keys: "Cmd+B"),
                Step("Destination: check PCM. File Format WAVE, Resolution 24 Bit, Sample Rate 48000, File Type Interleaved."),
                Step("Normalize: OFF. Set the End position to include the tail."),
                Step("Mode: Realtime is safer if you have external gear or finicky plugins. Offline is faster."),
                Step("For stems: File > Export > All Tracks as Audio Files. Check Include Volume/Pan Automation only if you want the mix moves baked in; uncheck Bypass Effect Plugins if you want processed stems."),
                Step("For MP3: in the same Bounce dialog, tick MP3 alongside PCM and set 320 kbps.")
            ],
            .fl: [
                Step("In the Playlist, select the time range of the song plus the tail (or make sure the song length marker sits past the last sound)."),
                Step("File > Export > Wave file.", keys: "Ctrl+R"),
                Step("Set Mode to Full song (or Song selection if you selected a range)."),
                Step("Bit depth 24-bit Int, Sample rate 48000 Hz. Dithering OFF unless exporting 16-bit."),
                Step("Resampling quality: set to at least 24-point sinc for the final export. HQ for all plugins: ON."),
                Step("Set Tail to Leave remainder so reverb and delay tails are not cut off."),
                Step("For stems: in the same dialog, enable Split mixer tracks. FL writes one file per mixer insert, all the same length.")
            ]
        ],
        laneNotes: [
            .trap: "Also export an instrumental (mute all vocal tracks) and an acapella. You will need both for shows, sync, and remixes, and nobody wants to reopen the session six months later.",
            .underground: "Export a version with the master chain off too. Some labels and vinyl cuts want the unlimited mix.",
            .hyperpop: "Export at the project sample rate and let the distributor convert. Your intentional aliasing and clipping artifacts can change character through a bad sample-rate conversion."
        ],
        callouts: [
            Callout(.warn, "Never export an MP3 as your master and then send it to a distributor. You cannot un-compress it, and the codec is applied twice."),
            Callout(.tip, "Always export an instrumental, an acapella, and a clean (no profanity) version at the same time as the master. Ten minutes now, hours saved later."),
            Callout(.why, "Dither adds a tiny amount of noise to mask quantisation error when reducing bit depth. Applied at 24-bit it does nothing but add noise, and applied twice it stacks.")
        ],
        checklist: [
            "24-bit WAV at project sample rate",
            "Normalisation off",
            "Dither off (unless going to 16-bit)",
            "2-4 bars of tail included",
            "Instrumental and acapella exported",
            "Filename includes version and specs",
            "Listened to the exported file, not the session"
        ]
    )

    // MARK: - 15. Troubleshooting

    static let trouble = Chapter(
        id: "ch15",
        number: 15,
        title: "Troubleshooting",
        subtitle: "The symptom, the actual cause, the fix",
        minutes: 6,
        why: """
        Most home-recording problems have one of about a dozen causes, and almost none of them are fixed with a \
        plugin. Work the list from the top — signal path first, then levels, then the room, then processing.
        """,
        specs: [
            Spec("No sound at all", "Track not armed, wrong input, phantom power off, monitoring off", "Check in that order."),
            Spec("Vocal sounds distant / roomy", "Too far from the mic, untreated wall behind you", "Move 2 inches closer before touching EQ."),
            Spec("Boomy and muddy", "Proximity effect from being too close, no high-pass", "Back off an inch, high-pass at 100 Hz."),
            Spec("Harsh S sounds", "On-axis placement, over-boosted highs", "Angle the mic 15 degrees off-axis first, de-ess second."),
            Spec("Popping P and B", "No pop filter or too close to it", "Filter 2-3 inches off the capsule, you 4-5 inches behind it."),
            Spec("Always behind the beat", "Latency", "Lower the buffer, check round-trip latency, use direct monitoring."),
            Spec("Singing flat", "Cue too loud", "Turn the headphones DOWN 3 dB and try again."),
            Spec("Singing sharp / straining", "Cue too quiet, or beat too loud vs vocal", "Raise the vocal in the cue, not the whole mix."),
            Spec("Crackles and dropouts", "Buffer too low for the plugin load", "Raise the buffer to 512+ once tracking is finished, or freeze tracks."),
            Spec("Vocal disappears in the car", "Not enough 3-6 kHz, or too much low mid", "Presence boost and a 250 Hz cut, then re-check."),
            Spec("Mix falls apart on phone speakers", "Everything is in the low end", "Check in mono, high-pass more aggressively."),
            Spec("Tuning sounds seasick", "Wrong key or scale", "Confirm the key, or switch to chromatic."),
            Spec("Buzz or hum", "Ground loop, USB power, or phone near the cable", "Try a different outlet, move the interface off the laptop power supply."),
            Spec("Take is fine but lifeless", "Overthinking, over-comping", "Go back to take 2. It is almost always take 2.")
        ],
        steps: [
            .ableton: [
                Step("Signal path check: Preferences > Audio (right device?), In/Out section (right input, mono?), track armed, Monitor set to In or Auto.", keys: "Cmd+Alt+I shows In/Out"),
                Step("CPU spikes: check the CPU meter top right. Freeze heavy tracks (right-click track header > Freeze Track)."),
                Step("Mono check: put a Utility on the Master and set Width to 0%."),
                Step("If a plugin has gone silent, deactivate and reactivate it.", keys: "Select the device and press 0")
            ],
            .logic: [
                Step("Signal path check: Settings > Audio > Devices, then the track's Input slot, Record Enable (R), Input Monitoring (I)."),
                Step("CPU spikes: open the CPU meter (click the Control Bar display), then enable Low Latency Mode or freeze tracks (the snowflake button in the track header)."),
                Step("Mono check: put the Gain plugin on the Stereo Out and click its Mono button."),
                Step("If audio engine errors keep appearing, raise the I/O Buffer Size and turn off Multithreading in Settings > Audio > General as a test.")
            ],
            .fl: [
                Step("Signal path check: F10 Audio Settings (right device?), Mixer insert IN dropdown, record arm dot lit."),
                Step("CPU spikes: check the CPU meter in the top bar, raise buffer length in F10, and use Tools > Macros > Switch smart disable for all plugins."),
                Step("Mono check: Fruity Stereo Shaper or Fruity Stereo Enhancer on the master with stereo separation pulled to mono."),
                Step("If FL is recording your effects into the file, move Edison to slot 1 or bypass the chain while recording.")
            ]
        ],
        laneNotes: [
            .trap: "If the vocal keeps getting swallowed, it is almost always the 808 and the vocal both living at 100-250 Hz. High-pass the vocal higher and sidechain the 808 to the kick.",
            .underground: "Noise floor is your enemy on quiet, dynamic records. Fix the room and the gain staging rather than reaching for a noise gate that chews the ends of words.",
            .hyperpop: "Aliasing and harshness usually come from stacking distortion without oversampling. Turn on HQ / oversampling in your distortion plugins before you blame the mic."
        ],
        callouts: [
            Callout(.tip, "Work the signal path in order, from the mic to the speakers. Nine times out of ten the problem is upstream of the plugin you are staring at."),
            Callout(.why, "You sing flat when the cue is too loud because your body uses your own perceived loudness to gauge effort. Loud in the cans means less effort, and less effort means less breath support, which means flat.")
        ],
        checklist: [
            "Signal path verified from mic to output",
            "Cue level ruled out as a pitch problem",
            "Latency ruled out as a timing problem",
            "Checked the mix in mono",
            "Checked on a phone speaker",
            "Went back and listened to take 2"
        ]
    )

    static let all: [Chapter] = [master, export, trouble]
}
