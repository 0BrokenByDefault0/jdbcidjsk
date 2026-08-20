import Foundation

enum ContentTrack {

    // MARK: - 5. Tracking chain

    static let chain = Chapter(
        id: "ch5",
        number: 5,
        title: "The Tracking Chain",
        subtitle: "What to print, what to only monitor",
        minutes: 6,
        why: """
        There are two chains: the one that gets written to the file, and the one you hear. Keep the printed file as \
        close to dry as you can — a little compression to catch peaks is fine, everything else is a decision you are \
        locking in before you know what the song needs. Meanwhile, monitor through the FULL sound you are chasing, \
        because performance follows what you hear.
        """,
        specs: [
            Spec("Printed to file", "Dry, or dry + gentle compression", "Ratio 3:1, 3-4 dB gain reduction maximum."),
            Spec("Tracking comp attack", "5-10 ms", "Fast enough to catch peaks, slow enough to keep consonant snap."),
            Spec("Tracking comp release", "40-80 ms, or auto", "Should breathe with the tempo, not pump."),
            Spec("Tracking HPF", "80 Hz, 12 dB/octave", "Kills rumble and proximity buildup without thinning the voice."),
            Spec("Monitored only", "Auto-Tune, reverb, delay, saturation, doubler", "All of it lives after the record point."),
            Spec("Exception", "Hard-tune as a sound", "If the tuned sound IS the part, print a tuned version AND keep the dry take on a parallel track.")
        ],
        steps: [
            .ableton: [
                Step("On the armed vocal track, add EQ Eight and switch the first band to a 48 dB/oct high-pass at 80 Hz. Everything you add to an armed track is monitored, NOT printed — Live always records the raw input."),
                Step("Add Glue Compressor after it: Ratio 4, Attack 3 ms, Release 0.4 s or Auto, Threshold set for 3-4 dB of gain reduction on your loudest line."),
                Step("Add Auto-Tune or Live's built-in tuning after the compressor if you are performing into tune."),
                Step("Add a Send to your reverb Return track, around -18 dB."),
                Step("Remember: Live records PRE-effects by default. Your file stays clean while you hear all of this.")
            ],
            .logic: [
                Step("On the vocal channel strip, slot 1: Channel EQ with the high-pass engaged at 80 Hz."),
                Step("Slot 2: Compressor, choose the Studio VCA or FET model. Ratio 3:1, Attack 8 ms, Release 60 ms, threshold for 3-4 dB reduction."),
                Step("Slot 3 onward: Pitch Correction or Auto-Tune, then any character plugins. These are monitored only."),
                Step("IMPORTANT: Logic records the input BEFORE channel strip plugins unless you deliberately bounce or use Record with Effects hardware. Your file stays dry."),
                Step("Add a send to Bus 1 (your reverb aux) at about -18 dB for the cue.")
            ],
            .fl: [
                Step("On the VOX mixer insert, slot 1: Fruity Parametric EQ 2 with a high-pass at 80 Hz."),
                Step("Slot 2: Fruity Limiter in COMP mode (click the COMP tab). Ratio around 3:1, Attack 8 ms, Release 60 ms, gain for 3-4 dB reduction."),
                Step("Slot 3: Pitcher or Auto-Tune for monitored pitch correction."),
                Step("WARNING: FL records the mixer insert INCLUDING its effects if you record from the mixer track. To keep the file dry, either bypass the FX chain while recording or record into Edison placed in the FIRST slot before everything else."),
                Step("Put Edison in slot 1 and arm it — Edison captures pre-chain, giving you the dry file while the rest of the chain feeds your ears.")
            ]
        ],
        laneNotes: [
            .trap: "Print dry. Trap vocals get 2-4 stages of compression in the mix and you do not want to be stacking on top of a squashed source.",
            .underground: "You can print a little saturation if it is a committed aesthetic choice and you have the confidence. Otherwise a Saturator or tape plugin in the mix gets you there with an undo button.",
            .hyperpop: "Print dry AND print the hard-tuned version on a second track in the same pass. You want the artifacts of the live performance into tune, plus a clean source for the stacks you will pitch later."
        ],
        callouts: [
            Callout(.warn, "FL Studio is the odd one out: it will happily bake your monitoring chain into the recorded file. Use Edison in the first slot, or bypass FX before you hit record."),
            Callout(.tip, "Save your monitoring chain as a preset or a track template. Recall it in 5 seconds instead of rebuilding vibes every session.")
        ],
        checklist: [
            "High-pass at 80 Hz in the chain",
            "Compressor doing 3-4 dB max",
            "Auto-Tune monitored at performance settings",
            "Reverb on a send, not inline",
            "Confirmed my DAW is printing DRY",
            "Chain saved as a preset"
        ]
    )

