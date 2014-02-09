//
//  OPMKeyboardView.h
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OPMKeyboard;
@interface OPMKeyboardView : NSView

- (OPMKeyboardView *)initWithKeyboard:(OPMKeyboard *)keyboard Dictionary:(NSDictionary *)dict;

@end
