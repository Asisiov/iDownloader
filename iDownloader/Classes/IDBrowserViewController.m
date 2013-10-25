//
//  IDBrowserViewController.m
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDBrowserViewController.h"

@interface IDBrowserViewController (Private)

// Method get media extractor.
- (IDURLExtractor *)mediaExtractor;

@end

@implementation IDBrowserViewController

#pragma mark Implemntation Initialization Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [mediaUrlExtractor release];
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:40];
    [webView loadRequest:request];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark Implementation IBActions Methods 

/**
 Method respond on action of goButton.
 */
- (IBAction)goButtonAction:(id)sender
{
    NSString *urlString = @"http://vk.com/video79260883_166446680";//[searchBar text];
    NSLog(@"url: %@", urlString);;
    
#warning should be implement check of url correct 
    
    if (urlString)
    {
        @autoreleasepool
        {
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            mediaUrlExtractor = [self mediaExtractor];
            
            if (mediaUrlExtractor)
            {
                mediaUrlExtractor.webView = webView;
                mediaUrlExtractor.originURL = url;
                
                [webView loadRequest:request];
            }
        }
    }
}

/**
 Method respond on action of downloadButton.
 */
- (IBAction)downloadButtonAction:(id)sender
{
}

#pragma mark -

#pragma mark Implementation UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (mediaUrlExtractor)
    {
        return [mediaUrlExtractor webViewStartLoadingWithRequest:request];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [mediaUrlExtractor webDidFinishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [mediaUrlExtractor webViewDidLoadWithError:error];
}

#pragma mark -

#pragma mark Implemntation IDURLExtractorDelegate Methods

// Method invoke if url was success extracted.
- (void)urlExtractedSuccess:(NSURL *)extractedURL
{
    NSLog(@"--- Extracted url: %@",extractedURL);
}

// Method invoke if url wes error.
- (void)failedExtractURL:(NSError *)error
{
    NSLog(@"--- Extract error: %@", [error description]);
}

#pragma mark -

#pragma mark Implementation Private Methods

// Method get media extractor.
- (IDURLExtractor *)mediaExtractor
{
    if (mediaUrlExtractor == nil)
    {
        mediaUrlExtractor = [[IDURLExtractor alloc] init];
        mediaUrlExtractor.delegate = self;
    }
    
    return mediaUrlExtractor;
}

#pragma mark -

@end
