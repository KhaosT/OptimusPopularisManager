//
//  OPMKeyboard.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMKeyboard.h"
#import "OPMKeyboardView.h"
#import "OPMKeyButton.h"
#import "OPMUpdateQueue.h"

@interface OPMKeyboard (){
    NSMutableDictionary     *_keyDictionary;
    NSMutableData           *_layoutData;
    
    OPMKeyboardView         *_keyboardView;
}

@end

@implementation OPMKeyboard

+ (BOOL)isAvailable
{
    return [[NSFileManager defaultManager]fileExistsAtPath:@"/Volumes/OptimusDisk/VOPTIMUS/"];
}

- (OPMKeyboard *)initWithType:(NSString *)type
{
    if (self = [super init]) {
        _keyDictionary = [[NSMutableDictionary alloc]init];
        _layoutData = [[NSMutableData alloc]init];
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isStatic"]) {
            for (int i = 0; i<114; i++) {
                [_layoutData appendBytes:"\x01" length:1];
            }
        }else{
            for (int i = 0; i<114; i++) {
                [_layoutData appendBytes:"\x00" length:1];
            }
        }
        [self updateLayoutFile];
        _keyDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:type ofType:@"plist"]];
        for (int i = 78; i>0; i--) {
            NSString *key = [NSString stringWithFormat:@"%i",i];
            NSMutableDictionary *obj = [[_keyDictionary objectForKey:@"screenSizes"]objectForKey:key];
            NSInteger keyIndex = i;
            NSInteger dataSize = 16384;
            if ([obj objectForKey:@"dataSize"]) {
                dataSize = [[obj objectForKey:@"dataSize"]integerValue];
            }
            OPMKeyButton *button = [[OPMKeyButton alloc]initWithButtonIndex:keyIndex size:NSSizeFromString([obj objectForKey:@"screenSize"]) dataSize:dataSize];
            [button setText:[[[_keyDictionary objectForKey:@"defaultLayout"] objectForKey:key] objectForKey:@"keyName"]];
            [obj setObject:button forKey:@"button"];
        }
        _keyboardView = [[OPMKeyboardView alloc]initWithKeyboard:self Dictionary:_keyDictionary];
    }
    return self;
}

- (OPMKeyboardView *)keyboardView
{
    return _keyboardView;
}

- (void)updateLayoutFile
{
    [[OPMUpdateQueue sharedQueue]addOperationWithBlock:^{
        [[NSFileManager defaultManager]removeItemAtPath:@"/Volumes/OptimusDisk/VOPTIMUS/layout.sys" error:nil];
        [_layoutData writeToFile:@"/Volumes/OptimusDisk/VOPTIMUS/layout.sys" atomically:YES];
    }];
}

- (void)updateButton:(NSString *)index withImage:(NSImage *)image
{
    if ([[_keyDictionary objectForKey:@"screenSizes"] objectForKey:index]) {
        OPMKeyButton *button = [[[_keyDictionary objectForKey:@"screenSizes"] objectForKey:index]objectForKey:@"button"];
        [button setImage:image];
    }
}

@end
