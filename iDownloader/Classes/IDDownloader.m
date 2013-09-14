//
//  IDDownloader.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloader.h"
#import "IDDownloadOperation+IDDownloadOperation_Protected.h"

static const NSUInteger byteRangeSuccessCode = 206;

static NSString *const kRange = @"Range";

@implementation IDDownloader

@synthesize localPathToDownloadFile;
@synthesize didReceiveData;
@synthesize didReceiveResponse;
@synthesize serverSupportPartialContent = serverSupportPartialContent;

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
    if (response.expectedContentLength > 0)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        serverSupportPartialContent = ([httpResponse statusCode] == byteRangeSuccessCode);
        
        if (_currentQueue)
        {
            if (!localPathToDownloadFile)
            {
                IDDownloadContext *downloadContext = contextObject;
                self.localPathToDownloadFile = downloadContext.destPath;
            }
            
            NSLog(@"create file");
            
            if (!file)
            {
                file = [[IDFile alloc] initWithFullPath:localPathToDownloadFile];
                [file open];
            }
            
            dispatch_async(_currentQueue, ^
            {
#warning if change 'kExcpectedLength' property after paused the should be change a logic 'procent calculating'. That should be change after add a logic 'check resource' if need to.
                if (![userData objectForKey:kExcpectedLength])
                {
                    [userData setObject:[NSNumber numberWithLongLong:response.expectedContentLength] forKey:kExcpectedLength];
                }
                
                if (didReceiveResponse)
                {
                    didReceiveResponse(self);
                }
            });
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_currentQueue)
    {
        if (!self.isPaused)
        {
            [file writeData:data];
            
            IDDownloadContext *downloadContext = contextObject;
            downloadContext.downloadedBytes = [file size];
        }
        
        if (!self.isPaused)
        {
            dispatch_async(_currentQueue, ^
            {
                [userData setObject:[NSNumber numberWithUnsignedInteger:[data length]] forKey:kLastDownloadedBytesLength];
                
                if (didReceiveData)
                {
                    didReceiveData(self);
                }
            });
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_currentQueue)
    {
        if (!self.isPaused)
        {
            #warning That should be change after add logic 'check resource'. If file close and the open after pause then file get wrong file size.

            [file close];
        }
        
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
        [file close];
        
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
    NSLog(@"downloaded bytes: %li", downloadContext.downloadedBytes);
    
    NSLog(@"%@", [userData description]);
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
    [_connection cancel];
    
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isPaused"];
    
    if (serverSupportPartialContent)
    {
        const unsigned long long fileSize = [file size];
        [userData setObject:[NSString stringWithFormat:@"bytes=%lli-", fileSize] forKey:@"Range"];
    }
}

//// Method resuming operation. You should be override this method.
- (void)_resume
{
    IDDownloadContext *downloadContext = contextObject;
    [downloadContext setValue:[NSNumber numberWithBool:YES] forKey:@"isStarted"];
    
    // start download
    [self _main];
}

// Method main operation. You should be override this method.
- (void)_main
{
    if (contextObject.url)
    {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        NSURL *reqURL = [NSURL URLWithString:contextObject.url];
        __block NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:reqURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        
        NSString *rangeHeader = [userData objectForKey:kRange];
        
        if (!rangeHeader)
        {
            // default value
            rangeHeader = @"bytes=0-";
        }
        
        [request setValue:rangeHeader forHTTPHeaderField:kRange];

        dispatch_async(globalQueue, ^
        {
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            [request release];
            
            [[NSRunLoop currentRunLoop] run];
            [_connection start];
        });
    }
}

#pragma mark -

@end
