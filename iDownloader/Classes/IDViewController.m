//
//  IDViewController.m
//  iDownloader
//
//  Created by iMac Asisiov on 9/15/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDViewController.h"
#import "IDBarButtonItem.h"

@interface IDViewController ()

// Method move mainViewController
- (void)moveController:(id)sender;

@end

@implementation IDViewController

@synthesize dataSource = dataSource;
@synthesize moveControllerBlock;

#pragma mark Implementation Initialization Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)dealloc
{
    self.dataSource = nil;
    self.moveControllerBlock = nil;
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create interface
    IDBarButtonItem *leftBarItem = [[IDBarButtonItem alloc] initWithTarget:self withAction:@selector(moveController:) withSize:CGSizeMake(36.f, 36.f)];
    
    NSLog(@"%@", [self.navigationItem description]);
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    //    [leftBarItem release];
    
    [self.navigationController.view.layer setCornerRadius:10.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark Implemntation UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark -

#pragma mark Implemntation UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -

#pragma mark Implementation Private Methods

// Method move mainViewController
- (void)moveController:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if (moveControllerBlock)
    {
        moveControllerBlock();
    }
}

#pragma mark -

@end
