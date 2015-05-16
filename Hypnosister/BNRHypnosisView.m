//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Kris Kata on 5/13/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisView.h"

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = self.bounds;
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The largest circle will circumscribe the view
    float maxRadius = hypotf(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0
                      endAngle:M_PI * 2
                     clockwise:YES];
    }
    
    // Configure line width to 10 points
    path.lineWidth = 10;
    
    // Configure the drawing color to light gray
    [[UIColor lightGrayColor] setStroke];
    
    // Draw the line!
    [path stroke];
    
    // Create smaller rectangle for overlay image
    CGRect overlayBounds = CGRectMake(bounds.size.width / 6.0, bounds.size.height / 6.0, bounds.size.width / 1.5, bounds.size.height / 1.75);
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    [logoImage drawInRect:overlayBounds];
}

@end