    // MARK: - 6. Taking the take

    static let take = Chapter(
        id: "ch6",
        number: 6,
        title: "Recording the Take",
        subtitle: "Full passes, take lanes, and comping",
        minutes: 8,
        why: """
        Record full passes first, always. Punching before you have a complete performance means you are stitching \
        together fragments that never shared the same energy. Three or four full takes give you a comp with \
        consistent tone and momentum, and they tell you which lines actually need a punch.
        """,
        specs: [
            Spec("Full passes before punching", "3-4", "Take 1 is a warm-up. Take 2-3 are usually the keepers."),
            Spec("Count-in", "1-2 bars", "Two bars for slower underground flows, one for trap."),
            Spec("Comping", "Line by line, not word by word", "Word-level comping sounds robotic and mismatched in tone."),
            Spec("Crossfade at edits", "5-20 ms", "Enough to hide the seam, short enough not to smear a consonant."),
            Spec("Edit points", "In the silence BEFORE a breath, not on the word", "")
        ],
        steps: [
            .ableton: [
                Step("Arm the vocal track and set Monitor to Auto."),
                Step("Set the loop brace over the section you are recording, but leave Loop OFF for full passes."),
                Step("Hit the global record button, then Play.", keys: "F9 to arm record, Space to roll"),
                Step("For multiple takes on one track, turn on Take Lanes — right-click the track header and choose Show Take Lanes.", keys: "Cmd+Alt+U / Ctrl+Alt+U"),
                Step("Each new pass over the same region lands on a new take lane. Comp by dragging the top edge of the take you want into the main lane, or use the lane selector."),
                Step("Split at edit points.", keys: "Cmd+E / Ctrl+E"),
                Step("Add fades: hover the top corner of a clip and drag, or select clips and press Cmd+Alt+F for automatic fades."),
                Step("When the comp is done, select everything and consolidate it into one clean clip.", keys: "Cmd+J / Ctrl+J")
            ],
            .logic: [
                Step("Record-enable the vocal track.", keys: "R on the track header"),
                Step("Press Record.", keys: "R"),
                Step("Record 3-4 passes. Logic stacks them into a Take Folder automatically."),
                Step("Click the Take Folder to open the lanes, then drag across the take you want on a line-by-line basis — this is Quick Swipe Comping."),
                Step("Cycle between comps with the Take Folder menu (top left of the folder) to compare."),
                Step("When happy: Take Folder menu > Flatten and Merge. That collapses the comp into one region with crossfades baked in."),
                Step("Adjust crossfade length by dragging the edit boundary, or set the default in Preferences > Audio > Editing.")
            ],
            .fl: [
                Step("Arm the mixer insert. Set the record mode to Audio into the playlist as an audio clip (right-click the record button)."),
                Step("Turn ON Options > Loop recording if you want each pass on its own playlist track."),
                Step("Press Record, then Play.", keys: "R then Space"),
                Step("Each pass drops onto a new playlist track underneath the last one."),
                Step("Comp by muting/slicing clips: use the Slice tool (or Ctrl+drag with the slice tool) at line boundaries and delete the takes you do not want."),
                Step("Right-click a clip and use Fade in / Fade out handles at the top corners to smooth every edit point."),
                Step("Consolidate: right-click the playlist track name > Consolidate this track, which renders the comp to a single audio clip.")
            ]
        ],
        laneNotes: [
            .trap: "Energy is the product. If take 2 is technically messier but hits harder, use take 2 and punch the two words that missed.",
            .underground: "Keep the breaths and the room. Comping out every inhale makes an underground vocal sound like a jingle. Breaths are rhythm.",
            .hyperpop: "Comp for pitch consistency more than tone — hard tune will flatten tone differences anyway, but wildly different source pitches make Auto-Tune snap to different notes."
        ],
        callouts: [
            Callout(.tip, "Name your takes as you go (T1 fire, T2 flat ending). Twenty minutes later you will not remember which was which."),
            Callout(.warn, "Do not comp with the mix loud and hyped. Comp at a low, boring level so you are judging performance, not excitement.")
        ],
        checklist: [
            "3-4 full passes recorded",
            "Take lanes / take folder enabled",
            "Comped line by line",
            "Crossfades on every edit",
            "Comp flattened / consolidated",
            "Takes labelled"
        ]
    )

    // MARK: - 7. Punch-ins

