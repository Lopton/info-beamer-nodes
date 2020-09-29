# Interruptable video looper

This code plays `loop.mp4` in a loop until you tell it to interrupt with
another intermission video file.

# Matt Emerson 2020-09 Update

This original example was 6 years old and did not function on the latest Info-Beam Pi.
I have updated the code to function and have it working on my Raspberry Pi 4.
It loops one video continuously (loop.mp4) and then listens for UDP packets with a "looper/play:3" 
( 3 can be any integer) it then plays that new video with a number until it is finished then goes 
back to the looped video.

A friend of mine used it for halloween, he had some singing faces he projected on to some pumpkins. 
The loop was them just sitting there with background noise, then he wrote a Python script with a 
motion detector that, when triggered, sent the UDP packet with a random number equating to a video
in the project folder. Then the loop would be interrupted with the new video and the pumpkins would
perform. 

To accomplish all of this you need to:
1.) Install the Open Source version of Info-Beamer Pi (follow all instructions)
2.) If you want audio you need to set an enviormental variable telling the audio where to go:
INFOBEAMER_AUDIO_TARGET=hdmi
INFOBEAMER_AUDIO_TARGET=local
3.) It is best to ensure a sample info-beamer project runs as expected on the PI then move on to creating your own
4.) Create a folder (easiest in the home directory) that is the name of your project
5.) In that folder put the node.lua file, a loop.mp4 (or change file type in lua text if you want), and any number of intermission videos that are numbered
6.) sudo info-beamer nameOfFolder (i had to do sudo -E to get my env variables to be seen in sudo), your loop should start playing
7.) see Interrupting playback for how to send a UDP packet to cut in one of the intermission videos.


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
