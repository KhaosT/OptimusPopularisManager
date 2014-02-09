//
//  OPMUpdateQueue.h
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPMUpdateQueue : NSOperationQueue

+(OPMUpdateQueue *)sharedQueue;

@end
