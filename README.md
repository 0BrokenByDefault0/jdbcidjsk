# Record Room

An interactive iOS walkthrough for recording trap, underground hip-hop and hyperpop vocals —
built for **Ableton Live**, **Logic Pro** and **FL Studio**.

Fifteen steps from empty session to exported master, each with the exact buttons to press in your
DAW, the exact numbers to set, and the reason behind them.

## What's in it

**Walkthrough** — 15 steps across four phases:

| Phase | Steps |
| --- | --- |
| Set Up | Session setup · Mic and room · Gain and levels · Monitoring and latency |
| Track | The tracking chain · Recording the take · Punching in · Doubles, ad-libs and stacks |
| Shape | Tuning and pitch · Mixing the vocal · Effects and character · Bus structure and headroom |
| Finish | Master chain and loudness · Exporting · Troubleshooting |

Every step carries per-DAW instructions (with keyboard shortcuts and menu locations), hard target
numbers, lane-specific notes for trap / underground / hyperpop, and a checklist that saves your
progress.

**Tools** — live calculators:
- Input level check (peak dBFS → verdict)
- Round-trip latency from buffer size and sample rate
- Tempo maths: delay times, dotted-eighth, pre-roll length in seconds
- Headphone monitoring level guide
- Loudness targets per lane

**Reference** — DAW shortcut table, mic picker, export matrix, glossary.

## Building the unsigned IPA

The GitHub Actions workflow in `.github/workflows/build-ipa.yml` builds it on a macOS runner and
uploads `RecordRoom-unsigned.ipa` as a run artifact.

To build locally on a Mac:

```bash
brew install xcodegen
xcodegen generate
xcodebuild -project RecordRoom.xcodeproj -scheme RecordRoom \
  -configuration Release -sdk iphoneos -derivedDataPath build \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO build
mkdir -p Payload && cp -R build/Build/Products/Release-iphoneos/RecordRoom.app Payload/
zip -qry RecordRoom-unsigned.ipa Payload && rm -rf Payload
```

## Installing an unsigned IPA

The file has no code signature, so iOS will not install it directly. Sign it with your own free
Apple ID using one of:

- **Sideloadly** (Mac/Windows) — drag the IPA in, enter your Apple ID, install over USB
- **AltStore / SideStore** — install through AltServer
- **TrollStore** — on supported iOS versions, installs unsigned IPAs directly
- **Xcode** — open the project and run it on your own device

A free Apple ID signature lasts 7 days before it needs re-signing. A paid developer account lasts a year.

## Requirements

iOS 16 or later. Portrait on iPhone, any orientation on iPad.
