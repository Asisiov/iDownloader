//
//  IDBarButtonView.m
//  iDownloader
//
//  Created by iMac Asisiov on 9/21/13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDBarButtonView.h"

@implementation IDBarButtonView

#pragma mark Implementation Initialization Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.menuButtonNormalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
        self.menuButtonHighlightedColor = [UIColor colorWithRed:139.0/255.0
                                                          green:135.0/255.0
                                                           blue:136.0/255.0
                                                          alpha:0.9f];
        
        self.shadowNormalColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        self.shadowHighlightedColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    }
    return self;
}

- (void)dealloc
{
    self.menuButtonNormalColor = nil;
    self.menuButtonHighlightedColor = nil;
    self.shadowNormalColor = nil;
    self.shadowHighlightedColor = nil;
    [super dealloc];
}

#pragma mark -

#pragma mark Implementation LifeCycle Methods

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Sizes
    CGFloat buttonWidth = CGRectGetWidth(self.bounds)*.80;
    CGFloat buttonHeight = CGRectGetHeight(self.bounds)*.16;
    CGFloat xOffset = CGRectGetWidth(self.bounds)*.10;
    CGFloat yOffset = CGRectGetHeight(self.bounds)*.12;
    CGFloat cornerRadius = 1.0;
    
    //// Color Declarations
    UIColor*  buttonColor = [self menuButtonColorForState:self.state];
    UIColor*  shadowColor = [self shadowColorForState:self.state];
    
    
    //// Shadow Declarations
    UIColor* shadow =  shadowColor;
    CGSize shadowOffset = CGSizeMake(0.0, 1.0);
    CGFloat shadowBlurRadius = 0;
    
    //// Top Bun Drawing
    UIBezierPath* topBunPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight) cornerRadius:cornerRadius];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [buttonColor setFill];
    [topBunPath fill];
    CGContextRestoreGState(context);
    
    //// Meat Drawing
    UIBezierPath* meatPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xOffset, yOffset*2 + buttonHeight, buttonWidth, buttonHeight) cornerRadius:cornerRadius];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [buttonColor setFill];
    [meatPath fill];
    CGContextRestoreGState(context);
    
    //// Bottom Bun Drawing
    UIBezierPath* bottomBunPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xOffset, yOffset*3 + buttonHeight*2, buttonWidth, buttonHeight) cornerRadius:cornerRadius];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [buttonColor setFill];
    [bottomBunPath fill];
    CGContextRestoreGState(context);
}

#pragma mark -

#pragma mark Implementation Business Logic Methods

// Method get button collor appropriate for given state
-(UIColor *)menuButtonColorForState:(UIControlState)state
{
    UIColor * color = nil;
    
    switch (state)
    {
        case UIControlStateNormal:
            color = self.menuButtonNormalColor;
            break;
        case UIControlStateHighlighted:
            color = self.menuButtonHighlightedColor;
            break;
        default:
            break;
    }
    
    return color;
}

// Method set color appropriate given state
-(void)setMenuButtonColor:(UIColor *)color forState:(UIControlState)state
{
    switch (state)
    {
        case UIControlStateNormal:
            self.menuButtonNormalColor = color;
            break;
        case UIControlStateHighlighted:
            self.menuButtonHighlightedColor = color;
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

// Method get shadow button color appropriate given state
-(UIColor *)shadowColorForState:(UIControlState)state
{
    UIColor * color = color;
    
    switch (state)
    {
        case UIControlStateNormal:
            color = self.shadowNormalColor;
            break;
        case UIControlStateHighlighted:
            color = self.shadowHighlightedColor;
            break;
        default:
            break;
    }
    
    return color;
}

// Methods set shadow color appropriate for given state
-(void)setShadowColor:(UIColor *)color forState:(UIControlState)state
{
    switch (state)
    {
        case UIControlStateNormal:
            self.shadowNormalColor = color;
            break;
        case UIControlStateHighlighted:
            self.shadowHighlightedColor = color;
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

#pragma mark -

@end
