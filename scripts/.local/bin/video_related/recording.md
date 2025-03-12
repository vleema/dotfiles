# Instructions

These are the steps to record video with these scripts.

1. Turn off composition with `picom`. This avoids any **flickering** in the recorded video.
2. Choose between recording a screen (`window_select_video_capture`) or the entire desktop (`desktop_video_capture`) scripts. Note that for recording the entire desktop there are two scripts, on for the notebook monitor and another for the extra (HDMI) monitor.
3. Decide whether the recording should have the webcam or not. To activate the webcam press `Super+F4`. Once the webcam is active as a window, it's recommended to make it a float window with `Super+backspace` and then resize and position the window as you see fit (`Super+mouse`). Alternatively, make the window **sticky** so that it follows any jump to another workspace. The sticky feature is toggle with `Super+s`.
4. To stop recording keep open another terminal with the command `killall ffmpeg` ready to go. When the recording is done, just press enter in that terminal window and the recording immediately stops.
5. All recording are stored in the folder `Videos/capture`.
6. If the video and audio of the webcam is not in sync, call the script `audio_correction` providing the correct arguments (look inside the script for further instructions on how to pass arguments to the script).
7. The recording are done in a lossless video format with the `ultrafast` profile. This means the output file will probably be very large. In that case it's possible to reduce the video size and still keep its lossless feature by calling the encoding command that is available inside any of the `desktop_video_capture` scripts.

That's it!!
