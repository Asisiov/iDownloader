//
//  IDURLExtractor.m
//  iDownloader
//
//  Created by iMac Asisiov on 10/25/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDURLExtractor.h"

@interface IDURLExtractor (Private)

// Method load document
- (void)domLoaded;

// Very possible that the DOM isn't really loaded after all or sth failed. Try to load website again.
- (BOOL)doRetry;

@end

@implementation IDURLExtractor

@synthesize webView;
@synthesize delegate;
@synthesize originURL;

// The internal delegate will intercept this load and forward the event to the real delegate
static NSString *const testDOM = @"var _SSWebViewDOMLoadTimer=setInterval(function(){if(/loaded|complete/.test(document.readyState)){clearInterval(_SSWebViewDOMLoadTimer);location.href='x-sswebview://dom-loaded'}},10);";

static NSString *const scriptGetMediaURL = @"document.getElementsByTagName('video')[0].getAttribute('src')";

static const NSUInteger maxNumberOfRetries = 4; // numbers of retries
static const CGFloat watchdogDelay = 3.f;       // seconds we wait for the DOM
static const CGFloat  extraDOMDelay = 3.f;      // if DOM doesn't load, wait for some extra time

#pragma mark Implementation Initialization Methods

- (void)dealloc
{
    self.webView = nil;
    self.delegate = nil;
    self.originURL = nil;
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method check url scheme and set request.
- (BOOL)webViewStartLoadingWithRequest:(NSURLRequest *)request
{
    BOOL should = YES;
    
	NSURL *url = [request URL];
	NSString *scheme = [url scheme];
    
	// Check for DOM load message
	if ([scheme isEqualToString:@"x-sswebview"])
    {
		NSString *host = [url host];
        
		if ([host isEqualToString:@"dom-loaded"])
        {
			[self domLoaded];
		}
        
		return NO;
	}
    else
    {
		should = ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]);
	}
    
	// Stop if we shouldn't load it
	if (!should)
    {
		return NO;
	}
    
	// Starting a new request
	if (![[request mainDocumentURL] isEqual:[request_ mainDocumentURL]])
    {
		request_ = [request retain];
		testedDOM = NO;
	}
    
	return should;
}

// Method invoke some javascript.
- (void)webDidFinishLoad
{
    // Check DOM
	if (!testedDOM)
    {
		testedDOM = YES;
		[webView stringByEvaluatingJavaScriptFromString:testDOM];
	}
    
    // add watchdog in case DOM never get initialized
    [self performSelector:@selector(domLoaded) withObject:nil afterDelay:watchdogDelay];
}

// Method make data clean.
- (void)webViewDidLoadWithError:(NSError *)error
{
    NSAssert(error, @"The object 'error' is nil.");
    
    if (![self doRetry])
    {
        if (delegate && [delegate respondsToSelector:@selector(failedExtractURL:)])
        {
            [delegate failedExtractURL:error];
        }

        [self cleanup];
    }
}

// Method clean resource
- (void)cleanup
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(domLoaded) object:nil]; // cancel watchdog
    [webView stopLoading];
    
    self.webView = nil;
    self.originURL = nil;
    
    retryCount = 0;
    domWaitCounter = 0;
}

#pragma mark -

#pragma mark Implementation Private Methods

// Method load document
- (void)domLoaded
{
    // figure out if we can extract the youtube url!
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *mediaURL = [webView stringByEvaluatingJavaScriptFromString:scriptGetMediaURL];
    
    if ([mediaURL hasPrefix:@"http"])
    {
        // probably ok
        done = YES;

        if (delegate)
        {
            NSURL *url = [NSURL URLWithString:mediaURL];

            [delegate urlExtractedSuccess:url];
        }
        
        [self cleanup];
    }
    else
    {
        if (domWaitCounter < extraDOMDelay * 2)
        {
            ++domWaitCounter;
            
            [self performSelector:@selector(domLoaded) withObject:nil afterDelay:0.5f]; // try every 0.5 sec
            
            [pool drain];
            return;
        }
        
        if (![self doRetry])
        {
            if (delegate && [delegate respondsToSelector:@selector(failedExtractURL:)])
            {
                NSError *error = [NSError errorWithDomain:@"com.petersteinberger.betteryoutube" code:100 userInfo:[NSDictionary dictionaryWithObject:@"MP4 URL could not be found." forKey:NSLocalizedDescriptionKey]];
                [delegate failedExtractURL:error];
            }

            [self cleanup];
        }
    }
    
    [pool drain];
}

// Very possible that the DOM isn't really loaded after all or sth failed. Try to load website again.
- (BOOL)doRetry
{
//    if (retryCount_ <= kMaxNumberOfRetries + 1 && !done)
    {
        ++retryCount;
        domWaitCounter = 0;
        
        NSLog(@"Trying to load page...");
        
        if (webView)
        {
            [webView loadRequest:[NSURLRequest requestWithURL:originURL]];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(domLoaded) object:nil];
            return YES;
        }
        
        return NO;
    }
    return NO;

}

#pragma mark -

@end
