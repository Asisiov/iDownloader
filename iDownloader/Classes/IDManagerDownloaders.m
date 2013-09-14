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

//@interface IDDownloadContext (Helpers_C_Functions)
//
//// Method get time as string with dictionary. String returning in autoreleasepool.
//NSString *timeStringWithDictionary(NSDictionary *timeDictionary);
//
//@end

@interface IDManagerDownloaders (Private)

// Methods calculate procent state and time proccessing for given operation
- (void)didReceiveDataWithOperation:(IDDownloadOperation *)anOperation;

// Method return operation with queue by context
- (IDDownloadOperation *)getOperationByConext:(id<IDDownload>)context;

@end

#define CONVERT_BYTES_COEFICIENT 1000000

static NSString *const kManager = @"Manager";

static NSString *const kHours   = @"kHours";
static NSString *const kMinutes = @"kMinutes";
static NSString *const kSeconds = @"kSeconds";

@implementation IDManagerDownloaders

@synthesize operationFinishingBlock;
@synthesize operationCancelingBlock;
@synthesize operationStartingBlock;
@synthesize operationPausingBlock;
@synthesize operationResumingBlock;
@synthesize operationFailedBlock;

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
    self.operationFinishingBlock = nil;
    self.operationCancelingBlock = nil;
    self.operationStartingBlock = nil;
    self.operationPausingBlock = nil;
    self.operationResumingBlock = nil;
    self.operationFailedBlock = nil;
    
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
            
            if(manager.operationStartingBlock)
            {
                manager.operationStartingBlock(downloader);
            }
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
            
            if(manager.operationCancelingBlock)
            {
                manager.operationCancelingBlock(downloader);
            }
            
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
            
            if(manager.operationPausingBlock)
            {
                manager.operationPausingBlock(downloader);
            }
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
            
            if(manager.operationResumingBlock)
            {
                manager.operationResumingBlock(downloader);
            }
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
            if(manager.operationFinishingBlock)
            {
                manager.operationFinishingBlock(downloader);
            }
                
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
            const CGFloat downloaded_mb = (CGFloat)(downloadContext.downloadedBytes / CONVERT_BYTES_COEFICIENT);
            const CGFloat full_size_mb = (CGFloat)(downloadContext.sizeInBytes / CONVERT_BYTES_COEFICIENT);
            
            downloadContext.sizeInMB = [NSString stringWithFormat:@"%f MB", downloaded_mb];
            
            // calculate process complete in procents
            downloadContext.stateLoadingInProcent = (long)floor((double)(downloaded_mb * MAX_PROCENT / full_size_mb));//downloaded_mb * MAX_PROCENT / full_size_mb;

//            NSLog(@"full size: %@", downloadContext.fullSizeInMB);
            NSLog(@"procent: %li", downloadContext.stateLoadingInProcent);
            
            //calculate full time
#warning wrong - don't work
//            if (downloadContext.stateLoadingInProcent > 0)
//            {
//                const float otherMB = full_size_mb - downloaded_mb;
//                
//                NSDate *startDate = [downloader.userData objectForKey:kStartDate];
//                NSDate *currentDate = [NSDate date];
//                
//                const NSTimeInterval diffTimeInterval = [currentDate timeIntervalSinceDate:startDate];
//                const NSTimeInterval resultTime = diffTimeInterval * otherMB;
//                
//                static NSInteger const secInMinute = 60;
//                static NSInteger const minInHour = 60;
//                static NSInteger const secInHour = 3600;
//                
//                NSInteger ti = (NSInteger)resultTime;
//                NSInteger seconds = ti % secInMinute;
//                NSInteger minutes = (ti / secInMinute) % minInHour;
//                NSInteger hours = (ti / secInHour);
//                
//                NSDictionary *timeDictionary = @{kHours:@(hours), kMinutes:@(minutes), kSeconds:@(seconds)};
//                downloadContext.fullTime = timeStringWithDictionary(timeDictionary);
//                NSLog(@"time: %@", downloadContext.fullTime);
//            }
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
            downloadContext.fullSizeInMB = [NSString stringWithFormat:@"%f.3 MB", (CGFloat)(fullSize / CONVERT_BYTES_COEFICIENT)];
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

            if(manager.operationFailedBlock)
            {
                manager.operationFailedBlock(downloader, error);
            }
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

//@implementation IDDownloadContext (Helpers_C_Functions)
//
//// Method get time as string with dictionary. String returning in autoreleasepool.
//NSString *timeStringWithDictionary(NSDictionary *timeDictionary)
//{
//    NSString *timeString = @"";
//    
//    if ([timeDictionary count])
//    {
//        const NSUInteger hours = [[timeDictionary objectForKey:kHours] unsignedIntegerValue];
//        const NSUInteger minutes = [[timeDictionary objectForKey:kMinutes] unsignedIntegerValue];
//        const NSUInteger seconds = [[timeDictionary objectForKey:kSeconds] unsignedIntegerValue];
//        
//        if (hours)
//        {
//            timeString = [NSString stringWithFormat:@"%i:%i:%i", hours, minutes, seconds];
//        }
//        else
//        {
//            timeString = [NSString stringWithFormat:@"%i:%i", minutes, seconds];
//        }
//    }
//    
//    return timeString;
//}
//
//@end
