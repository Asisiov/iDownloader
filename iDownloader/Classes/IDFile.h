//
//  IDFile.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IDFile is wraper for NSFileHandle. The instance of IDFile incapsulate logic with write to file.
 */

@interface IDFile : NSObject
{
    NSFileHandle *file;
}

/// ------------------------------------------------------------------------------------------
/// @name Initialization Methods
/// ------------------------------------------------------------------------------------------

/**
 Method initialized and return a new file. The parameter 'fullPath' will be copied.
 @param fullPath path to path in which need make or to write data.
 @return id
 */
- (id)initWithFullPath:(NSString *)fullPath;

/// ------------------------------------------------------------------------------------------
/// @name Geters
/// ------------------------------------------------------------------------------------------

/** Return path to file. */
@property (nonatomic, readonly) NSString *path;

/// ------------------------------------------------------------------------------------------
/// @name Business Logic Methods
/// ------------------------------------------------------------------------------------------

/** Method open file for write if file not exist - file will created. */
- (void)open;

/** Method close file. */
- (void)close;

/** 
 Method write given data to end file. Method immediately saves data to disk - not storage in RAM.
 @param data The data to be written..
 */
- (void)writeData:(NSData *)data;

/**
 Method get current file size.
 @retutn unsigned long long.
 */
- (unsigned long long)size;

@end
