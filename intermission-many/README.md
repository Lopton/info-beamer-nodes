# Interruptable video looper

This code plays `loop.mp4` in a loop until you tell it to interrupt with
another intermission video file.

# Lopton 2020-09 Update

This original example was 6 years old and did not function on the latest Info-Beam Pi.
I have updated the code to function and have it working on my Raspberry Pi 4.
It loops one video continuously (loop.mp4) and then listens for UDP packets with a number
it then plays that new video with a number until it is finished then goes back to the
looped video.

All of this is based on the incredible Info-Beam, which requires a license if used commercially

## Interrupting playback

Send a udp message to info-beamer containing the number of the video.
In this version the filename MUST BE a number.
Using CLI on a RPI4 works like this:

```
echo "looper/play:3" > /dev/udp/127.0.01/4444
```

Of course you can send that packet from any other programming language
with the ability to send UDP packets.

Unlike the original version of this triggering an intermission video 
while another intermission video is already running does NOT replace 
the running intermission video.
