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
#import "IDViewController.h"

// Set methods for manage central view controller and allocate view controllers
@interface IDManagerViewController (IDManagerViewController_ManageViewControllers)

// Method create a new controller
- (IDViewController *)allocViewControllerByName:(NSString *)controllerName;

// Method set given controller as main controller
- (void)setCentralViewController:(UIViewController *)centralViewController;

// Method set shadow for given view
- (void)setShadowForView:(UIView *)view;

// Method set position given UIViewController
- (void)setPositionViewControllerView:(UIViewController *)viewConroller;

// Method round original x
CG_INLINE CGFloat roundedOriginXForDrawerConstriants(CGFloat originX);

@end

@interface IDManagerViewController (UIPanGestureRecognizer)

-(void)panGestureCallback:(UIPanGestureRecognizer *)panGesture;

@end

@implementation IDManagerViewController

static const CGFloat shift = 255.f;
static const CGFloat animationDuration = 0.20f;
static const CGFloat velocity = 840.f;

static const CGFloat MMDrawerDefaultShadowRadius = 10.0f;
static const  CGFloat MMDrawerDefaultShadowOpacity = 0.8f;

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
        
        isOpenMainController = YES;
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    downloadItems = [[NSMutableArray alloc] init];
    
    downloader.operationCancelingBlock = managerFileBlock;
    downloader.operationFailedBlock = ^(id<IDDownload> downloadOperation, NSString *error)
    {
        NSLog(@"Error: %@", error);
        managerFileBlock(downloadOperation);
    };
    
    //create UI
    if ([viewsList count])
    {
        IDViewController *centeredController = [self allocViewControllerByName:[viewsList.allValues objectAtIndex:0]];
        
        if (centeredController)
        {
            [self setCentralViewController:centeredController];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [mainViewController beginAppearanceTransition:YES animated:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (path)
    {
        [viewsTable selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionBottom];
        UITableViewCell *cell = [viewsTable cellForRowAtIndexPath:path];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
        
        if (controllerName)
        {
            IDViewController *viewController = [self allocViewControllerByName:controllerName];
            [self setCentralViewController:viewController];
        }
        
//        if (mainViewController.viewControllers.count > 0)
//        {
//            IDViewController *viewController = mainViewController.viewControllers[0];
//            viewController.moveControllerBlock();
//        }
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

@end

@implementation IDManagerViewController (IDManagerViewController_ManageViewControllers)

// Method create a new controller
- (IDViewController *)allocViewControllerByName:(NSString *)controllerName
{
    IDViewController *viewController = nil;
    
    @try
    {
        Class viewControllerClass = NSClassFromString(controllerName);
        
        if (viewControllerClass)
        {
            viewController = [[viewControllerClass alloc] initWithNibName:controllerName bundle:nil];

            [viewController setMoveControllerBlock:^(void)
            {
                if (mainViewController)
                {
                    CGRect newFrame = CGRectZero;
                    CGRect oldFrame = mainViewController.view.frame;
                    
                    if (isOpenMainController)
                    {
                        newFrame = mainViewController.view.frame;
                        newFrame.origin.x -= shift;
                    }
                    else
                    {
                        newFrame = mainViewController.view.frame;
                        newFrame.origin.x += shift;
                    }
                    
                    if (newFrame.origin.x > shift)
                    {
                        newFrame.origin.x = shift;
                    }
                    else if (newFrame.origin.x <= 0.f)
                    {
                        newFrame.origin.x = 0.f;
                    }
                    
                    [mainViewController beginAppearanceTransition:YES animated:YES];
                    
                    const CGFloat distance = ABS(CGRectGetMinX(oldFrame)-newFrame.origin.x);
                    const NSTimeInterval duration = MAX(distance/ABS(velocity),animationDuration);
                    
                    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         mainViewController.view.frame = newFrame;
                     }
                                     completion:^(BOOL finished)
                     {
                         isOpenMainController = !isOpenMainController;
                         [mainViewController endAppearanceTransition];
                     }];
                }
            }];
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

// Method set given controller as main controller
- (void)setCentralViewController:(UIViewController *)centralViewController
{
    if (centralViewController)
    {
        if (mainViewController != nil)
        {
            [mainViewController beginAppearanceTransition:NO animated:NO];
            
            [mainViewController removeFromParentViewController];
            [mainViewController.view removeFromSuperview];
            
            [mainViewController endAppearanceTransition];
            
            [mainViewController release];
            mainViewController = nil;
        }
        
        if (mainViewController == nil)
        {
            mainViewController = [[UINavigationController alloc] initWithRootViewController:centralViewController];
            [centralViewController release];
            
            @autoreleasepool
            {
                NSString *controllerName  = NSStringFromClass([centralViewController class]);
                
                NSArray *namesArray = [viewsList allKeys];
                
                for (NSString *name in namesArray)
                {
                    NSString *idName = [viewsList objectForKey:name];
                    
                    if ([idName isEqualToString:controllerName])
                    {
                        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 70.f, 40.f)];
                        title.backgroundColor = [UIColor clearColor];
                        title.font = [UIFont boldSystemFontOfSize:34.f];
                        title.textColor = [UIColor whiteColor];
                        title.text = name;
                        
                        mainViewController.navigationBar.topItem.titleView = title;
                        [title release];
                        
                        break;
                    }
                }
            }
        }
        
        [mainViewController beginAppearanceTransition:YES animated:NO];
        
        [self addChildViewController:mainViewController];
        [self.view addSubview:mainViewController.view];
        
        mainViewController.view.frame = self.view.bounds;
        mainViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self setPositionViewControllerView:mainViewController];
        [self setShadowForView:mainViewController.view];
        
        //    [mainViewController beginAppearanceTransition:YES animated:NO];
        [mainViewController endAppearanceTransition];
        [mainViewController didMoveToParentViewController:self];
    }
}

// Method set shadow for given view
- (void)setShadowForView:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowRadius = MMDrawerDefaultShadowRadius;
    view.layer.shadowOpacity = MMDrawerDefaultShadowOpacity;
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
}

// Method set position given UIViewController
- (void)setPositionViewControllerView:(UIViewController *)viewConroller
{
    if (viewConroller)
    {
        CGRect frame = viewConroller.view.frame;
        frame.origin.x = isOpenMainController ? shift : 0.f;
        
        viewConroller.view.frame = frame;
    }
}

// Method round original x
CG_INLINE CGFloat roundedOriginXForDrawerConstriants(CGFloat originX)
{
    if (originX >= shift)
    {
        return shift;
    }
    else if (originX <= 0.f)
    {
        return 0.f;
    }
    
    return originX;
}

@end

@implementation IDManagerViewController (UIPanGestureRecognizer)

-(void)panGestureCallback:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            _startingPanRect = mainViewController.view.frame;
        case UIGestureRecognizerStateChanged:
        {
            CGRect newFrame = _startingPanRect;
            CGPoint translatedPoint = [panGesture translationInView:mainViewController.view];
            newFrame.origin.x = roundedOriginXForDrawerConstriants(CGRectGetMinX(_startingPanRect)+translatedPoint.x);
            newFrame = CGRectIntegral(newFrame);

            CGFloat xOffset = newFrame.origin.x;
            CGFloat percentVisible = 0.f;

            if (xOffset > 0.f)
            {
                percentVisible = xOffset/shift;
            }
            else if (xOffset < 0.f)
            {
                
            }
            
            if (!isOpenMainController)
            {
//                [mainViewController beginAppearanceTransition:NO animated:NO];
//                [mainViewController endAppearanceTransition];
            }
            
            mainViewController.view.center = CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame));
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            _startingPanRect = CGRectZero;
            
            if ([mainViewController.viewControllers count])
            {
                IDViewController *viewController = (IDViewController *)mainViewController.viewControllers[0];
                viewController.moveControllerBlock();
            }
        }
        {
//            self.startingPanRect = CGRectNull;
//            CGPoint velocity = [panGesture velocityInView:self.view];
//            [self finishAnimationForPanGestureWithXVelocity:velocity.x completion:^(BOOL finished) {
//                if(self.gestureCompletion){
//                    self.gestureCompletion(self, panGesture);
//                }
//            }];
            break;
        }
        default:
            break;
    }
}

@end
