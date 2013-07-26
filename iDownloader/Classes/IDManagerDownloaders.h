//
//  IDManagerDownloaders.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloadOperation.h"

@class IDDownloaderBuilder;

/**
 The instance IDManagerDownloaders incaplulate logic of managed IDDownloadOperation operations. IDManagerDownloaders response on all operations events and invoke owner blocks for represent it's events.
 You need invol start method for start queue on invoke.
 */

@interface IDManagerDownloaders : IDDownloadOperation
{
@protected
    NSMutableArray *operations;
    IDDownloaderBuilder *builder;
}

/// ---------------------------------------------------------
/// @name Business Logic Methods
/// ---------------------------------------------------------

/**
 Method add a new context to download queue.
 @param context context to download
 */
- (void)addContextToQueueDownload:(id<IDDownload>)context;

/**
 Method remove context with download queue.
 @param removeContext a context to remove from download queue
 */
- (void)removeContextWithQueueDownload:(id<IDDownload>)removeContext;

/**
 Method canceling operation by given name.
 @param context the operation context
 */
- (void)cancelOperationWithContext:(id<IDDownload>)context;

/**
 Method resume operation by given name.
 @param context the operation context
 */
- (void)resumeOperationWithContext:(id<IDDownload>)context;

/**
 Method pause operation by given name.
 @param context the operation context
 */
- (void)pauseOperationWithContext:(id<IDDownload>)context;

/**
 Method return count operations in queue.
 @return NSUInteger
 */
- (NSUInteger)countOperations;

@end
