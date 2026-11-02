#!/usr/bin/env python3
"""Build a Koala Sampler song (.koala) from a pack's picks.json.

A .koala file is an uncompressed zip that holds:
  sampler/<id>.wav      audio, 48 kHz stereo 32-bit float
  sampler/sampler.json  pad settings (pads "0".."63") plus sample metadata
  sequence.json         tempo and 32 pattern slots
  song.json, fx.json    song and effects settings

The layout comes from a song exported by Koala 2.0.15 on iOS. Fields are
written with the same names, types and order Koala uses, including flags
like "oneshot" that Koala stores as the strings "true"/"false".

Usage:
  build_koala.py picks.json AUDIO_DIR OUT.koala   # real pack from audio files
  build_koala.py --test-tones picks.json OUT.koala # tone per pad, no audio needed
"""

import argparse
import json
import math
import struct
import subprocess
import sys
import zipfile
from datetime import datetime
from pathlib import Path

SAMPLE_RATE = 48000
CHANNELS = 2
BANKS = "ABCD"
PADS_PER_BANK = 16
EMPTY_SEQUENCES = 32

# Koala's default bus effect settings, copied from an exported song.
FX = {
    "buses": {
        "strawberry": [
            {"name": "CUTTER", "value": 0.0},
            {"name": "REVERSE", "value": 0.0},
            {"name": "DUB", "value": 0.0},
            {"name": "TEMPO DELAY", "value": 0.0},
            {"name": "TALKBOX", "value": 0.0},
            {"name": "VIBROFLANGE", "value": 0.5},
            {"name": "DIRTY", "value": 0.0},
            {"name": "COMPRESSOR", "value": 0.0},
        ],
        "vanilla": [
            {"name": "CRUSH", "value": 0.0},
            {"name": "PITCH", "value": 0.5},
            {"name": "COMB", "value": 0.0},
            {"name": "RING", "value": 0.0},
            {"name": "REVERB", "value": 0.0},
            {"name": "STUTTER", "value": 0.0},
            {"name": "GATE", "value": 0.0},
            {"name": "FILTER", "value": 0.5},
        ],
    },
    "hold": False,
}


def decode_audio(path):
    """Decode any audio file to interleaved 48 kHz stereo float32 bytes."""
    result = subprocess.run(
        ["ffmpeg", "-v", "error", "-i", str(path),
         "-f", "f32le", "-acodec", "pcm_f32le",
         "-ac", str(CHANNELS), "-ar", str(SAMPLE_RATE), "-"],
        capture_output=True, check=True,
    )
    return result.stdout


def tone_audio(index, seconds=0.35):
    """A short plucked sine, one semitone higher per pad, for test songs."""
    freq = 110.0 * 2 ** (index / 12)
    frames = int(SAMPLE_RATE * seconds)
    out = bytearray()
    for n in range(frames):
        t = n / SAMPLE_RATE
        value = 0.5 * math.sin(2 * math.pi * freq * t) * math.exp(-6 * t)
        out += struct.pack("<ff", value, value)
    return bytes(out)


def wav_bytes(pcm):
    """Wrap float32 PCM in the plain 44-byte WAV header Koala writes."""
    block_align = CHANNELS * 4
    header = b"RIFF" + struct.pack("<I", 36 + len(pcm)) + b"WAVE"
    header += b"fmt " + struct.pack(
        "<IHHIIHH", 16, 3, CHANNELS, SAMPLE_RATE,
        SAMPLE_RATE * block_align, block_align, 32)
    header += b"data" + struct.pack("<I", len(pcm))
    return header + pcm


def eq():
    return {
        "enabled": "false",
        "hi": {"freq": 8000.0, "gain": 0.0, "q": 1.0, "type": "highshelf"},
        "lo": {"freq": 100.0, "gain": 0.0, "q": 1.0, "type": "lowshelf"},
        "mid": {"freq": 1000.0, "gain": 0.0, "q": 1.0, "type": "peaking"},
    }


def pad_entry(index, sample_id, frames, label):
    last = frames - 1
    return {
        "attack": 0.00011000000085914508,
        "bus": -1,
        "channel": 0,
        "chokeGroup": 0,
        "cyclicPeriod": 20,
        "end": last,
        "eq": eq(),
        "hasLoopPoint": "false",
        "label": label,
        "loopPoint": -1,
        "looping": "false",
        "muted": False,
        "oneshot": "true",
        "pad": str(index),
        "pan": 0.5,
        "pingpong": "false",
        "pitch": 0.0,
        "release": 0.0,
        "reverse": "false",
        "sampleId": sample_id,
        "start": 0,
        "stretch": 1,
        "stretchLength": 0.0,
        "stretching": False,
        "tone": 0.0,
        "type": "sample",
        "vol": 1.0,
        "xfade": 200,
        "zoomEnd": last,
        "zoomStart": 0,
    }


