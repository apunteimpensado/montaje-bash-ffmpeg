#!/bin/bash

# Step 1: Create timecode.txt with the cutting information
cat > timecode.txt << 'EOF'
video_001.mp4, 00:00:10.0, 00:00:20.0, corte01.mp4
video_002.mp4, 00:00:08.0, 00:00:11.0, corte02.mp4
video_003.mp4, 00:00:02.0, 00:00:05.0, corte03.mp4
video_004.mp4, 00:01:03.0, 00:01:25.0, corte04.mp4
EOF

echo "Created timecode.txt"

# Step 2: Read timecode.txt and cut videos using ffmpeg
echo "Starting video cutting process..."
gawk -F, '{cmd="ffmpeg -ss " $2 " -to " $3 " -i " $1 " -c copy " $4 ""; print "Processing: " $1; system(cmd)}' timecode.txt

# Step 3: Create montage.txt with the list of cut videos
echo "Creating montage list..."
ls -1 corte*.mp4 | sed 's/^/file /' > montaje.txt

echo "Created montaje.txt with the following content:"
cat montaje.txt

# Step 4: Concatenate all cut videos into final video
echo "Concatenating videos..."
ffmpeg -f concat -safe 0 -i montaje.txt -c copy terminado.mp4

echo "Process completed! Final video: terminado.mp4"