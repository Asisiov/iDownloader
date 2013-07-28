//
//  IDFile.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDFile.h"

@implementation IDFile

@synthesize path;

#pragma mark Implementation Initialization Methods

// Method initialized and return a new file. The parameter 'fullPath' will be copied.
- (id)initWithFullPath:(NSString *)fullPath
{
    self = [super init];
    
    if (self)
    {
        path = [fullPath copy];
    }
    
    return self;
}

- (void)dealloc
{
    [file release];
    [path release];
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method open file for write if file not exist - file will created.
- (void)open
{
    NSAssert(path, @"You not initial path.");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        BOOL res = [fileManager createFileAtPath:path contents:nil attributes:nil];
        
        if (!res)
        {
#warning NEED FIX
            NSAssert(NO, @"Error: File %@ not create.", path);
        }
    }
    
    file = [[NSFileHandle fileHandleForWritingAtPath:path] retain];
    
    NSLog(@"File was created successfuly - retain count is %i", [file retainCount]);
}

// Method close file.
- (void)close
{
    [file closeFile];
}

// Method write given data to end file. Method immediately saves data to disk - not storage in RAM.
- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        @try
        {
            [file writeData:data];
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s (Exception: %@)", __FUNCTION__, [exception description]);
        }
        @finally
        {
            [file synchronizeFile];
        }
    }
}

// Method get current file size.
- (unsigned long long)size
{
    return [file seekToEndOfFile];
}

#pragma mark -

@end