    static let punch = Chapter(
        id: "ch7",
        number: 7,
        title: "Punching In",
        subtitle: "When to punch, where to place the punch, how to make it invisible",
        minutes: 9,
        why: """
        A punch-in replaces a piece of a take without re-recording the whole thing. The reason punches sound obvious \
        is almost never the performance — it is the boundary. Punch in during silence, roll from at least a bar \
        earlier so you catch the energy, and match your mic distance exactly. Do that and nobody can hear the seam.
        """,
        specs: [
            Spec("Pre-roll before the punch", "1-2 bars", "You need to be inside the flow before the punch point arrives."),
            Spec("Punch-in point", "In the gap before the line, right after the previous breath", "Never mid-word, never on a consonant."),
            Spec("Punch-out point", "In the silence after the line, before the next breath", ""),
            Spec("Mic distance", "Identical to the original take", "Mark your spot with tape on the floor. Seriously."),
            Spec("When to punch", "Wrong word, blown pitch on one line, a pop, a stumble", "If more than a third of the bar is wrong, redo the whole bar."),
            Spec("When NOT to punch", "Energy is flat across the take", "Energy cannot be punched. Perform it again.")
        ],
        steps: [
            .ableton: [
                Step("Show the Punch In and Punch Out buttons in the Arrangement transport bar — they are the two small brackets next to the loop switch."),
                Step("Set the loop brace to cover ONLY the section you want replaced. The punch points are the loop brace edges."),
                Step("Enable Punch-In and Punch-Out. Now recording only writes inside the brace."),
                Step("Move the playhead 1-2 bars BEFORE the brace start so you get pre-roll."),
                Step("Arm the track, hit global record, then play.", keys: "F9 then Space"),
                Step("Live records onto a new take lane inside the brace. Audition, and if it is good, drag it into the main lane."),
                Step("Fix the seam: zoom in, nudge the clip edge into the silence, and add a 10 ms fade on both sides.", keys: "Cmd+Alt+F for auto-fades")
            ],
            .logic: [
                Step("Turn on Autopunch mode. Click the Autopunch button in the Control Bar (if it is hidden, right-click the Control Bar > Customize Control Bar and Display, then check Autopunch)."),
                Step("A red Autopunch stripe appears in the ruler. Drag its left and right edges to the exact punch-in and punch-out points."),
                Step("Set the pre-roll: enable Cycle off, then just position the playhead 1-2 bars early, or use Settings > Recording to set a fixed count-in."),
                Step("Record-enable the track and hit Record.", keys: "R"),
                Step("Logic rolls, monitors the existing audio, then swaps to the live input exactly inside the stripe."),
                Step("The punch lands as a new take in the take folder. Open the folder and swipe the new take in over the old one."),
                Step("Nudge and crossfade the boundary, then Flatten and Merge.")
            ],
            .fl: [
                Step("FL has no dedicated punch mode. Use one of two workflows."),
                Step("Method A, playlist punch: select the punch region in the playlist timeline, put a fresh playlist track under the original, start playback 1-2 bars early with the mixer insert armed, and record. Then slice the new clip to the punch boundaries and mute the corresponding piece of the old take."),
                Step("Method B, Edison punch (more precise): put Edison on the VOX mixer insert, open it, click its record arm, and set Edison's recording mode. Perform the line, then drag the region you want straight from Edison into the playlist."),
                Step("Either way: slice with the slice tool at the punch boundaries.", keys: "Ctrl+drag with the Slice tool"),
                Step("Add fade in / fade out handles at the top corners of both clips so the crossover is smooth."),
                Step("Consolidate the playlist track when the punch is locked in.")
            ]
        ],
        laneNotes: [
            .trap: "Punch ad-libs separately on their own track, not into the main vocal. Ad-libs want their own treatment, panning and timing anyway.",
            .underground: "Match the room, not just the level. If you punched three days later with the window open, the noise floor changes and the punch will be audible even at matched volume.",
            .hyperpop: "Punch BEFORE tuning, always. Punching a section into an already-tuned vocal means the tuner sees two different sources and treats them differently."
        ],
        callouts: [
            Callout(.tip, "The tape-on-the-floor trick: mark where you stand, mark the mic stand height. A punch two inches closer than the original take has more low end and will never sit right."),
            Callout(.warn, "Never punch with a different headphone level. Your delivery is calibrated to what you hear, and a louder cue makes you punch a quieter, flatter line."),
            Callout(.why, "You roll from 1-2 bars early because your body needs to be in the pocket before the punch point. Cold punches sound cold.")
        ],
        checklist: [
            "Punch points sit in silence",
            "1-2 bars of pre-roll",
            "Mic distance and height matched",
            "Cue level unchanged from the original take",
            "Crossfades at both boundaries",
            "Punched before tuning, not after",
            "Listened back in full, not just to the punch"
        ]
    )

    // MARK: - 8. Stacks

