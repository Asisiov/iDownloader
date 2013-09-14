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
//    context.destPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"163d3dac41.mp4"];
//    context.name = @"163d3dac41.mp4";
//    context.url = @"http://localhost:8888/DownloaderService/163d3dac41.360.mp4";
    
//    Learn English ESL Irregular Verbs Grammar Rap Song! StickStuckStuck with Fluency MC!.mp4
    
//    {
//        context.destPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Learn English ESL Irregular Verbs Grammar Rap Song! StickStuckStuck with Fluency MC!.mp4"];
//        context.name = @"Learn English ESL Irregular Verbs Grammar Rap Song! StickStuckStuck with Fluency MC!.mp4";
//        context.url = @"http://localhost:8888/DownloaderService/Learn%20English%20ESL%20Irregular%20Verbs%20Grammar%20Rap%20Song!%20StickStuckStuck%20with%20Fluency%20MC!.mp4";
//    }
    
//    С ЭТИМ НАДО КОНЧАТЬ - Жак Фреско - Проект Венера.mp4
    
    {
        context.destPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"С ЭТИМ НАДО КОНЧАТЬ - Жак Фреско - Проект Венера.mp4"];
        context.name = @"С ЭТИМ НАДО КОНЧАТЬ - Жак Фреско - Проект Венера.mp4";
        context.url = @"http://localhost:8888/DownloaderService/%D0%A1%20%D0%AD%D0%A2%D0%98%D0%9C%20%D0%9D%D0%90%D0%94%D0%9E%20%D0%9A%D0%9E%D0%9D%D0%A7%D0%90%D0%A2%D0%AC%20-%20%D0%96%D0%B0%D0%BA%20%D0%A4%D1%80%D0%B5%D1%81%D0%BA%D0%BE%20-%20%D0%9F%D1%80%D0%BE%D0%B5%D0%BA%D1%82%20%D0%92%D0%B5%D0%BD%D0%B5%D1%80%D0%B0.mp4";
    }
    
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
