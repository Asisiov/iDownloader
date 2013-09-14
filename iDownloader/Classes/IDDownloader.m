//
//  IDDownloader.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloader.h"
#import "IDDownloadOperation+IDDownloadOperation_Protected.h"

@implementation IDDownloader

@synthesize localPathToDownloadFile;
@synthesize didReceiveData;
@synthesize didReceiveResponse;

#pragma mark Implementation Initialization Methods

// Method initial and return a new object.
- (id)initWithContext:(id<IDDownload>)contextData
{
    self = [super initWithContext:contextData];
    
    if (self)
    {
        file = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [file release];
    
    self.localPathToDownloadFile = nil;
    self.didReceiveData = nil;
    self.didReceiveResponse = nil;
    
    contextObject = nil;
    
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Getters Methods

- (NSString *)url
{
    return contextObject.url;
}

#pragma mark -

#pragma mark Implementation NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __FUNCTION__);
    
    if (response.expectedContentLength > 0)
    {
        if (_currentQueue)
        {
            dispatch_async(_currentQueue, ^
            {
                if (!localPathToDownloadFile)
                {
                    IDDownloadContext *downloadContext = contextObject;
                    self.localPathToDownloadFile = downloadContext.destPath;
                }
                
                [userData setObject:[NSNumber numberWithLongLong:response.expectedContentLength] forKey:kExcpectedLength];
                
                if (didReceiveResponse)
                {
                    didReceiveResponse(self);
                }
                
                NSLog(@"create file");
                file = [[IDFile alloc] initWithFullPath:localPathToDownloadFile];
                [file open];
            });
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_currentQueue)
    {
        dispatch_group_t group = dispatch_group_create();
        
        if (group)
        {
            dispatch_group_async(group, dispatch_get_current_queue(), ^
            {
//                [file writeData:data];
            });

            dispatch_group_async(group, _currentQueue, ^
            {
                [file writeData:data];
                
                IDDownloadContext *downloadContext = contextObject;
                downloadContext.downloadedBytes = [file size];
                
                [userData setObject:[NSNumber numberWithUnsignedInteger:[data length]] forKey:kLastDownloadedBytesLength];
                
                didReceiveData(self);
            });
            
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_release(group);
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_currentQueue)
    {
        [file close];
        
        if (!contextObject.isCanceled)
        {
            [self finish];
        }
    }
}

#pragma mark -

#pragma mark Implementation NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_currentQueue)
    {
        dispatch_async(_currentQueue, ^
        {
            if (self.failedBlock)
            {
                NSString *errorString = [[NSString alloc] initWithFormat:@"Failed download %@ file. \n%@", contextObject.name, [error description]];
                self.failedBlock(self, errorString);
                [errorString release];
            }
            
            [self finish];
        });
    }
}

#pragma mark -

#pragma mark Implementation Protected Methods

// Method begin operation. You should be override this method.
- (void)_start
{
    NSLog(@"----- %s (%@) (%@) -----", __FUNCTION__, self.name, contextObject.url);
    
    if (!userData)
    {
        userData = [[NSMutableDictionary alloc] init];
    }
    
    NSDate *currentDate = [NSDate date];

    [userData setObject:currentDate forKey:kStartDate];
    [userData setObject:currentDate forKey:kDate];
    
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isStarted"];
}

// Method finishing operation. You should be override this method.
- (void)_finish
{
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isFinished"];    
}

// Method canceling operation. You should be override this method.
- (void)_cancel
{
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isCanceled"];
    [_connection cancel];
}

// Method pausing operation. You should be override this method.
- (void)_pause
{
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isPaused"];
}

//// Method resuming operation. You should be override this method.
- (void)_resume
{
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isStarted"];
}

// Method main operation. You should be override this method.
- (void)_main
{
    if (contextObject.url)
    {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(globalQueue, ^
        {
            NSURL *reqURL = [NSURL URLWithString:contextObject.url];
            NSURLRequest *reques = [NSURLRequest requestWithURL:reqURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            _connection = [[NSURLConnection alloc] initWithRequest:reques delegate:self];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

#pragma mark -

@end
