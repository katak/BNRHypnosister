//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Kris Kata on 5/13/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
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
    [self.circleColor setStroke];
    
    // Draw the line!
    [path stroke];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Create smaller rectangle for overlay image
    CGRect overlayBounds = CGRectMake(bounds.size.width / 6.0, bounds.size.height / 6.0, bounds.size.width / 1.5, bounds.size.height / 1.75);
    
    UIBezierPath *triangle = [[UIBezierPath alloc] init];
    CGPoint top = CGPointMake(overlayBounds.origin.x + overlayBounds.size.width / 2.0, overlayBounds.origin.y);
    [triangle moveToPoint:top];
    [triangle addLineToPoint:CGPointMake(overlayBounds.origin.x, overlayBounds.origin.y + overlayBounds.size.height * 1.1)];
    [triangle addLineToPoint:CGPointMake(overlayBounds.origin.x + overlayBounds.size.width, overlayBounds.origin.y + overlayBounds.size.height * 1.1)];
    [triangle addLineToPoint:top];
    [triangle stroke];
    
    CGContextSaveGState(currentContext);
    [triangle addClip];
    
    // Create gradient
    CGFloat locations[2] = { 0.8, 0.0 };
    CGFloat components[8] = { 1.0, 1.0, 0.0, 1.0,   // Start color is yellow
        0.0, 1.0, 0.0, 1.0 }; // End color is green
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(overlayBounds.origin.x + overlayBounds.size.width / 2.0, overlayBounds.origin.y);
    CGPoint endPoint = CGPointMake(overlayBounds.origin.x + overlayBounds.size.width / 2.0, overlayBounds.origin.y + overlayBounds.size.height * 1.1);
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(currentContext);
    
    // Create logo with shadow
    CGContextSaveGState(currentContext);
    
    CGContextSetShadow(currentContext, CGSizeMake(4,7), 3);
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    [logoImage drawInRect:overlayBounds];
    
    CGContextRestoreGState(currentContext);
}

// When a finger touches the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    // Get 3 random numbers between 0 and 1
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
