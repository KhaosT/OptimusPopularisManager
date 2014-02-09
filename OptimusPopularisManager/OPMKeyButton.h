//
//  OPMKeyButton.h
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPMPlugin.h"

@interface OPMKeyButton : NSObject

@property (readonly,nonatomic) NSInteger index;

-(OPMKeyButton *)initWithButtonIndex:(NSInteger)index size:(NSSize)size dataSize:(NSInteger)dataSize;
-(void)setDisplayPlugin:(OPMPlugin *)plugin;
-(NSImage *)currentImage;
-(void)setText:(NSString *)text;
-(void)setImage:(NSImage *)newImage;

@end
