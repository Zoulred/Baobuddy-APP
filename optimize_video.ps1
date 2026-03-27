# Video Optimization Script for Loading Overlay
# Converts assets/video/vid1.mp4 to optimized H.264 format for smooth mobile playback
# Run this after installing FFmpeg or HandBrake

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$videoPath = Join-Path $projectRoot "assets\video\vid1.mp4"
$backupPath = Join-Path $projectRoot "assets\video\vid1_backup.mp4"
$outputPath = Join-Path $projectRoot "assets\video\vid1_optimized.mp4"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Loading Video Optimization Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if video exists
if (-not (Test-Path $videoPath)) {
    Write-Host "❌ Error: vid1.mp4 not found at $videoPath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found video: $videoPath" -ForegroundColor Green

# Check for FFmpeg
$ffmpegPath = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Path
if (-not $ffmpegPath) {
    Write-Host "`n❌ FFmpeg not found! Please install it first:" -ForegroundColor Red
    Write-Host "`nOption 1 (Recommended): Install FFmpeg"
    Write-Host "  Download: https://ffmpeg.org/download.html"
    Write-Host "  OR use: winget install ffmpeg"
    Write-Host "`nOption 2: Install HandBrake CLI"
    Write-Host "  Download: https://handbrake.fr/downloads.php"
    Write-Host "  Use: HandBrakeCLI.exe instead of ffmpeg in commands below"
    Write-Host "`nAfter installation, run this script again.`n"
    exit 1
}

Write-Host "✅ FFmpeg found at: $ffmpegPath" -ForegroundColor Green

# Create backup
Write-Host "`n📦 Creating backup..." -ForegroundColor Yellow
Copy-Item $videoPath $backupPath -Force
Write-Host "✅ Backup saved: $backupPath" -ForegroundColor Green

# Optimize video
Write-Host "`n⏳ Optimizing video (this may take a few minutes)..." -ForegroundColor Yellow
Write-Host "   Parameters:" -ForegroundColor Cyan
Write-Host "   - Codec: H.264 (libx264)" -ForegroundColor Cyan
Write-Host "   - Preset: slow (best compression)" -ForegroundColor Cyan
Write-Host "   - Quality: CRF 28 (high quality)" -ForegroundColor Cyan
Write-Host "   - Resolution: 640px width (maintains aspect ratio)" -ForegroundColor Cyan
Write-Host "   - Audio: AAC @ 96kbps (low bandwidth)" -ForegroundColor Cyan
Write-Host "   - Optimized: faststart flag for streaming" -ForegroundColor Cyan

$ffmpegCmd = @(
    "-i", $videoPath,
    "-c:v", "libx264",
    "-preset", "slow",
    "-crf", "28",
    "-vf", "scale=640:-2",
    "-c:a", "aac",
    "-b:a", "96k",
    "-movflags", "+faststart",
    $outputPath,
    "-y"
)

try {
    & $ffmpegPath $ffmpegCmd 2>&1 | ForEach-Object {
        # Show only important lines
        if ($_ -match "frame=|Duration|time=|speed=") {
            Write-Host $_ -ForegroundColor Gray
        }
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Optimization complete!" -ForegroundColor Green
        
        # Compare file sizes
        $originalSize = (Get-Item $videoPath).length / 1MB
        $optimizedSize = (Get-Item $outputPath).length / 1MB
        $compression = [math]::Round((1 - ($optimizedSize / $originalSize)) * 100, 1)
        
        Write-Host "`n📊 File Size Comparison:" -ForegroundColor Cyan
        Write-Host "   Original:  $([math]::Round($originalSize, 2)) MB" -ForegroundColor Gray
        Write-Host "   Optimized: $([math]::Round($optimizedSize, 2)) MB" -ForegroundColor Gray
        Write-Host "   Compression: $compression%" -ForegroundColor Green
        
        # Replace original
        Write-Host "`n🔄 Replacing original video..." -ForegroundColor Yellow
        Remove-Item $videoPath -Force
        Rename-Item $outputPath $videoPath -Force
        Write-Host "✅ Original video replaced with optimized version" -ForegroundColor Green
        
        Write-Host "`n🎉 Done! Video is now optimized for smooth mobile playback." -ForegroundColor Green
        Write-Host "   - No lag during scanning" -ForegroundColor Green
        Write-Host "   - Smooth loading overlay" -ForegroundColor Green
        Write-Host "   - Reduced bandwidth usage" -ForegroundColor Green
        
    } else {
        Write-Host "`n❌ FFmpeg encoding failed" -ForegroundColor Red
        Write-Host "   Exit code: $LASTEXITCODE" -ForegroundColor Red
    }
} catch {
    Write-Host "`n❌ Error running FFmpeg: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n========================================`n" -ForegroundColor Cyan
