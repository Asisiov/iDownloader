//
//  IDOperationBuilder.h
//  iDownloader
//
//  Created by iMac Asisiov on 07.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDDownload.h"
#import "IDDownloadOperation.h"

@class IDDownloader;

/**
 The instance IDOperationBuilder is builder he incapsulate logic as create downloader.
 */

@interface IDDownloaderBuilder : NSObject
{
    IDDownloader *downloader;
}

/// ----------------------------------------------------------------------------------
/// @name Business Logic Methods
/// ----------------------------------------------------------------------------------

/**
 Method create a new download operation for given context
 @param context context info
 */
- (void)createOperationWithContext:(id<IDDownload>)context;

/**
 Method add to new operation block.
 @param startingBlock block invoke when operation set to start state
 */
- (void)addStartingBlock:(IDDownloadBlock)startingBlock;

/**
 Method add to new operation block.
 @param cancelingBlock block invoke when operation set to cancel state
 */
- (void)addCancelingBlock:(IDDownloadBlock)cancelingBlock;

/**
 Method add to new operation block.
 @param finishingBlock block invoke when operation set to finish state
 */
- (void)addFinishingBlock:(IDDownloadBlock)finishingBlock;

/**
 Method add to new operation block.
 @param pausingBlock block invoke when operation set to pause state
 */
- (void)addPausingBlock:(IDDownloadBlock)pausingBlock;

/**
 Method add to new operation block.
 @param resumingBlock block invoke when operation resuming
 */
- (void)addResumingBlock:(IDDownloadBlock)resumingBlock;

/**
 Method add to new operation block.
 @param failedBlock block invoke when operation failed
 */
- (void)addFailedBlock:(IDDownloadFailedBlock)failedBlock;

/**
 Method add to new operation block.
 @param didReceiveDataBlock block invoke when operation receive message didReceiveData
 */
- (void)addDidReceiveDataBlock:(IDDownloadBlock)didReceiveDataBlock;

/**
 Method add to new operation block.
 @param didReceiveResponseBlock block invoke when operation receive message didReceiveResponse
 */
- (void)addDidReceiveResponseBlock:(IDDownloadBlock)didReceiveResponseBlock;

/**
 Methods add additional data to operation.
 @param userData additional data
 */
- (void)addUserData:(NSMutableDictionary *)userData;

/**
 Method return a new operation in autorelease.
 @return id<IDDownload>
 */
- (id<IDDownload>)operation;

@end
