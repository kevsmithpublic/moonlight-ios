#Moonlight tvOS

#### 
[Moonlight](https://github.com/moonlight-stream) is an open source implementation of NVIDIA's GameStream, as used by the NVIDIA Shield, but built for iOS. Moonlight iOS allows you to stream your full collection of Steam games from
your powerful desktop computer to your iOS Device.

There are also versions for [Android](https://github.com/moonlight-stream/moonlight-android) and [PC](https://github.com/moonlight-stream/moonlight-pc). 

This is a quick and VERY dirty port of the code to get it up and running on the AppleTV.

<h1>Demos</h1>

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

<h1>Compiling</h1>

Xcode 7.2 (tvOS 9.1)
 
- Set Build Target for Moonlight tvOS/generic tvOS Device (or real Apple TV)
 
- Fix any issues with profiles using the "Fix issues button"
 
- You will receive 3 compilation issues due to the following not being available in tvOS
 
AVQueuedSampleBufferRenderingStatusFailed, AVSampleBufferDisplayLayer

How to work around this issue 

- Look at the 3 errors, expand the first error to show the grey exclamation mark
 
- Click the grey exclamation mark to take you directly to the API definition located in AVSampleBufferDisplayLayer.h

We need to change permissions of the Headers directory to make the alterations to compile the code

You can do this via

- right click AVSampleBufferDisplayLayer.h and show in Finder and navigate up one directory to Headers
 
- Or goto Finder and go to the directory /Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk/System/Library/Frameworks/AVFoundation.framework

- right click on Header and Get Info

- Change the Sharing & Permissions so everyone has Read & Write

- Click the padlock bottom right - enter admin password
Change everyone to Read & Write
Hit X top left to close window
 
- Go back to Xcode and the AVSampleBufferDisplayLayer.h  and change the lines
 
41 Remove __TVOS_PROHIBITED<br/>
46 Remove __TVOS_PROHIBITED<br/>
 
The project will now compile and run on your Apple TV 4 !
 

<h1>How to use</h1>

- The App should show you PC when selected
- Connect your Mifi controller before using the App
- Select your PC via the remote controller
- Enter the Pair code on your PC
- You should now see all games which can be streamed
- Select a game via remote
- App will start
- You should now be able to use your Mifi controller to control the game
- Remote acts as a mouse controller, use left click on controller to left click mouse


