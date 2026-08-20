import Foundation

enum ContentShape {

    // MARK: - 9. Tuning

    static let tuning = Chapter(
        id: "ch9",
        number: 9,
        title: "Tuning and Pitch",
        subtitle: "Auto-Tune settings, retune speed, and knowing the key",
        minutes: 8,
        why: """
        Retune speed is the entire sound. Slow and it is transparent correction. Fast and it is the hard snap that \
        defines modern rap and hyperpop. Getting the key and scale wrong is the number one reason tuning sounds \
        seasick — the tuner is snapping to notes that are not in the song.
        """,
        specs: [
            Spec("Find the key first", "Ask the producer, or run a key-detection plugin on the beat", "Guessing costs you the whole vocal."),
            Spec("Scale", "Start with the natural minor of the key", "Most trap and underground beats are minor. If it fights you, try chromatic and correct by hand."),
            Spec("Retune speed, transparent", "20-40 ms", "Fixes pitch without the audible snap."),
            Spec("Retune speed, modern rap", "5-15 ms", "That familiar tightened, slightly glassy sound."),
            Spec("Retune speed, hard tune", "0-3 ms", "Full T-Pain / hyperpop snap. Humanize at 0."),
            Spec("Humanize", "20-40% for melodic singing, 0% for hard tune", "Lets sustained notes drift naturally while fast notes still snap."),
            Spec("Formant correction", "ON when pitching more than 2 semitones", "OFF when you want the chipmunk or demon artifact on purpose."),
            Spec("Flex Pitch / Melodyne", "For fixing 2-3 problem notes", "Faster and more natural than fighting the tuner's settings.")
        ],
        steps: [
            .ableton: [
                Step("Consolidate the comped vocal into one clip first.", keys: "Cmd+J / Ctrl+J"),
                Step("Drop Auto-Tune (or your tuner of choice) on the vocal track AFTER the EQ and compressor."),
                Step("Set Key and Scale to match the beat. Set Retune Speed per the numbers above."),
                Step("For manual, surgical fixes without a third-party tuner: use Live's Pitch device on a duplicate, or better, warp the clip and use the Clip View Transpose and Detune controls on a split-out syllable."),
                Step("To print the tuned version: right-click the track > Freeze Track, then right-click again > Flatten. Keep the dry original on a deactivated duplicate track."),
                Step("Live 12 users: Auto Shift can do formant and pitch shifting for stacked layers.")
            ],
            .logic: [
                Step("Flatten the take folder first so the tuner sees one continuous region."),
                Step("For hard tune: insert Pitch Correction on the channel strip. Set Root and Scale, then pull Response all the way down for the snap, or up toward 100 for transparency."),
                Step("For surgical work: select the region, press Cmd+F to enable Flex, and choose Flex Pitch as the algorithm."),
                Step("Logic analyses the audio and shows every note as a block. Drag a block vertically to correct pitch, and use the six hotspots on each note for Pitch Drift, Vibrato, Gain, and Formant."),
                Step("Use the Pitch Correction slider in the Region inspector to correct all notes toward the grid by a percentage instead of note by note."),
                Step("Vocal Transformer is the plugin for deliberate formant abuse — pitch and formant on separate controls.")
            ],
            .fl: [
                Step("Consolidate the comp first: right-click the playlist track name > Consolidate this track."),
                Step("For live/hard tune: put Pitcher on the VOX mixer insert. Set the key at the top, set Speed to minimum for hard snap, and turn Formant preservation on or off depending on the effect you want."),
                Step("For surgical fixes: open the audio clip in NewTone (right-click the clip > Edit > Edit in NewTone, or load NewTone as an editor)."),
                Step("In NewTone, drag notes to pitch, use the Vibrato and Glide controls per note, and hit the Center Pitch button to snap the selected notes."),
                Step("Drag the corrected result out of NewTone back into the playlist, or render it from the editor."),
                Step("Keep the dry clip muted on a track below as a safety copy.")
            ]
        ],
        laneNotes: [
            .trap: "Retune 8-15 ms, natural minor, humanize 15-25%. Tight enough to shine, loose enough to keep your delivery. Tune ad-libs harder than the lead — that contrast is the trick.",
            .underground: "Often none at all, or 30-40 ms just to catch the flat notes. If the whole aesthetic is raw honesty, hard tune fights the record.",
            .hyperpop: "Retune 0 ms, humanize 0, and go looking for artifacts instead of hiding them. Then stack a formant-shifted layer (+3 to +8 semitones of formant with pitch unchanged) underneath the lead."
        ],
        callouts: [
            Callout(.warn, "Tune AFTER comping and punching, never before. Tuning first bakes in a decision you cannot edit around."),
            Callout(.tip, "If the tuner sounds like it is fighting you, the scale is probably wrong. Switch to chromatic and see if the seasick warble stops."),
            Callout(.why, "Formant correction keeps the resonance of your throat fixed while the pitch moves. Turn it off and a pitched-up voice sounds like a cartoon — which is sometimes exactly what you want.")
        ],
        checklist: [
            "Key and scale confirmed against the beat",
            "Retune speed matched to the lane",
            "Comping and punches done first",
            "Dry version kept as a safety copy",
            "Ad-libs tuned separately from the lead",
            "Checked for warble on sustained notes"
        ]
    )

