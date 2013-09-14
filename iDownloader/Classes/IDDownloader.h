//
//  IDDownloader.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloadOperation.h"
#import "IDDownloadContext.h"
#import "IDFile.h"

static NSString *const kExcpectedLength             =   @"kExcpectedLength";
static NSString *const kDate                        =   @"kDate";
static NSString *const kStartDate                   =   @"kStartDate";
static NSString *const kLastDownloadedBytesLength   =   @"kLastDownloadedBytesLength";

/**
 The IDDownloader is concrete operation. The instance of IDDownloader class incapsulate network loading. For initialization this object you will  be need use initial method with parameter: initWithContext:.
 */

@interface IDDownloader : IDDownloadOperation <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
@protected
    IDFile *file;
    
#warning Initialization of this flag need make out this class. That sould change after add\
'check internet resource' logic.
    BOOL serverSupportPartialContent;
    
@protected
    NSURLConnection *_connection;
}

/// ---------------------------------------------------------------------------------------------------
/// @name Settings / Getters
/// ---------------------------------------------------------------------------------------------------

/** Return 'YES' if server support partritial content. */
@property (nonatomic, assign) BOOL serverSupportPartialContent;

/** File path when download file. */
@property (nonatomic, copy) NSString *localPathToDownloadFile;

/// ---------------------------------------------------------------------------------------------------
/// @name Block for response on NSURLConnection events
/// ---------------------------------------------------------------------------------------------------

/** The didReceiveData invoke after downloader receive message about receive data. Given object to bloack is current operation. */
@property (nonatomic, copy) IDDownloadBlock didReceiveData;

/** The didReceiveData invoke after downloader receive message about receive response. Given object to bloack is current operation. */
@property (nonatomic, copy) IDDownloadBlock didReceiveResponse;

@end