def sample_entry(sample_id, bpm, created):
    return {
        "id": sample_id,
        "metadata": {
            "bpm": float(bpm or 0.0),
            "creationTime": created,
            "musicalKey": "",
            "originalPath": "",
            "rootNote": "none",
            "source": "Imported",
            "tags": [],
        },
    }


def song_json(name):
    return {
        "availableSpace": "",
        "currSongIsICloud": False,
        "inputFXShowing": False,
        "isPro": False,
        "keyboardMode": False,
        "keyboardScale": "Chromatic",
        "mixerOut": False,
        "name": name,
        "numSessions": 0,
        "osVersion": "",
        "padEditorShowing": False,
        "padGrid": 1,
        "platform": "iOS",
        "section": 1,
        "selectedPad": 0,
        "sequencePage": 0,
        "version": "2.0.15 (5)",
    }


def sequence_json(bpm):
    empty = {
        "lastViewedPath": "",
        "noteSequence": {"pattern": {"notes": None, "numBars": 1}},
        "parameterSequences": None,
    }
    return {
        "autoPlay": "off",
        "beatsPerBar": 4,
        "bpm": float(bpm),
        "currSequenceId": 0,
        "quantizeDivision": 24,
        "quantizing": True,
        "seqSnap": "None",
        "sequences": [empty] * EMPTY_SEQUENCES,
        "swing": 0.0,
    }


def pad_index(bank, pad):
    return BANKS.index(bank) * PADS_PER_BANK + (pad - 1)


def dump(obj):
    return json.dumps(obj, indent="\t").encode()


def stored(name):
    info = zipfile.ZipInfo(name, date_time=datetime.now().timetuple()[:6])
    info.compress_type = zipfile.ZIP_STORED
    info.create_system = 0  # MS-DOS, as in Koala's own exports
    return info


def build(picks, out_path, audio_for):
    """Write a .koala song; audio_for(bank, pad_info, index) returns PCM."""
    created = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    pads, samples, wavs = [], [], []
    sample_id = 1
    for bank in BANKS:
        for info in picks["banks"][bank]["pads"]:
            index = pad_index(bank, info["pad"])
            pcm = audio_for(bank, info, index)
            frames = len(pcm) // (CHANNELS * 4)
            label = f"{bank}{info['pad']:02d} {info['role']}"
            pads.append(pad_entry(index, sample_id, frames, label))
            samples.append(sample_entry(sample_id, info.get("bpm"), created))
            wavs.append((f"sampler/{sample_id}.wav", wav_bytes(pcm)))
            sample_id += 1

    with zipfile.ZipFile(out_path, "w") as z:
        for name, data in wavs:
            z.writestr(stored(name), data)
        z.writestr(stored("sampler/sampler.json"),
                   dump({"pads": pads, "samples": samples}))
        z.writestr(stored("song.json"), dump(song_json(picks["pack"])))
        z.writestr(stored("fx.json"), dump(FX))
        z.writestr(stored("sequence.json"),
                   dump(sequence_json(picks["song_bpm"])))
    return len(pads)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--test-tones", action="store_true",
                        help="put a test tone on every pad instead of real audio")
    parser.add_argument("picks", type=Path)
    parser.add_argument("paths", nargs="+", type=Path,
                        help="AUDIO_DIR OUT.koala, or just OUT.koala with --test-tones")
    args = parser.parse_args()

    picks = json.loads(args.picks.read_text())
    if args.test_tones:
        if len(args.paths) != 1:
            parser.error("--test-tones takes picks.json and OUT.koala")
        out = args.paths[0]
        picks = {**picks, "pack": f"{picks['pack']} (test tones)"}
        count = build(picks, out, lambda bank, info, index: tone_audio(index))
    else:
        if len(args.paths) != 2:
            parser.error("expected picks.json AUDIO_DIR OUT.koala")
        audio_dir, out = args.paths
        missing = [i["file"] for b in picks["banks"].values() for i in b["pads"]
                   if not (audio_dir / i["file"]).exists()]
        if missing:
            sys.exit("missing audio files:\n  " + "\n  ".join(missing))
        count = build(picks, out,
                      lambda bank, info, index: decode_audio(audio_dir / info["file"]))
    print(f"wrote {out} with {count} pads")


if __name__ == "__main__":
    main()
