# Project footage (the bench)

The landing-page bench and each case study's phone play footage from
`assets/projects/`. Every file is optional: the site checks the asset manifest
at startup and falls back without errors.

| What exists | The phone shows |
|---|---|
| video | the video, muted, looping (on `/` it advances to the next project when it ends) |
| screenshots, no video | the four screenshots in turn, a cross-fade every 2.5 s |
| nothing | an "Awaiting footage" screen with the project name |

## File names

Put the files in `assets/projects/`, named by the project's prefix
(`ProjectMedia.prefix` in `lib/core/content/portfolio_content.dart`):

```
assets/projects/Risala-video.mp4
assets/projects/Risala-1.png   # also the poster: shown first, before the video is ready
assets/projects/Risala-2.png
assets/projects/Risala-3.png
assets/projects/Risala-4.png
assets/projects/Risala-splash.json   # optional Lottie splash, not played yet
```

Known prefixes: `Risala` (Al-Risala Academy) and `Attend`. To add a project,
give its `CaseStudy` a `media: ProjectMedia(prefix: ..., captions: [...])`.
Captions (one per screenshot) and timed Inspect notes (`InspectNote(seconds,
label)`) live there too.

After adding or renaming files, restart the app (`flutter run`) so the asset
manifest is rebuilt.

## Recording

- Record on a real device or emulator at the same size each time (the frame is
  a Pixel 8, 412×915):
  - `scrcpy --record in.mp4`, or
  - `adb shell screenrecord /sdcard/in.mp4` then `adb pull /sdcard/in.mp4`
- Clean status bar: turn on Android demo mode
  (`adb shell settings put global sysui_demo_allowed 1`, then the `demo` broadcasts),
  or crop it. The frame draws its own status bar over the top ~3.5% of the screen.
- Demo data only: no real names, phone numbers or student records.
- Content: the app's splash, then one 10–15 s main flow. Start on the screen
  that `<Prefix>-1.png` shows, so the poster and the first frame match.

## Compressing the video

About 540 px wide, 30 fps, no audio, faststart, ≤ 2 MB:

```
ffmpeg -i in.mp4 -vf "scale=540:-2,fps=30" -c:v libx264 -crf 28 -preset slow -an -movflags +faststart <Prefix>-video.mp4
```

If it is still over 2 MB, raise `-crf` (30, 32) or trim the clip.

## Screenshots

- Same device, same size as the video (portrait, 412×915 logical, any pixel ratio).
- PNG, four per project, in story order.
- Run them through a compressor (e.g. `oxipng -o 4 --strip all *.png` or
  TinyPNG) before committing.
