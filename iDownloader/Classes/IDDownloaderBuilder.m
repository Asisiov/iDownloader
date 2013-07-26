//
//  IDOperationBuilder.m
//  iDownloader
//
//  Created by iMac Asisiov on 07.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloaderBuilder.h"
#import "IDDownloader.h"

@implementation IDDownloaderBuilder

#pragma mark Business Logic Methods

// Method create a new download operation for given context
- (void)createOperationWithContext:(id<IDDownload>)context
{
    if (context)
    {
        downloader = [[IDDownloader alloc] initWithContext:context];
        downloader.name = context.name;
    }
}

// Method add to new operation block.
- (void)addStartingBlock:(IDDownloadBlock)startingBlock
{
    downloader.startingBlock = startingBlock;
}

// Method add to new operation block.
- (void)addCancelingBlock:(IDDownloadBlock)cancelingBlock
{
    downloader.cancelingBlock = cancelingBlock;
}

// Method add to new operation block.
- (void)addFinishingBlock:(IDDownloadBlock)finishingBlock
{
    downloader.finishingBlock = finishingBlock;
}

// Method add to new operation block.
- (void)addPausingBlock:(IDDownloadBlock)pausingBlock
{
    downloader.pausingBlock = pausingBlock;
}

// Method add to new operation block.
- (void)addResumingBlock:(IDDownloadBlock)resumingBlock
{
    downloader.resumingBlock = resumingBlock;
}

// Method add to new operation block.
- (void)addFailedBlock:(IDDownloadFailedBlock)failedBlock
{
    downloader.failedBlock = failedBlock;
}

// Method add to new operation block.
- (void)addDidReceiveDataBlock:(IDDownloadBlock)didReceiveDataBlock
{
    downloader.didReceiveData = didReceiveDataBlock;
}

// Method add to new operation block.
- (void)addDidReceiveResponseBlock:(IDDownloadBlock)didReceiveResponseBlock
{
    downloader.didReceiveResponse = didReceiveResponseBlock;
}

// Methods add additional data to operation.
- (void)addUserData:(NSMutableDictionary *)userData
{
    downloader.userData = userData;
}

// Method return a new operation.
- (id<IDDownload>)operation
{
    return [downloader autorelease];
}

#pragma mark -

@end
