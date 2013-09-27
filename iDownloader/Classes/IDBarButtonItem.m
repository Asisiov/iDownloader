//
//  IDBarButtonItem.m
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDBarButtonItem.h"
#import "IDBarButtonView.h"

@implementation IDBarButtonItem

#pragma mark Implementation Initialization Methods

- (id)initWithTarget:(id)target withAction:(SEL)selector withSize:(CGSize)size
{
    IDBarButtonView *buttonView = [[IDBarButtonView alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    self = [self initWithCustomView:buttonView];
    [barButtomView release];
    
    NSLog(@"barButtomView retain count: %i", [buttonView retainCount]);
    
    if (self)
    {
        [buttonView addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        barButtomView = buttonView;
    }
    
    return self;
}

- (void)dealloc
{
    [barButtomView release];
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Returns the current color of the menu button for the state requested.
-(UIColor *)menuButtonColorForState:(UIControlState)state
{
    return [((IDBarButtonView *)barButtomView) menuButtonColorForState:state];
}

// Sets the color of the menu button for the specified state. For this control, only set colors for `UIControlStateNormal` and `UIControlStateHighlighted`.
-(void)setMenuButtonColor:(UIColor *)color forState:(UIControlState)state
{
    [((IDBarButtonView *)barButtomView) setMenuButtonColor:color forState:state];
}

// Returns the current color of the shadow for the state requested.
-(UIColor *)shadowColorForState:(UIControlState)state
{
    return [((IDBarButtonView *)barButtomView) shadowColorForState:state];
}

// Sets the color of the shadow for the specified state. For this control, only set colors for `UIControlStateNormal` and `UIControlStateHighlighted`.
-(void)setShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [((IDBarButtonView *)barButtomView) setShadowColor:color forState:state];
}

#pragma mark -

#pragma mark Implementation Setters/Getters Methdods

// Method set target
- (void)setTarget:(id)target
{
}

// Method get target
- (id)target
{
    return nil;
}

// Method set selector
- (void)setSelector:(SEL)selector
{
}

// Method get selector
- (SEL)selector
{
    return nil;
}

// Method set size
- (void)setSize:(CGSize)size
{
    CGRect frame = CGRectZero;
    frame.size = size;
    barButtomView.frame = frame;
}

#pragma mark -

@end
