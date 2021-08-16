# useful

```
# Listen to mic on remote SSH device
ssh root@remote arecord | aplay

# View /dev/video0 on remote SSH device
ssh root@remote ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mplayer - -idle -demuxer matroska

```
