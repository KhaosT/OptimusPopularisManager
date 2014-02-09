//
//  OPMKeyboardView.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMKeyboardView.h"
#import "OPMKeyboard.h"
#import "OPMKeyButtonView.h"
#import "OPMKeyButton.h"

@interface OPMKeyboardView (){
    NSMutableDictionary *_keyImageDict;
    OPMKeyboard         *_keyboard;
}

@end

@implementation OPMKeyboardView

- (OPMKeyboardView *)initWithKeyboard:(OPMKeyboard *)keyboard Dictionary:(NSDictionary *)dict
{
    if (self = [super initWithFrame:CGRectMake(-2, 0, 804, 512)]) {
        _keyboard = keyboard;
        _keyImageDict = [[NSMutableDictionary alloc]init];
        NSImageView *background = [[NSImageView alloc]initWithFrame:self.frame];
        [background setImage:[NSImage imageNamed:@"keyboard.png"]];
        [self addSubview:background];
        [[dict objectForKey:@"defaultLayout"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSInteger keyIndex = [key integerValue];
            NSPoint position = NSPointFromString([obj objectForKey:@"viewLocation"]);
            NSSize  keySize = NSSizeFromString([[[dict objectForKey:@"screenSizes"] objectForKey:key] objectForKey:@"screenSize"]);
            OPMKeyButtonView *button = [[OPMKeyButtonView alloc]initWithFrame:CGRectMake(position.x, position.y, keySize.width/2, keySize.height/2)];
            button.tag = keyIndex;
            
            [button setWantsLayer: YES];  // edit: enable the layer for the view.  Thanks omz
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 8.0;
            button.layer.masksToBounds = YES;
            
            [button setEditable:YES];
            [button setImageScaling:NSImageScaleAxesIndependently];
            [button setTarget:self];
            [button setAction:@selector(updateButton:)];
            OPMKeyButton *keyButton = [[[dict objectForKey:@"screenSizes"] objectForKey:key] objectForKey:@"button"];
            button.image = [keyButton currentImage];
            [self addSubview:button];
            [_keyImageDict setObject:keyButton forKey:key];
        }];
    }
    return self;
}

- (void)updateButton:(NSImageView *)sender {
    [_keyboard updateButton:[NSString stringWithFormat:@"%li",(long)sender.tag] withImage:sender.image];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
