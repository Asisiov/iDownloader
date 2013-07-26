//
//  IDViewController.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDManagerDownloaders.h"

@interface IDViewController : UIViewController
{
@protected
    IBOutlet IDManagerDownloaders *downloader;
    
@private
    NSMutableArray *downloadItems;
}

- (IBAction)download:(id)sender;

- (IBAction)pause:(id)sender;

- (IBAction)resume:(id)sender;

- (IBAction)cancel:(id)sender;

@end
