//
//  BarGraphView.m
//  Quotidian
//
//  Created by Richard To on 1/8/14.
//  Copyright (c) 2014 Richard To. All rights reserved.
//

#import "BarGraphView.h"

@implementation BarGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGFloat vTicks = (rect.size.height) / 16;
    CGFloat hTicks = (rect.size.width) / 4;

    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 2);
    CGContextStrokePath(context);

    // Dummy Data For Now
    int t[] = {4, 6, 0, 5};

    for (int i = 0; i < 7; i++) {
            CGRect bar = CGRectMake(i * hTicks, (rect.size.height / 2) - vTicks * t[i], hTicks, vTicks * t[i]);
            CGRect strokeRect = CGRectInset(bar, 5.0, 1);
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextFillRect(context, strokeRect);

            CGRect bar1 = CGRectMake(i * hTicks, (rect.size.height / 2), hTicks, vTicks * (7 - t[i]));
            CGRect strokeRect1 = CGRectInset(bar1, 5.0, 1);
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextFillRect(context, strokeRect1);

    }
    UIGraphicsPopContext();
}

@end
