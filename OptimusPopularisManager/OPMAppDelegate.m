//
//  OPMAppDelegate.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMAppDelegate.h"
#import "OPMKeyboard.h"
#import "OPMKeyboardControlWindowController.h"
#import "OPMKeyboardView.h"

@interface OPMAppDelegate (){
    OPMKeyboard *_keyboard;
    OPMKeyboardControlWindowController *_keyboardControl;
}

@end

@implementation OPMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([OPMKeyboard isAvailable]) {
        _keyboard = [[OPMKeyboard alloc]initWithType:@"Popularis"];
        [_window.contentView addSubview:[_keyboard keyboardView]];
        _keyboardControl = [[OPMKeyboardControlWindowController alloc]initWithWindowNibName:@"OPMKeyboardControlWindowController"];
        [_keyboardControl showWindow:nil];
    }else{
        NSLog(@"Keyboard is not available");
    }
}

@end
