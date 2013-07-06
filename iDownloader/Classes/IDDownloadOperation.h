//
//  IDDownloadOperation.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDDowload.h"

/// The type of separate blocks for download events
typedef void (^IDDownloadBlock)(id<IDDowload>);

/// The type of separate blocks for error download event
typedef void (^IDDownloadFailedBlock)(id<IDDowload>, NSString *);

/**
 The class IDDownloadOperation is root class for all operation. The class IDDownloadOperation incapsulate all work with threads and manipulate operation.
 */

@interface IDDownloadOperation : NSObject <IDDowload>
{
@private
    NSThread *_thread;  // private thread current instance of operation
    dispatch_queue_t _currentQueue;
}

/// -------------------------------------------------------------------------------------------------------------------------------------------------------
/// @name Property of State
/// -------------------------------------------------------------------------------------------------------------------------------------------------------

/** Name */
@property (nonatomic, copy) NSString *name;

/** Flag indicate the state of object if he is equal 'YES' then object already fineshed loading. */
@property (nonatomic, readonly) BOOL isFinished;

/** Flag indicate the state of object if he is equal 'YES' then object load was canceled. */
@property (nonatomic, readonly) BOOL isCanceled;

/** Flag indicate the state of object if he is equal 'YES' then object loading. */
@property (nonatomic, readonly) BOOL isStarted;

/** Flag indicate the state of object if he is equal 'YES' then object is paused. */
@property (nonatomic, readonly) BOOL isPaused;

/** Flag indicate the state of object if he is equal 'YES' then object now is loading. */
@property (nonatomic, readonly) BOOL isExecuting;

/// -------------------------------------------------------------------------------------------------------------------------------------------------------
/// @name Download blocks for events
/// -------------------------------------------------------------------------------------------------------------------------------------------------------

/** The canceledBlock invoke when operation finish download. */
@property (nonatomic, copy) IDDownloadBlock finishingBlock;

/** The cancelingBlock invoke when operation cancling download. */
@property (nonatomic, copy) IDDownloadBlock cancelingBlock;

/** The startingBlock invoke when operation starting download. */
@property (nonatomic, copy) IDDownloadBlock startingBlock;

/** The pausingBlock invoke when operation pausing download. */
@property (nonatomic, copy) IDDownloadBlock pausingBlock;

/** The resumingBlock invoke when operation resuming download. */
@property (nonatomic, copy) IDDownloadBlock resumingBlock;

/** The resumingBlock invoke when there is an error loading. */
@property (nonatomic, copy) IDDownloadFailedBlock failedBlock;

/// -------------------------------------------------------------------------------------------------------------------------------------------------------
/// @name Business Logic Methods
/// -------------------------------------------------------------------------------------------------------------------------------------------------------

/**  Method begin operation. You should not be override this method. */
- (void)start;

/**  Method finishing operation. You should not be override this method. */
- (void)finish;

/**  Method canceling operation. You should not be override this method. */
- (void)cancel;

/**  Method pausing operation. You should not be override this method. */
- (void)pause;

/**  Method resuming operation. You should not be override this method. */
- (void)resume;

@end
