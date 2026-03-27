# Video Optimization Setup Guide

## Option A: Quick Setup (Recommended)

### Step 1: Install FFmpeg
- **Windows 11/10 with winget:**
  ```powershell
  winget install ffmpeg
  ```

- **Alternative (Manual Download):**
  - Visit: https://ffmpeg.org/download.html
  - Download Windows build
  - Extract to Program Files or add to PATH

### Step 2: Run Optimization Script
Open PowerShell in project root directory and run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\optimize_video.ps1
```

## Option B: Use HandBrake GUI

### Step 1: Download & Install
- Visit: https://handbrake.fr/downloads.php
- Download HandBrake (GUI)
- Install normally

### Step 2: Manual Encoding
1. Open HandBrake
2. Source: Select `assets/video/vid1.mp4`
3. Presets: Choose "Fast 720p30"
4. Video:
   - Codec: H.264 (x264)
   - Quality: CRF 28
   - Resolution: 640px width
5. Audio:
   - Codec: AAC
   - Bitrate: 96 kbps
6. Save as `vid1_optimized.mp4`
7. Move back to `assets/video/vid1.mp4`

## Option C: Online Video Converter
If installation is difficult:
1. Visit: https://cloudconvert.com/mp4-to-mp4
2. Upload `vid1.mp4`
3. Settings:
   - Resolution: 640px
   - Bitrate: Auto (low)
4. Download optimized version
5. Replace original

## Result
Your loading video will:
- ✅ Load instantly (no lag)
- ✅ Smooth playback during scanning
- ✅ Use less bandwidth
- ✅ Work flawlessly on all devices

## Technical Specs (Already in Code)
The BarcodeScanScreen now:
- Wraps video player in error handling
- Uses AspectRatio for clean scaling
- Checks initialization before playback
- Falls back to progress spinner if video fails
- Applies `fit: BoxFit.cover` for optimal display
