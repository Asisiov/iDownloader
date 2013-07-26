//
//  IDViewController.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDViewController.h"
#import "IDDownloadContext.h"

@interface IDViewController ()


@end

@implementation IDViewController

#pragma mark Implementation Initialization Methods

- (void)dealloc
{
    [downloadItems release];
    [super dealloc];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    downloadItems = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Implementation IBActions Methods

- (IBAction)download:(id)sender
{
    IDDownloadContext *context = [[IDDownloadContext alloc] init];
    context.destPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MoviFile.avi"];
    context.name = @"MoviFile.avi";
    context.url = @"http://localhost/OSXDownloaderServes/Novaya.kamasutra.21.veka.Sovremennaya.lyubov.2.2004.DVDRip.R.G.Mega.Best.avi";
    
    if (!downloader.isStarted || !downloader.isExecuting)
    {
        downloader.name = @"downloader.manager";
        [downloader start];
    }
    
    [downloadItems addObject:context];
    [downloader addContextToQueueDownload:context];
    [context release];
    
//    context = [[IDDownloadContext alloc] init];
//    context.destPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MoviFile2.mp4"];
//    context.name = @"MoviFile2.mp4";
//    context.url = @"http://localhost/OSXDownloaderServes/amazing%20starlings%20murmuration%20(full%20HD)%20-www.keepturningleft.co.uk.mp4";
//    
//    [downloadItems addObject:context];
//    [downloader addContextToQueueDownload:context];
//    [context release];
}

- (IBAction)pause:(id)sender
{
    id<IDDownload> pauseItem = [downloadItems lastObject];
    [downloader pauseOperationWithContext:pauseItem];
}

- (IBAction)resume:(id)sender
{
    id<IDDownload> resumeItem = [downloadItems lastObject];
    [downloader resumeOperationWithContext:resumeItem];
}

- (IBAction)cancel:(id)sender
{
    id<IDDownload> cancelItem = [downloadItems lastObject];
    [downloader cancelOperationWithContext:cancelItem];
}

#pragma mark -

@end
