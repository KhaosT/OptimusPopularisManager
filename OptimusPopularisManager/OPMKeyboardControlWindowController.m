//
//  OPMKeyboardControlWindowController.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/6/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMKeyboardControlWindowController.h"
#import "OPMUpdateQueue.h"

@interface OPMKeyboardControlWindowController ()
@property (weak) IBOutlet NSTextField *commandField;
@property (weak) IBOutlet NSTextField *brightnessField;
- (IBAction)sendCommand:(id)sender;
- (IBAction)updateBrightness:(NSSlider *)sender;

@end

@implementation OPMKeyboardControlWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)sendCommand:(id)sender {
    [[OPMUpdateQueue sharedQueue]addOperationWithBlock:^{
        [[NSFileManager defaultManager]removeItemAtPath:@"/Volumes/OptimusDisk/VOPTIMUS/order.sys" error:nil];
        [[[_commandField stringValue]dataUsingEncoding:NSUTF8StringEncoding] writeToFile:@"/Volumes/OptimusDisk/VOPTIMUS/order.sys" atomically:YES];
    }];
}

- (IBAction)updateBrightness:(NSSlider *)sender {
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    BOOL startingDrag = event.type == NSLeftMouseDown;
    BOOL endingDrag = event.type == NSLeftMouseUp;
    BOOL dragging = event.type == NSLeftMouseDragged;
    
    NSAssert(startingDrag || endingDrag || dragging, @"unexpected event type caused slider change: %@", event);
    
    if (startingDrag) {
        
    }
    
    _brightnessField.integerValue = sender.integerValue;
    
    if (endingDrag) {
        [[OPMUpdateQueue sharedQueue]addOperationWithBlock:^{
            [[NSFileManager defaultManager]removeItemAtPath:@"/Volumes/OptimusDisk/VOPTIMUS/order.sys" error:nil];
            NSString *command = [NSString stringWithFormat:@"b%03li",sender.integerValue];
            [[command dataUsingEncoding:NSUTF8StringEncoding] writeToFile:@"/Volumes/OptimusDisk/VOPTIMUS/order.sys" atomically:YES];
        }];
    }
}

@end
