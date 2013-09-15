//
//  IDViewController.h
//  iDownloader
//
//  Created by iMac Asisiov on 9/15/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDViewController;

@protocol IDViewControllerDelegate <NSObject>

// The type of separete block for move view
typedef void (^IDMoveViewController)(IDViewController *viewController);

/**
 Methods call wen user moving controllers all take by 'Move' button
 @param moveBlock block with code for move cview controllers
 */
- (void)moveViewControllerToRight:(IDMoveViewController)moveBlock;

@end

/**
 IDViewController is root class for view controlers which represent for users interaction with app.
 */

@interface IDViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
// User Interface
@protected
    IBOutlet UITableView *tableView;
    
//Data atributtes
@protected
    id<IDViewControllerDelegate> delegate;
    NSArray *dataSource;
}

/// ----------------------------------------------------------------------------------------------
/// @name Settings
/// ----------------------------------------------------------------------------------------------

/**
 Set/Get delegate.
 */
@property (nonatomic, assign) id<IDViewControllerDelegate> delegate;

/**
 Set/Get data source.
 */
@property (nonatomic, retain) NSArray *dataSource;

/// ----------------------------------------------------------------------------------------------
/// @name IB Actions Methods
/// ----------------------------------------------------------------------------------------------

/**
 Methods is selector for 'Move' button.
 @param sender 'Move' button
 */
- (IBAction)moveController:(id)sender;

@end
