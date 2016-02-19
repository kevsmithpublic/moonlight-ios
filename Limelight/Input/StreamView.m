//
//  StreamView.m
//  Moonlight
//
//  Created by Cameron Gutman on 10/19/14.
//  Copyright (c) 2014 Moonlight Stream. All rights reserved.
//

#import "StreamView.h"
#include <Limelight.h>
#import "OnScreenControls.h"
#import "DataManager.h"
#import "ControllerSupport.h"

@implementation StreamView {
    CGPoint touchLocation;
    BOOL touchMoved;
    OnScreenControls* onScreenControls;
    
    float xDeltaFactor;
    float yDeltaFactor;
    float screenFactor;

    UITapGestureRecognizer *_playPauseRecognizer;
    UITapGestureRecognizer *_selectRecognizer;

    ControllerSupport *_controllerSupport;
}

- (void) setMouseDeltaFactors:(float)x y:(float)y {
    xDeltaFactor = x;
    yDeltaFactor = y;
    
    screenFactor = [[UIScreen mainScreen] scale];
}

- (void) setupOnScreenControls:(ControllerSupport*)controllerSupport swipeDelegate:(id<EdgeDetectionDelegate>)swipeDelegate {
    _controllerSupport = controllerSupport;

    onScreenControls = [[OnScreenControls alloc] initWithView:self controllerSup:controllerSupport swipeDelegate:swipeDelegate];
    DataManager* dataMan = [[DataManager alloc] init];
    OnScreenControlsLevel level = (OnScreenControlsLevel)[[dataMan retrieveSettings].onscreenControls integerValue];
    
    if (level == OnScreenControlsLevelAuto) {
        [controllerSupport initAutoOnScreenControlMode:onScreenControls];
    }
    else {
        Log(LOG_I, @"Setting manual on-screen controls level: %d", (int)level);
        [onScreenControls setLevel:level];
    }

    [self clearGestureRecognizers];

    _playPauseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remotePlayPause:)];
    _playPauseRecognizer.allowedPressTypes = @[@(UIPressTypePlayPause)];
    [self.window addGestureRecognizer:_playPauseRecognizer];

    _selectRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteSelected:)];
    _selectRecognizer.allowedPressTypes = @[@(UIPressTypeSelect)];
    [self.window addGestureRecognizer:_selectRecognizer];
}

- (void)dealloc {
    [self clearGestureRecognizers];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    Log(LOG_D, @"Touch down");
    if (![onScreenControls handleTouchDownEvent:touches]) {
        UITouch *touch = [[event allTouches] anyObject];
        touchLocation = [touch locationInView:self];
        touchMoved = false;
    }
}

/*
-(void) pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    for (UIPress *item in presses) {
        if (item.type== UIPressTypePlayPause) {
            Log(LOG_D, @"Play pause");
            return;
        }
    }
    
}
 */

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![onScreenControls handleTouchMovedEvent:touches]) {
        if ([[event allTouches] count] == 1) {
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint currentLocation = [touch locationInView:self];
            
            if (touchLocation.x != currentLocation.x ||
                touchLocation.y != currentLocation.y)
            {
                int deltaX = currentLocation.x - touchLocation.x;
                int deltaY = currentLocation.y - touchLocation.y;
                
                deltaX *= xDeltaFactor * screenFactor;
                deltaY *= yDeltaFactor * screenFactor;
                
                if (deltaX != 0 || deltaY != 0) {
                    LiSendMouseMoveEvent(deltaX, deltaY);
                    touchMoved = true;
                    touchLocation = currentLocation;
                }
            }
        } else if ([[event allTouches] count] == 2) {
            CGPoint firstLocation = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
            CGPoint secondLocation = [[[[event allTouches] allObjects] objectAtIndex:1] locationInView:self];
            
            CGPoint avgLocation = CGPointMake((firstLocation.x + secondLocation.x) / 2, (firstLocation.y + secondLocation.y) / 2);
            if (touchLocation.y != avgLocation.y) {
                LiSendScrollEvent(avgLocation.y - touchLocation.y);
            }
            touchMoved = true;
            touchLocation = avgLocation;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    Log(LOG_D, @"Touch up");
    if (![onScreenControls handleTouchUpEvent:touches]) {
        /*if (!touchMoved) {
            if ([[event allTouches] count]  == 2) {
                Log(LOG_D, @"Sending right mouse button press");
                
                LiSendMouseButtonEvent(BUTTON_ACTION_PRESS, BUTTON_RIGHT);
                
                // Wait 100 ms to simulate a real button press
                usleep(100 * 1000);
                
                LiSendMouseButtonEvent(BUTTON_ACTION_RELEASE, BUTTON_RIGHT);
                
                
            } else {
                Log(LOG_D, @"Sending left mouse button press");
                
                LiSendMouseButtonEvent(BUTTON_ACTION_PRESS, BUTTON_LEFT);
                
                // Wait 100 ms to simulate a real button press
                usleep(100 * 1000);
                
                LiSendMouseButtonEvent(BUTTON_ACTION_RELEASE, BUTTON_LEFT);
            }
        }*/
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)clearGestureRecognizers {
    [_playPauseRecognizer.view removeGestureRecognizer:_playPauseRecognizer];
    [_selectRecognizer.view removeGestureRecognizer:_selectRecognizer];
}

- (void)remotePlayPause:(UITapGestureRecognizer *)playPause {
    Log(LOG_D, @"Play/Pause pressed");

    Controller *controller = _controllerSupport.firstPlayerController;

    [_controllerSupport setButtonFlag:controller flags:SPECIAL_FLAG];

    [_controllerSupport updateFinished:controller];

    // Wait 100 ms to simulate a real button press
    usleep(100 * 1000);

    [_controllerSupport clearButtonFlag:controller flags:SPECIAL_FLAG];

    [_controllerSupport updateFinished:controller];
}

- (void)remoteSelected:(UITapGestureRecognizer *)gestureRecongizer {
    Log(LOG_D, @"Sending left mouse button press");

    LiSendMouseButtonEvent(BUTTON_ACTION_PRESS, BUTTON_LEFT);

    // Wait 100 ms to simulate a real button press
    usleep(100 * 1000);

    LiSendMouseButtonEvent(BUTTON_ACTION_RELEASE, BUTTON_LEFT);
}


@end