    // MARK: - 10. Mixing the vocal

    static let mixing = Chapter(
        id: "ch10",
        number: 10,
        title: "Mixing the Vocal",
        subtitle: "EQ, compression, de-essing, saturation",
        minutes: 12,
        why: """
        The order matters. Subtractive EQ first so the compressor is not reacting to mud. Compression next to control \
        dynamics. De-essing after compression, because compression pushes sibilance up. Tone EQ and saturation last, \
        shaping what is now a consistent signal. Do it out of order and you will chase your tail all night.
        """,
        specs: [
            Spec("High-pass", "80-120 Hz", "Higher for thin voices and busy 808 beats, lower for deep voices you want weight on."),
            Spec("Mud cut", "-2 to -4 dB, wide Q, around 200-400 Hz", "This is where boxiness lives."),
            Spec("Honk cut", "-2 to -3 dB, narrow Q, sweep 800 Hz - 1.2 kHz", "Only if it is honking. Do not cut by default."),
            Spec("Presence boost", "+2 to +4 dB, wide, 3-6 kHz", "This is intelligibility. Push it until the words cut, then back off 1 dB."),
            Spec("Air shelf", "+2 to +3 dB shelf at 12-16 kHz", "Do this AFTER de-essing or you will amplify the S sounds."),
            Spec("Comp stage 1", "Slow, 3:1, 3-4 dB GR, attack 10-20 ms, release 80-120 ms", "Levelling. Opto or VCA character."),
            Spec("Comp stage 2", "Fast, 4:1 to 8:1, 3-5 dB GR, attack 1-3 ms, release 40-60 ms", "Peak catching. FET / 1176 character."),
            Spec("Total gain reduction", "6-10 dB across both stages", "Two gentle stages sound far better than one brutal one."),
            Spec("De-esser", "5-9 kHz band, 3-5 dB reduction on the harshest S only", "If it is reducing constantly, the threshold is too low."),
            Spec("Saturation", "5-15% mix on a tape or tube plugin", "Adds harmonics so the vocal cuts without more volume."),
            Spec("Vocal level vs beat", "Lead peaks about 3-6 dB above the loudest beat element", "Trust the words test: can you hear every word at low volume?")
        ],
        steps: [
            .ableton: [
                Step("Order on the vocal track: EQ Eight (subtractive) > Glue Compressor > Compressor (fast) > EQ Eight (tone) > Saturator."),
                Step("EQ Eight: high-pass at 100 Hz, then find mud by boosting a narrow band 6 dB and sweeping 200-500 Hz until it sounds worst, then cut it 3 dB and widen the Q."),
                Step("Glue Compressor: Ratio 4, Attack 10 ms, Release Auto, threshold for 3-4 dB reduction."),
                Step("Compressor in Peak mode: Ratio 4, Attack 1 ms, Release 50 ms, 3-4 dB more reduction."),
                Step("De-ess with a second Compressor set to Sidechain mode: enable the sidechain EQ, set it to a bell around 7 kHz, and turn on the EQ audition to find the exact sibilance frequency."),
                Step("Saturator at the end: Drive 3-6 dB, Soft Clip or Analog Clip curve, Dry/Wet 100% with low drive rather than a low mix."),
                Step("Group the vocals.", keys: "Cmd+G / Ctrl+G")
            ],
            .logic: [
                Step("Channel strip order: Channel EQ > Compressor (slow) > Compressor (fast) > DeEsser 2 > Channel EQ (tone) > Phat FX or Tape."),
                Step("Channel EQ: engage the high-pass, set to 100 Hz. Use the Analyzer button to see the mud visually while you sweep."),
                Step("Compressor 1: Studio VCA model, Ratio 3:1, Attack 15 ms, Release 100 ms, 3-4 dB reduction."),
                Step("Compressor 2: FET model (the 1176-style one), Ratio 4:1, Attack 1 ms, Release 50 ms, 3-4 dB reduction."),
                Step("DeEsser 2: set Mode to Split, drag the Detection frequency into the sibilant range (around 7 kHz) and lower Threshold until the meter moves only on the S sounds."),
                Step("Second Channel EQ: presence boost at 4 kHz, air shelf at 14 kHz."),
                Step("Select all vocal tracks and make a Summing Stack.", keys: "Cmd+Shift+D")
            ],
            .fl: [
                Step("Mixer insert order: Fruity Parametric EQ 2 > Fruity Limiter in COMP mode > Fruity Compressor > de-esser > Fruity Parametric EQ 2 (tone) > Fruity Waveshaper or Soundgoodizer."),
                Step("Fruity Parametric EQ 2: band 1 as a high-pass at 100 Hz. Use the built-in spectrum analyser to see the buildup."),
                Step("Fruity Limiter, COMP tab: Ratio around 3:1, Attack 15 ms, Release 100 ms, drag Threshold down for 3-4 dB of reduction."),
                Step("Fruity Compressor after it: Ratio 4:1, Attack 1 ms, Release 50 ms, 3-4 dB more."),
                Step("De-ess with Maximus: use the high band only, set the band crossover so the high band starts around 6 kHz, and pull the high band compression curve down."),
                Step("Add character with Fruity Waveshaper (gentle S curve) or a touch of Soundgoodizer on setting A."),
                Step("Route all vocal inserts to one bus insert for group processing.")
            ]
        ],
        laneNotes: [
            .trap: "Bright and forward. Push the 3-6 kHz presence, de-ess hard, keep total GR near 8-10 dB so the vocal never moves. High-pass at 110-120 Hz so it never fights the 808.",
            .underground: "Darker and glued. Less presence boost, more saturation, high-pass lower at 80 Hz. Let it sit IN the beat — a little reverb and less compression keeps it human.",
            .hyperpop: "Everything is extreme. Air shelf +4 or more, aggressive clipping instead of limiting, a bitcrusher on a parallel send, and often a hard-clipped vocal bus. Distortion is a tone control here, not a mistake."
        ],
        callouts: [
            Callout(.tip, "The low-volume test: turn the mix down until it is barely audible. If you can still hear every word, your vocal balance is right."),
            Callout(.warn, "Do not fix a problem with a boost that a cut would solve. If the vocal is dull, first check whether something in the beat is masking 3 kHz."),
            Callout(.why, "De-essing goes AFTER compression because compression raises quiet sibilance up toward the loud parts. De-ess first and the compressor undoes your work.")
        ],
        checklist: [
            "High-pass set",
            "Mud swept and cut, not guessed",
            "Two gentle compression stages, 6-10 dB total",
            "De-esser only moving on S sounds",
            "Presence and air added after de-essing",
            "Saturation for cut instead of more volume",
            "Passes the low-volume words test"
        ]
    )

