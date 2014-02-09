//
//  OPMUpdateQueue.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/5/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMUpdateQueue.h"

@implementation OPMUpdateQueue

+(OPMUpdateQueue *)sharedQueue
{
    static OPMUpdateQueue *updateQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateQueue = [[self alloc]init];
        updateQueue.maxConcurrentOperationCount = 1;
    });
    return updateQueue;
}

@end
