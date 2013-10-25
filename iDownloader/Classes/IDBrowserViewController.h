//
//  IDBrowserViewController.h
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDViewController.h"
#import "IDURLExtractor.h"

@interface IDBrowserViewController : IDViewController <UIWebViewDelegate, IDURLExtractorDelegate>
{
@protected
    IBOutlet UIWebView *webView;
    IBOutlet UITextField *searchBar;
    IBOutlet UIButton *goButton;
    IBOutlet UIButton *downloadButton;
    
@protected
    IDURLExtractor *mediaUrlExtractor;
}

/// ---------------------------------------------------------------------------
/// @name IBActions methods
/// ---------------------------------------------------------------------------

/**
 Method respond on action of goButton.
 */
- (IBAction)goButtonAction:(id)sender;

/**
 Method respond on action of downloadButton.
 */
- (IBAction)downloadButtonAction:(id)sender;

@end