    // MARK: - 11. Effects

    static let effects = Chapter(
        id: "ch11",
        number: 11,
        title: "Effects and Character",
        subtitle: "Delay, reverb, width, and lane-specific damage",
        minutes: 9,
        why: """
        Reverb and delay place the vocal in space. In modern rap the vocal needs to stay in your face, so the trick \
        is short, filtered, and rhythmic — you want the tail to disappear before the next word, so you get depth \
        without wash. Everything goes on sends so you can automate it per section.
        """,
        specs: [
            Spec("Delay time", "1/8 dotted or 1/4 note, synced to tempo", "Dotted eighth is the modern default because it fills without clashing."),
            Spec("Delay feedback", "15-25%", "Two or three repeats maximum."),
            Spec("Delay filtering", "High-pass at 300-500 Hz, low-pass at 4-6 kHz", "Filtered repeats sit behind the vocal instead of on top of it."),
            Spec("Delay level", "Just audible when soloed against the vocal, then back off 1 dB", ""),
            Spec("Reverb type", "Plate for vocals", "Rooms sound like a bad recording, halls sound like a ballad."),
            Spec("Reverb decay", "0.8-1.4 s", "Shorter for fast flows, longer for hooks."),
            Spec("Pre-delay", "20-40 ms", "Keeps the front of the word dry and intelligible."),
            Spec("Reverb high cut", "6-8 kHz", "Dark tails do not add sibilance to the room."),
            Spec("Reverb level", "10-20% wet on the send", "Automate it up on the last word of each bar instead of leaving it up."),
            Spec("Width", "Doubles and ad-libs wide, lead mono", "The lead stays center and mono. Always.")
        ],
        steps: [
            .ableton: [
                Step("Create two Return tracks.", keys: "Cmd+Alt+T / Ctrl+Alt+T, twice"),
                Step("Return A: Ping Pong Delay or Delay. Set to 3/16 (dotted eighth), Feedback 20%, and use the device's filter section to band-pass around 300 Hz - 5 kHz."),
                Step("Return B: Reverb. Decay 1.2 s, Predelay 25 ms, and pull the High Cut (in the Output section) down to 7 kHz. Dry/Wet 100% since it is on a return."),
                Step("Send the lead vocal to each return with the A and B knobs in the mixer."),
                Step("Automate the send: click Return A automation lane on the vocal track and draw the send up on the last word of a bar.", keys: "A toggles automation view"),
                Step("Throw delay: automate the send to jump for a single word, then back to zero."),
                Step("Width on the doubles bus: add a Utility and push Width to 130-150%, never on the lead.")
            ],
            .logic: [
                Step("On the vocal channel strip, click a Sends slot and choose Bus 1 (delay) and Bus 2 (reverb). Logic creates Aux channels automatically."),
                Step("On the delay Aux: Tape Delay or Stereo Delay. Set the note value to 1/8 dotted, Feedback 20%, and use the built-in low cut / high cut in the plugin."),
                Step("On the reverb Aux: ChromaVerb, Plate preset. Decay 1.2 s, Predelay 25 ms, and pull the Damping / high-cut down."),
                Step("Set send level to about -18 dB to start."),
                Step("Automate the send: on the vocal track, open the automation menu and choose the Send 1 Level parameter, then draw throws.", keys: "A toggles automation"),
                Step("Width: Stereo Spread or Direction Mixer on the doubles bus only.")
            ],
            .fl: [
                Step("Pick two empty mixer inserts, name them DELAY and VERB."),
                Step("On DELAY: Fruity Delay 3. Set Time to 3/16 with tempo sync on, Feedback around 20%, and use the built-in filter to cut lows and highs."),
                Step("On VERB: Fruity Reeverb 2. Choose a plate-style preset, Decay 1.2 s, Predelay 25 ms, and pull the HIGH CUT down to about 7 kHz."),
                Step("Route the VOX insert to both: right-click the send arrow at the bottom of the DELAY and VERB inserts while VOX is selected, then set the send amount with the small knob on the arrow."),
                Step("Automate a throw: right-click the send knob > Create automation clip, then draw the throw in the playlist."),
                Step("Width: Fruity Stereo Enhancer on the doubles bus. Keep the lead insert mono.")
            ]
        ],
        laneNotes: [
            .trap: "Dotted eighth delay with heavy filtering, plus a very short plate. Automate a big throw on the last word before the hook. Ad-libs get more verb than the lead so they sit behind it.",
            .underground: "More room, less delay. A slightly longer, darker plate that glues the vocal into a dusty loop. Some records use a mono spring or a lo-fi reverb on purpose.",
            .hyperpop: "Everything is fair game: bitcrush on a parallel send, formant-shifted doubles, chorus on the stack bus, granular stutters, and reverse reverb builds. Automate a hard filter sweep and a stutter edit into every drop."
        ],
        callouts: [
            Callout(.tip, "Filter your reverb and delay returns HARD. Unfiltered returns are why home mixes sound washy and cluttered."),
            Callout(.warn, "Keep the lead vocal mono. A widened lead loses its center image and collapses badly on phone speakers and club systems.")
        ],
        checklist: [
            "Delay and reverb are on sends",
            "Delay is tempo-synced and filtered",
            "Reverb is a short plate with pre-delay",
            "Returns high-cut around 7 kHz",
            "Throws automated, not left static",
            "Lead is mono, layers are wide"
        ]
    )

