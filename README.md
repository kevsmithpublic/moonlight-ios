#Moonlight iOS

#### 
[Moonlight](https://github.com/moonlight-stream) is an open source implementation of NVIDIA's GameStream, as used by the NVIDIA Shield, but built for iOS. Moonlight iOS allows you to stream your full collection of Steam games from
your powerful desktop computer to your iOS Device.

There are also versions for [Android](https://github.com/moonlight-stream/moonlight-android) and [PC](https://github.com/moonlight-stream/moonlight-pc). 

This is a quick and VERY dirty port of the code to get it up and running on the AppleTV.

<br/>
GTA V 
<br/>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=xRimuFTJ2fc" target="_blank"><img src="http://img.youtube.com/vi/xRimuFTJ2fc/0.jpg" alt="Mame AppleTV" width="240" height="180" border="10" /></a>
<br/>

<br/>
Dirt 4
<br/>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=byAP3uZbSEM" target="_blank"><img src="http://img.youtube.com/vi/byAP3uZbSEM/0.jpg" alt="Mame AppleTV" width="240" height="180" border="10" /></a>
<br/>

Compiling and Installing on ATV 4

- Only tested using real Apple TV, won't compile for simulator
- You'll need to remove the __TVOS_PROHIBITED for VideoDecoding (AVSampleBufferDisplayLayer) in ./AVFoundation.framework/AVSampleBufferDisplayLayer.h for it to compile






