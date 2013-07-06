//
//  IDDowload.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IDDownload is abstract class. IDDOwnload contain common property.
 */
@protocol IDDowload <NSObject>

/// ------------------------------------------------------------
/// @name Property of State
/// ------------------------------------------------------------

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
