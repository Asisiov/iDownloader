//
//  IDManagerDownloaders.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDManagerDownloaders.h"
#import "IDDownloader.h"
#import "IDDownloadOperation+IDDownloadOperation_Protected.h"
#import "IDDownloaderBuilder.h"

@interface IDDownloadContext (Helpers_C_Functions)

// Method get date dictionary with NSDate object
 NSDictionary *timeWithDate(NSDate *date);

@end

@interface IDManagerDownloaders (Private)

// Methods calculate procent state and time proccessing for given operation
- (void)didReceiveDataWithOperation:(IDDownloadOperation *)anOperation;

// Method return operation with queue by context
- (IDDownloadOperation *)getOperationByConext:(id<IDDownload>)context;

@end

@implementation IDManagerDownloaders

#define CONVERT_BYTES_COEFICIENT 1000000

static NSString *const kManager = @"Manager";

static NSString *const kHours   = @"kHours";
static NSString *const kMinutes = @"kMinutes";
static NSString *const kSeconds = @"kSeconds";

#pragma mark Implementation Initialization Methods

- (id)init
{
    self = [super init];
    
    if (self)
    {
        builder = [[IDDownloaderBuilder alloc] init];
    }
    
    return self;
}

- (id)initWithContext:(id<IDDownload>)contextData
{
    self = [self init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    [builder release];
    [operations release];
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Private Bloacks

void (^removeOperationWithQueueBlock)(IDDownloadOperation *) = ^(IDDownloadOperation * operationForRemove)
{
    if (operationForRemove)
    {
        IDManagerDownloaders *manager = [operationForRemove.userData objectForKey:kManager];
        
        if (manager)
        {
            [manager removeContextWithQueueDownload:operationForRemove.context];
        }
    }
};

#pragma mark -

#pragma mark Implementation Blocks Coding for download events

void (^downloadStart)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            NSLog(@"start %@ oparation", downloader.name);
        }
    }
};

void (^downloadCancel)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            NSLog(@"cancel %@ oparation", downloader.name);
            removeOperationWithQueueBlock(downloader);
        }
    }
};

void (^downloadPause)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            NSLog(@"pause %@ oparation", downloader.name);
        }
    }
};

void (^downloadResume)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            NSLog(@"resume %@ oparation", downloader.name);
        }
    }
};

void (^downloadFinish)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            removeOperationWithQueueBlock(downloader);
        }
    }
};

void (^downloadReceiveData)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDDownloadContext *downloadContext = downloader.context;
        
        if (downloadContext.sizeInBytes != NSURLResponseUnknownLength)
        {
            // calculate downloaded data in MB
            downloadContext.sizeInMB = [NSString stringWithFormat:@"%f MB", (float)(downloadContext.downloadedBytes / CONVERT_BYTES_COEFICIENT)];
            
            const float downloaded_mb = (float)(downloadContext.downloadedBytes / CONVERT_BYTES_COEFICIENT);
            const float full_size_mb = (float)(downloadContext.sizeInBytes / CONVERT_BYTES_COEFICIENT);
            
            // calculate process complete in procents
            downloadContext.stateLoadingInProcent = downloaded_mb * MAX_PROCENT / full_size_mb;
            
            //calculate full time
            if (downloadContext.stateLoadingInProcent > 0)
            {
                const float otherMB = full_size_mb - downloaded_mb;
                
                NSDate *startDate = [downloader.userData objectForKey:kStartDate];
                NSDate *currentDate = [NSDate date];
                
                const NSTimeInterval diffTimeInterval = [currentDate timeIntervalSinceDate:startDate];
                
                const NSTimeInterval resultTime = diffTimeInterval * otherMB;
                
                NSDate *futureDate = [currentDate dateByAddingTimeInterval:resultTime];
                NSLog(@"future date: %@", [futureDate descriptionWithLocale:[NSLocale systemLocale]]);
                
                NSDictionary *futureDateDictionary = timeWithDate(futureDate);
                
                const NSInteger hours = [[futureDateDictionary objectForKey:kHours] integerValue];
                const NSInteger minutes = [[futureDateDictionary objectForKey:kMinutes] integerValue];
                const NSInteger seconds = [[futureDateDictionary objectForKey:kSeconds] integerValue];
                
                downloadContext.fullTime = [NSString stringWithFormat:@"%i:%i:%i", hours, minutes, seconds];
                NSLog(@"time: %@", downloadContext.fullTime);
            }
        }
    }
};

void (^downloadReceiveResponse)(id<IDDownload>) = ^(id<IDDownload> downloadOperation)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloadOperation *downloader = (IDDownloadOperation *)downloadOperation;
        const long long fullSize = [[downloader.userData objectForKey:kExcpectedLength] longLongValue];
        
        if (fullSize != NSURLResponseUnknownLength)
        {
            IDDownloadContext *downloadContext = downloader.context;
            downloadContext.sizeInBytes = fullSize;
            downloadContext.fullSizeInMB = [NSString stringWithFormat:@"%i MB", (int)(fullSize / CONVERT_BYTES_COEFICIENT)];
        }
    }
};

