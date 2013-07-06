//
//  IDDownloadOperation.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloadOperation.h"
#import "IDDownloadOperation+IDDownloadOperation_Protected.h"

@interface IDDownloadOperation (Privete)

// Method initial NSThread if need
- (void)startRunLoop;

// Loop method
- (void)loop;

// Method start current thread and set given selector set to invoke in this thread.
// If method return YES then he detach selector to new thread
- (BOOL)startInNewThreadWithSelector:(SEL)selector;

// Methods cancel all operation on _thread
- (void)cancelThread;

@end

@implementation IDDownloadOperation

@synthesize name;
@synthesize isFinished;
@synthesize isPaused;
@synthesize isStarted;
@synthesize isCanceled;
@synthesize isExecuting;
@synthesize finishingBlock;
@synthesize cancelingBlock;
@synthesize startingBlock;
@synthesize pausingBlock;
@synthesize resumingBlock;
@synthesize failedBlock;

#pragma mark Implementation Initialization Methods

- (void)dealloc
{
    self.name = nil;
    self.finishingBlock = nil;
    self.cancelingBlock = nil;
    self.startingBlock = nil;
    self.pausingBlock = nil;
    self.resumingBlock = nil;
    self.failedBlock = nil;
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method begin operation. You should not be override this method.
- (void)start
{
    if (!isFinished && !isCanceled && !isExecuting)
    {
        if (![self startInNewThreadWithSelector:@selector(start)])
        {
            isExecuting = YES;
            isStarted = YES;
            
            NSLog(@"----- %s (%@) -----", __FUNCTION__, name);
            
            @autoreleasepool
            {
                if (startingBlock)
                {
                    startingBlock(self);
                }
                
                if (!isPaused)
                {
                    [self performSelector:@selector(_main) onThread:_thread withObject:nil waitUntilDone:NO];
                }
                
                [self _start];
            }   
        }
    }
}

// Method finishing operation. You should not be override this method.
- (void)finish
{
    if (![self startInNewThreadWithSelector:@selector(finish)])
    {   
        @autoreleasepool
        {
            if (finishingBlock)
            {
                finishingBlock(self);
            }
            
            [self _finish];
        }
        
        isFinished = YES;
        isExecuting = NO;
        
        [self cancelThread];
    }
}

// Method canceling operation. You should not be override this method.
- (void)cancel
{
    if (![self startInNewThreadWithSelector:@selector(cancel)])
    {
        @autoreleasepool
        {
            if (cancelingBlock)
            {
                cancelingBlock(self);
            }
            
            [self _cancel];
        }
        
        isExecuting = NO;
        isCanceled = YES;
        
        [self cancelThread];
    }
}

// Method pausing operation. You should not be override this method.
- (void)pause
{
    if (![self startInNewThreadWithSelector:@selector(pause)])
    {
        @autoreleasepool
        {
            if (pausingBlock)
            {
                pausingBlock(self);
            }
            
            [self _pause];
        }
        
        isPaused = YES;
    }
}

// Method resuming operation. You should not be override this method.
- (void)resume
{
    if (![self startInNewThreadWithSelector:@selector(resume)])
    {
        @autoreleasepool
        {
            if (resumingBlock)
            {
                resumingBlock(self);
            }
            
            [self _resume];
        }
        
        isPaused = NO;
    }
}

#pragma mark -

#pragma mark Implementation Private Methods

// Method initial NSThread if need
- (void)startRunLoop
{
    if (_thread == nil)
    {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(load) object:nil];
        [_thread start];
    }
}

// Loop method
- (void)loop
{
    while (!isCanceled && !isFinished)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

// Method start current thread and set given selector set to invoke in this thread
- (BOOL)startInNewThreadWithSelector:(SEL)selector
{
    BOOL flag = NO;
    
    if (selector != nil)
    {
        if (!_thread)
        {
            flag = YES;
            [self startRunLoop];
            [self performSelector:selector onThread:_thread withObject:nil waitUntilDone:NO];
        }
        else if (![[NSThread currentThread] isEqual:_thread])
        {
            flag = YES;
            [self performSelector:selector onThread:_thread withObject:nil waitUntilDone:NO];
        }
    }
    
    return flag;
}

// Methods cancel all operation on _thread
- (void)cancelThread
{
    if (_thread)
    {
        [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
        [NSThread cancelPreviousPerformRequestsWithTarget:self];
        [_thread cancel];
    }
}

#pragma mark -

@end
