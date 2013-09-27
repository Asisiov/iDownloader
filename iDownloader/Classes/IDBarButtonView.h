//
//  IDBarButtonView.h
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 IDBarButtonView is view of bar button.
 */

@interface IDBarButtonView : UIButton

/// --------------------------------------------------------------------------
/// @name Settings
/// --------------------------------------------------------------------------

@property (nonatomic,retain) UIColor * menuButtonNormalColor;
@property (nonatomic,retain) UIColor * menuButtonHighlightedColor;

@property (nonatomic,retain) UIColor * shadowNormalColor;
@property (nonatomic,retain) UIColor * shadowHighlightedColor;

/// --------------------------------------------------------------------------
/// @name Business Logic Methods
/// --------------------------------------------------------------------------

// Method get button collor appropriate for given state
-(UIColor *)menuButtonColorForState:(UIControlState)state;

// Method set color appropriate given state
-(void)setMenuButtonColor:(UIColor *)color forState:(UIControlState)state;

// Method get shadow button color appropriate given state
-(UIColor *)shadowColorForState:(UIControlState)state;

// Methods set shadow color appropriate for given state
-(void)setShadowColor:(UIColor *)color forState:(UIControlState)state;

@end
