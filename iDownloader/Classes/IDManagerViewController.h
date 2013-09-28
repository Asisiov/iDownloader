//
//  IDViewController.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDManagerDownloaders.h"

/**
 The instance of 'IDManagerViewController' manage all views controllers and incapsulate logic of massenges between they.
 */

@interface IDManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
@protected
    IBOutlet IDManagerDownloaders *downloader;
    
// UIViews
@protected
    UINavigationController *mainViewController;   //visible (current) controller
    IBOutlet UITableView *viewsTable;
    
@private
    NSMutableArray *downloadItems;
    NSDictionary *viewsList;                     //data source for 'viewsTable'
    
@private
    BOOL isOpenMainController;
    CGRect _startingPanRect;
}

- (IBAction)download:(id)sender;

- (IBAction)pause:(id)sender;

- (IBAction)resume:(id)sender;

- (IBAction)cancel:(id)sender;

@end
