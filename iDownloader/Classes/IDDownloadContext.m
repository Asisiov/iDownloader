//
//  IDDownloadContext.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloadContext.h"

@implementation IDDownloadContext

@synthesize downloadedBytes;
@synthesize downloadedMB;
@synthesize fullSizeInMB;
@synthesize sizeInMB;
@synthesize stateLoadingInProcent;
@synthesize timeLoading;
@synthesize fullTime;
@synthesize destPath;
@synthesize url;
@synthesize name;
@synthesize isFinished;
@synthesize isCanceled;
@synthesize isStarted;
@synthesize isPaused;

#pragma mark Implementation Initialization Methods

- (void)dealloc
{
    self.name = nil;
    self.fullSizeInMB = nil;
    self.sizeInMB = nil;
    self.timeLoading = nil;
    self.fullTime = nil;
    self.destPath = nil;
    self.url = nil;
    [super dealloc];
}

#pragma mark -

#pragma mark Impelementation Setters Methods

- (void)setStateLoadingInProcent:(long)stateLoadingInProcent_
{
    if (stateLoadingInProcent_ > MAX_PROCENT)
    {
        stateLoadingInProcent_ = MAX_PROCENT;
    }
    
    stateLoadingInProcent = stateLoadingInProcent_;
}

#pragma mark -

@end
