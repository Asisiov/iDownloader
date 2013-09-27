//
//  IDBarButtonItem.h
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 IDBarButtonItem is custom bar button.
 **/
@interface IDBarButtonItem : UIBarButtonItem
{
@protected
    UIButton *barButtomView;
}

/// ------------------------------------------------------------------------------
/// @name Settings
/// ------------------------------------------------------------------------------

/**
 Set/Get target of button.
 */
@property (nonatomic, assign) id target;

/**
 Set/Get selector.
 */
@property (nonatomic, assign) SEL selector;

/**
 Set/Get the button size.
 */
@property (nonatomic,assign) CGSize size;

/// ------------------------------------------------------------------------------
/// @name Initialization Methods
/// ------------------------------------------------------------------------------

/**
 Method initializate IDBarButtonItem instance.
 @param target target of button
 @param selector action methods
 @param size the size of button view
 @return id a new instance of IDBarButtonItem
 */

- (id)initWithTarget:(id)target withAction:(SEL)selector withSize:(CGSize)size;

/// ------------------------------------------------------------------------------
/// @name Business Logic Methods
/// ------------------------------------------------------------------------------

/**
 Returns the current color of the menu button for the state requested.
 
 @param state The UIControl state that the color is being requested for.
 
 @return The menu button color for the requested state.
 */
-(UIColor *)menuButtonColorForState:(UIControlState)state;

/**
 Sets the color of the menu button for the specified state. For this control, only set colors for `UIControlStateNormal` and `UIControlStateHighlighted`.
 
 @param color The color to set.
 @param state The state to set the color for.
 */
-(void)setMenuButtonColor:(UIColor *)color forState:(UIControlState)state;

/**
 Returns the current color of the shadow for the state requested.
 
 @param state The UIControl state that the color is being requested for.
 
 @return The menu button color for the requested state.
 */
-(UIColor *)shadowColorForState:(UIControlState)state;

/**
 Sets the color of the shadow for the specified state. For this control, only set colors for `UIControlStateNormal` and `UIControlStateHighlighted`.
 
 @param color The color to set.
 @param state The state to set the color for.
 */
-(void)setShadowColor:(UIColor *)color forState:(UIControlState)state;

@end