void (^downloadFailed)(id<IDDownload>, NSString *) = ^(id<IDDownload> downloadOperation, NSString *error)
{
    if ([downloadOperation isKindOfClass:[IDDownloader class]])
    {
        IDDownloader *downloader = (IDDownloader*)downloadOperation;
        IDManagerDownloaders *manager = [downloader.userData objectForKey:kManager];
        
        if (manager)
        {
            NSLog(@"failed %@ oparation with error:\n%@", downloader.name, error);
        }
    }
};

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method add a new context to download queue.
- (void)addContextToQueueDownload:(id<IDDownload>)context
{
    if (context && _currentQueue)
    {
        dispatch_async(_currentQueue, ^
        {
            NSAssert(operations != nil, @"You should first call a 'start' method.");
            
            @autoreleasepool
            {
                NSLog(@"context url: %@", context.url);
                [builder createOperationWithContext:context];
                [builder addStartingBlock:downloadStart];
                [builder addCancelingBlock:downloadCancel];
                [builder addPausingBlock:downloadPause];
                [builder addResumingBlock:downloadResume];
                [builder addFinishingBlock:downloadFinish];
                [builder addFailedBlock:downloadFailed];
                [builder addDidReceiveResponseBlock:downloadReceiveResponse];
                [builder addDidReceiveDataBlock:downloadReceiveData];
                
                NSMutableDictionary *operationUserData = [NSMutableDictionary dictionaryWithObject:self forKey:kManager];
                [builder addUserData:operationUserData];
                
                IDDownloadOperation *operation = [builder operation];
                
                if (operation)
                {
                    NSLog(@"add operation to manager: %@", [self description]);
                    [operations addObject:operation];
                    [operation start];
                }
            }
        });
    }
}

// Method remove context with download queue.
- (void)removeContextWithQueueDownload:(id<IDDownload>)removeContext
{
    NSAssert(operations != nil, @"You should first call a 'start' method.");
    
    NSLog(@"remove operation with manager %@", [self description]);
    
    if (removeContext && _currentQueue)
    {
        __block id<IDDownload> context = removeContext;
        
        dispatch_async(_currentQueue, ^
       {
           @autoreleasepool
           {
               IDDownloadOperation *removeOperation = (IDDownloadOperation *)[self getOperationByConext:context];
               
               if (removeOperation)
               {
                   if (self.finishingBlock)
                   {
                       self.finishingBlock(removeOperation);
                   }
                   
                   [operations removeObject:removeOperation];
               }
           }
       });
    }
}

// Method canceling operation by given name.
- (void)cancelOperationWithContext:(id<IDDownload>)context;
{
    if (context && _currentQueue)
    {
        __block id<IDDownload> contextForCancel = context;
        
        dispatch_async(_currentQueue, ^
        {
            @autoreleasepool
            {
                IDDownloadOperation *operationForCancel = [self getOperationByConext:contextForCancel];
                
                if (operationForCancel)
                {
                    [operationForCancel cancel];
                }
            }
        });
    }
}

// Method resume operation by given name.
- (void)resumeOperationWithContext:(id<IDDownload>)context;
{
    if (context && _currentQueue)
    {
        __block id<IDDownload> contextForCancel = context;
        
        dispatch_async(_currentQueue, ^
       {
           @autoreleasepool
           {
               IDDownloadOperation *operationForResume = [self getOperationByConext:contextForCancel];
               
               if (operationForResume)
               {
                   [operationForResume resume];
               }
           }
       });
    }
}

// Method pause operation by given name.
- (void)pauseOperationWithContext:(id<IDDownload>)context;
{
    if (context && _currentQueue)
    {
        __block id<IDDownload> contextForCancel = context;
        
        dispatch_async(_currentQueue, ^
       {
           @autoreleasepool
           {
               IDDownloadOperation *operationForPause = [self getOperationByConext:contextForCancel];
               
               if (operationForPause)
               {
                   [operationForPause pause];
               }
           }
       });
    }
}

// Method return count operations in queue.
- (NSUInteger)countOperations
{
    return [operations count];
}

#pragma mark -

#pragma mark Implementation Protected Methods

// Method begin operation. You should be override this method.
- (void)_start
{
    if (!operations)
    {
        operations = [[NSMutableArray alloc] init];
    }
    else if ([operations count])
    {
        [operations makeObjectsPerformSelector:@selector(start)];
    }
}

// Method main operation. You should be override this method.
- (void)_main
{
//    operations = [[NSMutableArray alloc] init];
}

// Method canceling operation. You should be override this method.
- (void)_cancel
{
    if (operations)
    {
        [operations makeObjectsPerformSelector:@selector(cancel)];
    }
}

// Method pausing operation. You should be override this method.
- (void)_pause
{
    if ([operations count])
    {
        [operations makeObjectsPerformSelector:@selector(pause)];
    }
}

// Method resuming operation. You should be override this method.
- (void)_resume
{
    if ([operations count])
    {
        [operations makeObjectsPerformSelector:@selector(resume)];
    }
}

#pragma mark -

#pragma mark Implementation Private Methods

// Method return operation with queue by context
- (IDDownloadOperation *)getOperationByConext:(id<IDDownload>)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contextObject.name = %@", context.name];
    return [[operations filteredArrayUsingPredicate:predicate] lastObject];
}

#pragma mark -

@end

@implementation IDDownloadContext (Helpers_C_Functions)

// Method get date dictionary with NSDate object
NSDictionary *timeWithDate(NSDate *date)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    
    const NSInteger hour = [dateComponents hour];
    const NSInteger minute = [dateComponents minute];
    const NSInteger second = [dateComponents second];
    
    [gregorian release];
    
    NSString * text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    NSLog(@"date: %@",text);
    
    return @{kHours:@(hour), kMinutes:@(minute), kSeconds:@(second)};
}

@end
