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
@synthesize userData = userData;
@synthesize context = contextObject;

#pragma mark Implementation Initialization Methods

// Method initial and return a new object.
- (id)initWithContext:(id<IDDownload>)contextData
{
    self = [super init];
    
    if (self)
    {
        contextObject = [contextData retain];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@" ----- dealloc %@ -----", name);
    
    self.name = nil;
    self.finishingBlock = nil;
    self.cancelingBlock = nil;
    self.startingBlock = nil;
    self.pausingBlock = nil;
    self.resumingBlock = nil;
    self.failedBlock = nil;
    self.userData = nil;
    
    [contextObject release];
    
    if (_currentQueue)
    {
        dispatch_release(_currentQueue);
        _currentQueue = nil;
    }
    
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method begin operation. You should not be override this method.
- (void)start
{
    if (!isFinished && !isCanceled && !isExecuting && _currentQueue)
    {
        dispatch_async(_currentQueue, ^
        {
            isExecuting = YES;
            isStarted = YES;
            
            NSLog(@"----- %s (%@) (%@) -----", __FUNCTION__, name, contextObject.url);
            
            @autoreleasepool
            {
                if (startingBlock)
                {
                    startingBlock(self);
                }
                
                if (!isPaused)
                {
                    dispatch_async(_currentQueue, ^
                    {
                        @autoreleasepool
                        {
                            [self _main];
                        }
                    });
                }
                
                [self _start];
            }
        });
    }
    else if (!_currentQueue)
    {
        [self startRunLoop];

        if (_currentQueue)
        {
            [self start];
        }
    }
}

// Method finishing operation. You should not be override this method.
- (void)finish
{
    if (!isFinished && _currentQueue)
    {
        dispatch_async(_currentQueue, ^
        {
            @autoreleasepool
            {
                [self _finish];
                
                if (finishingBlock)
                {
                    finishingBlock(self);
                }
            }
            
            isFinished = YES;
            isExecuting = NO;
        });
    }
}

// Method canceling operation. You should not be override this method.
- (void)cancel
{
    if (!isCanceled && _currentQueue)
    {
        dispatch_async(_currentQueue, ^
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
        });
    }
}

// Method pausing operation. You should not be override this method.
- (void)pause
{
    if (!isPaused && isExecuting && _currentQueue)
    {
//        dispatch_suspend(_currentQueue);
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group, _currentQueue, ^
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
        });
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        dispatch_suspend(_currentQueue);
        
        dispatch_release(group);
    }
}

// Method resuming operation. You should not be override this method.
- (void)resume
{
    if (isPaused && _currentQueue)
    {
        @autoreleasepool
        {
            if (resumingBlock)
            {
                resumingBlock(self);
            }
            
            [self _resume];
        }
        
        dispatch_resume(_currentQueue);
        
        isPaused = NO;
    }
}

#pragma mark -

#pragma mark Implemntation Getters / Setters Methods

- (void)setUrl:(NSString *)url_
{
}

- (NSString *)url
{
    return nil;
}

#pragma mark -

#pragma mark Implementation Private Methods

// Method initial NSThread if need
- (void)startRunLoop
{    
    if (!_currentQueue)
    {
        @autoreleasepool
        {
            NSString *queueName = [[NSString stringWithFormat:@"%@.operation.serial.queue", name] uppercaseString];
            _currentQueue = dispatch_queue_create([queueName UTF8String], 0);
        }
    }
    
    if (!_runLoop)
    {
        dispatch_async(_currentQueue, ^
        {
            _runLoop = [NSRunLoop currentRunLoop];
        });
    }
}

#pragma mark -

@end
