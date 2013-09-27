//
//  IDViewController.h
//  iDownloader
//
//  Created by iMac Asisiov on 9/15/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoveController)(void);

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
    NSArray *dataSource;
}

/// ----------------------------------------------------------------------------------------------
/// @name Settings
/// ----------------------------------------------------------------------------------------------

/**
 Set/Get data source.
 */
@property (nonatomic, retain) NSArray *dataSource;

/**
 Set/Get block for move controller
 */
@property (nonatomic, copy) MoveController moveControllerBlock;

@end
