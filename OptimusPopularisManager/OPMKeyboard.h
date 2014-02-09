//
//  OPMKeyboard.h
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPMKeyboardView;
@interface OPMKeyboard : NSObject

+ (BOOL)isAvailable;

- (OPMKeyboard *)initWithType:(NSString *)type;
- (OPMKeyboardView *)keyboardView;
- (void)updateLayoutFile;
- (void)updateButton:(NSString *)index withImage:(NSImage *)image;

@end
