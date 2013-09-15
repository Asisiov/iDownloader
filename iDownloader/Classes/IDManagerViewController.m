//
//  IDViewController.m
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDManagerViewController.h"
#import "IDDownloadContext.h"
#import "IDDownloader.h"

@interface IDManagerViewController (Private)

// Method create a new controller
- (IDViewController *)allocViewControllerByName:(NSString *)controllerName;

@end

@implementation IDManagerViewController

#pragma mark Implementation Initialization Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        @autoreleasepool
        {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ViewsList" ofType:@"plist"];
            
            if (plistPath)
            {
                viewsList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    [viewsList release];
    [downloadItems release];
    [super dealloc];
}

#pragma mark -

#pragma mark Blocks 

IDDownloadBlock managerFileBlock = ^(id<IDDownload> downloadOperation)
{
    IDDownloader *downloaderOperation = (IDDownloader *)downloadOperation;
    
    if (downloaderOperation)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:downloaderOperation.localPathToDownloadFile])
        {
            [fileManager removeItemAtPath:downloaderOperation.localPathToDownloadFile error:nil];
        }
        
        [fileManager release];
    }
};

#pragma mark -

#pragma mark LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    downloadItems = [[NSMutableArray alloc] init];
    
    downloader.operationCancelingBlock = managerFileBlock;
    downloader.operationFailedBlock = ^(id<IDDownload> downloadOperation, NSString *error)
    {
        NSLog(@"Error: %@", error);
        managerFileBlock(downloadOperation);
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark Implementation UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [viewsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"CellViewType";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20.f];
    }
    
    cell.textLabel.text = [[viewsList allKeys] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -

#pragma mark Implementation UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *key = [viewsList.allKeys objectAtIndex:indexPath.row];
    
    if (key)
    {
        NSString *controllerName = [viewsList objectForKey:key];
        
        NSLog(@"select: %@", controllerName);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *didSelectCell = [tableView cellForRowAtIndexPath:indexPath];
    didSelectCell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark -

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

#pragma mark Implementation Private Methods

// Method create a new controller
- (IDViewController *)allocViewControllerByName:(NSString *)controllerName
{
    IDViewController *viewController = nil;
    
    @try
    {
        Class viewControllerClass = NSClassFromString(controllerName);
        
        if (viewController)
        {
            viewController = [[viewControllerClass alloc] initWithNibName:controllerName bundle:nil];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s \nException: %@", __FUNCTION__, [exception description]);
    }
    @finally {
        return viewController;
    }
    
    return viewController;;
}

#pragma mark -

@end
