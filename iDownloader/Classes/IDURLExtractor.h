//
//  IDURLExtractor.h
//  iDownloader
//
//  Created by iMac Asisiov on 10/25/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IDURLExtractorDelegate conteine callback methods for extract media url.
 */
@protocol IDURLExtractorDelegate <NSObject>

@required

/**
 Method invoke if url was success extracted.
 @param extractedURL extracted url
 */
- (void)urlExtractedSuccess:(NSURL *)extractedURL;

@optional

/**
 Method invoke if url wes error.
 @param error object describe error
 */
- (void)failedExtractURL:(NSError *)error;

@end

/**
 The instance of IDURLExtractor extract media url (video/audio) from web view regust.
 After invoke cleanup method web view and origin url are nil.
 */
@interface IDURLExtractor : NSObject
{
@protected
    BOOL testedDOM;
    BOOL done;
    
    NSUInteger retryCount;
    NSInteger  domWaitCounter;
    
@private
    NSURLRequest *request_;
}

/// ---------------------------------------------------
/// @name Settings
/// ---------------------------------------------------

/**
 Property set/get UIWebView.
 NOTE: An instance of IDURLExtractor use some javascripts for extract url.
 */
@property (nonatomic, assign) UIWebView *webView;

/**
 Property set/get delegate.
 */
@property (nonatomic, assign) id<IDURLExtractorDelegate> delegate;

/**
 Origin url set to web view request. You hould set it before make load request to web view.
 */
@property (nonatomic, copy) NSURL *originURL;

/// ---------------------------------------------------
/// @name Business Logic Methods
/// ---------------------------------------------------

/**
 Method check url scheme and set request.
 NOTE: You should be call it methods in [UIWebView webView: shouldStartLoadWithRequest: navigationType:] method.
 @param request request from web view
 @return BOOL Only load http or http requests if delegate doesn't care.
 */
- (BOOL)webViewStartLoadingWithRequest:(NSURLRequest *)request;

/**
 Method invoke some javascript.
 You should be call it methods in [UIWebView webViewDidFinishLoad:] method.
 */
- (void)webDidFinishLoad;

/**
 Method make data clean.
 You should be call it methods in [UIWebView webViewDidFinishLoad:] method.
 @param error error
 */
- (void)webViewDidLoadWithError:(NSError *)error;

// Method clean resource
- (void)cleanup;

@end