    static let stacks = Chapter(
        id: "ch8",
        number: 8,
        title: "Doubles, Ad-libs and Stacks",
        subtitle: "Building the vocal arrangement",
        minutes: 8,
        why: """
        The lead take is one layer of maybe six. Doubles create width and weight, ad-libs create motion and hype, \
        and stacks turn a hook into an event. The rule that decides whether it sounds professional: every layer is \
        PERFORMED again, not copy-pasted and detuned.
        """,
        specs: [
            Spec("Hook doubles", "2 performed doubles, hard panned L/R at 100%", "Sit them 6-10 dB under the lead."),
            Spec("Verse doubles", "Usually just the last 2-4 words of each bar", "Full-verse doubles blur the words."),
            Spec("Ad-lib track count", "2-3 separate tracks", "Left ad-libs, right ad-libs, center hype."),
            Spec("Ad-lib panning", "L 40-70% and R 40-70%", "Keep the main hype centered."),
            Spec("Octave-up stack", "8-14 dB under the lead", "Falsetto or head voice, not a pitch shifter."),
            Spec("Octave-down stack", "10-16 dB under", "Adds weight. High-pass it at 120 Hz so it does not fight the 808."),
            Spec("Timing tightness", "Within 10-20 ms of the lead", "Tighter than that on purpose sounds fake; looser sounds sloppy.")
        ],
        steps: [
            .ableton: [
                Step("Duplicate the vocal track for each layer.", keys: "Cmd+D / Ctrl+D"),
                Step("Rename tracks so you can see the arrangement at a glance.", keys: "Cmd+R / Ctrl+R"),
                Step("Group the vocal tracks into one folder for easy bus processing.", keys: "Cmd+G / Ctrl+G"),
                Step("Pan doubles with the Pan control in the mixer, or add a Utility device and use its Width and Pan controls for more precision."),
                Step("Align a loose double: split it at the word, drag it into place, and crossfade. Or drop the double on a track and use the Warp markers to pull individual syllables onto the lead."),
                Step("Print stacked layers to one track when the arrangement is locked: select the tracks, right-click, Freeze, then Flatten.")
            ],
            .logic: [
                Step("Duplicate the track with its channel strip settings.", keys: "Cmd+D"),
                Step("Record each double as a real performance, not a copy."),
                Step("Select the vocal tracks and create a Track Stack for group control.", keys: "Cmd+Shift+D, choose Summing Stack"),
                Step("Pan doubles in the channel strip. Hold Option and click the pan knob to reset to center."),
                Step("Tighten a loose double with Flex Time: press the Flex button, choose Slicing or Monophonic, and drag transients into alignment.", keys: "Cmd+F toggles Flex view"),
                Step("Colour-code ad-lib tracks so the arrangement is readable.", keys: "Option+C opens the colour palette")
            ],
            .fl: [
                Step("Record each layer to its own playlist track, and route each to its own mixer insert."),
                Step("Select several mixer inserts and route them all to one bus insert: hold Ctrl and click the inserts, then right-click the routing arrow on the destination bus and choose Route to this track only."),
                Step("Pan with the pan knob at the top of each mixer insert, or insert Fruity Stereo Shaper for finer control."),
                Step("Tighten doubles by nudging clips in the playlist with the arrow keys, or by slicing and dragging with snap set to none."),
                Step("Use Fruity Balance for quick level trims per layer without touching the fader.")
            ]
        ],
        laneNotes: [
            .trap: "Standard trap hook: lead, 2 hard-panned doubles, an octave-down for weight, and an ad-lib track answering the end of every bar. Ad-libs are half the song.",
            .underground: "Fewer, drier layers. One tight double on the punchlines, maybe a single hype ad-lib. Over-stacking kills the conversational feel that makes it work.",
            .hyperpop: "Stack aggressively — 4-8 layers, some pitched up an octave with formant shifted UP for the chipmunk-angel tone, some pitched down. Detune layers 5-15 cents against each other on purpose. Chorus on the stack bus."
        ],
        callouts: [
            Callout(.warn, "Copy-pasting the lead and detuning it is not a double. Phase cancellation makes it thin, and it will not widen. Perform it again."),
            Callout(.tip, "Record all doubles for the whole song in one pass while your voice and mic position are identical. Do not come back to doubles tomorrow.")
        ],
        checklist: [
            "Doubles performed, not copied",
            "Hook doubles hard-panned L/R",
            "Ad-libs on their own tracks",
            "Octave stacks high-passed",
            "Layers grouped into a bus",
            "Tracks named and colour-coded"
        ]
    )

    static let all: [Chapter] = [chain, take, punch, stacks]
}