    // MARK: - 12. Gain structure

    static let structure = Chapter(
        id: "ch12",
        number: 12,
        title: "Bus Structure and Headroom",
        subtitle: "Getting the mix ready for the master",
        minutes: 6,
        why: """
        A master chain can only work with what you feed it. If your mix bus is already slamming 0 dBFS, the limiter \
        has nothing to do but distort. Leave real headroom, glue at the bus level rather than on individual tracks, \
        and reference constantly.
        """,
        specs: [
            Spec("Mix bus peak before master chain", "-6 to -3 dBFS", "Use a gain plugin at the top of the master to pull it down, not the fader."),
            Spec("Vocal bus glue comp", "1.5:1 to 2:1, 1-2 dB GR", "Barely moving. It is glue, not control."),
            Spec("Beat bus", "Route the instrumental to its own bus", "So you can duck it, EQ it, or drop 1 dB under the vocal in one move."),
            Spec("Sidechain duck (optional)", "1-2 dB of beat ducking triggered by the vocal", "Fast attack, 80-150 ms release. Subtle, or it pumps."),
            Spec("Reference tracks", "2-3 commercial songs in the same lane", "Level-match them to your mix before comparing. Louder always sounds better."),
            Spec("Check on", "Phone speaker, car, earbuds, laptop", "Rap lives on phone speakers. If it does not work there, it does not work.")
        ],
        steps: [
            .ableton: [
                Step("Group your vocal tracks into a Vocal bus.", keys: "Cmd+G / Ctrl+G"),
                Step("Group beat tracks (or the beat stem) into a Beat bus."),
                Step("On the Vocal bus: Glue Compressor, Ratio 2, Attack 10 ms, Release Auto, threshold for 1-2 dB reduction."),
                Step("Add a Utility at the top of the Master chain and use its Gain to pull the whole mix down to -6 dBFS peak."),
                Step("For the sidechain duck: put a Compressor on the Beat bus, enable Sidechain, and set the audio-from source to the Vocal bus. Ratio 2, Attack 1 ms, Release 120 ms, 1-2 dB reduction."),
                Step("Drop reference tracks onto a muted audio track and A/B constantly.")
            ],
            .logic: [
                Step("Select vocal tracks and create a Summing Stack.", keys: "Cmd+Shift+D"),
                Step("Do the same for the instrumental tracks."),
                Step("On the vocal stack's channel strip: Compressor, Platinum Digital or Studio VCA, Ratio 2:1, 1-2 dB reduction."),
                Step("On the Stereo Out, put a Gain plugin FIRST and trim so the mix peaks at -6 dBFS."),
                Step("Sidechain duck: Compressor on the beat stack, set the Side Chain menu (top right of the plugin) to the vocal bus."),
                Step("Add the Loudness Meter plugin on the Stereo Out to watch LUFS as you go.", at: "Audio FX > Metering > Loudness Meter")
            ],
            .fl: [
                Step("Route all vocal inserts to one bus insert, and all beat inserts to another. Select the source inserts, then right-click the destination insert's routing arrow > Route to this track only."),
                Step("On the vocal bus: Fruity Limiter in COMP mode, Ratio 2:1, 1-2 dB reduction."),
                Step("On the master insert, put Fruity Balance FIRST and pull the volume down until the master peaks at -6 dB."),
                Step("Sidechain duck: on the beat bus add Fruity Limiter (COMP mode), enable its sidechain input, and route the vocal bus to the beat bus as a sidechain send (right-click the send arrow > Sidechain to this track)."),
                Step("Load reference tracks into a muted playlist track routed to a separate insert so the master chain does not process them.")
            ]
        ],
        laneNotes: [
            .trap: "Vocal sits proud. 1-2 dB of sidechain duck on the beat is standard and nobody hears it consciously — they just hear the words.",
            .underground: "Almost no ducking. The vocal being slightly buried is part of the aesthetic. Glue the whole mix harder instead.",
            .hyperpop: "Hard clip the mix bus before the limiter instead of just limiting. Vocals often sit ON TOP of a fully crushed instrumental, which means less headroom everywhere and that is intentional."
        ],
        callouts: [
            Callout(.warn, "Level-match your references. An unmatched commercial master is 6-10 dB louder than your mix and will always win the comparison for the wrong reason."),
            Callout(.tip, "Mix at low volume most of the time. Check loud briefly, at the end, for 30 seconds.")
        ],
        checklist: [
            "Vocals and beat on separate buses",
            "Mix bus peaking -6 to -3 dBFS",
            "Bus glue comp doing 1-2 dB",
            "References loaded and level-matched",
            "Checked on a phone speaker",
            "Sidechain duck subtle or off"
        ]
    )

    static let all: [Chapter] = [tuning, mixing, effects, structure]
}
