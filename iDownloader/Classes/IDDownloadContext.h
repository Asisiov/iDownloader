//
//  IDDownloadContext.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDDownload.h"

#define MAX_PROCENT 100

/**
 The instance IDDownloadContext class represent loading context (data/file).
 */

@interface IDDownloadContext : NSObject <IDDownload>

/// ------------------------------------------------------------------------
/// @name Property of State
/// ------------------------------------------------------------------------

///** Value the downloadedBytes property show how download bytes. */
@property (nonatomic, assign) long downloadedBytes;

/** Value the downloadedBytes property show how download MB. */
@property (nonatomic, assign) long downloadedMB;

///** Value the sizeInBytes property is the full size of loading file in bytes. */
@property (nonatomic, assign) long sizeInBytes;

/** Value the sizeInMB property is the full size of loading file in MB. */
@property (nonatomic, copy) NSString *fullSizeInMB;

/** Value the sizeInMB property is the size of loadiet data in MB. */
@property (nonatomic, copy) NSString *sizeInMB;

/** Value the stateLoadingInProcent property is downloaded state in procent. Maximum value is 100%. */
@property (nonatomic, assign) long stateLoadingInProcent;

/////** Value the timeInterval property is lately time of loading in seconds. */
//@property (nonatomic, assign) NSTimeInterval timeInterval;

/** Valye the timeLoading property is lately time of loading. */
@property (nonatomic, copy) NSString *timeLoading;

///** Value the fullTimeInSeconds property is full right time to download the entire file/data in seconds. */
//@property (nonatomic, assign) NSTimeInterval fullTimeInSeconds;

/** Value the fullTimeInSeconds property is full right time to download the entire file/data. */
@property (nonatomic, copy) NSString *fullTime;

/** Value the destPath property is full path to local file. */
@property (nonatomic, copy) NSString *destPath;

/** Value the urk property is url to network file. */
@property (nonatomic, copy) NSString *url;

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

@end
