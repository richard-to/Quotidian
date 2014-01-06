//
//  DayCheckView.m
//  Quotidian
//
//  Created by Richard To on 1/5/14.
//  Copyright (c) 2014 Richard To. All rights reserved.
//

#import "DayCheckView.h"

@interface DayCheckView ()
@property (nonatomic, strong) NSMutableArray *drawPoints;
@property (nonatomic, strong) NSMutableArray *currentLine;
@property (nonatomic, strong) UIColor *lineColor;
@end

@implementation DayCheckView

// TODO(richard-to): Not the best solution to duplicate colors here...
typedef struct {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
} hsba;

const hsba LINE_COLOR = {
    100.0/360.0,
    0.42,
    0.8,
    1.0
};

// TODO(richard-to): Probably don't want these as constants either.
const CGFloat LINE_WIDTH = 10.0;
const CGLineCap LINE_CAP = kCGLineCapRound;

@synthesize drawPoints = _drawPoints;
@synthesize currentLine = _currentLine;
@synthesize lineColor = _lineColor;

// TODO(richard-to): Is this a bad practice in iOS?
BOOL isDrawing = NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIGraphicsPushContext(context);
    
    // TODO(richard-to): We don't want to create UIColor object everytime...
    CGContextSetStrokeColorWithColor(context,
        [[UIColor colorWithHue:LINE_COLOR.hue saturation:LINE_COLOR.saturation brightness:LINE_COLOR.brightness alpha: LINE_COLOR.alpha] CGColor]);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if (self.drawPoints.count > 0) {
        CGContextBeginPath(context);
        for (NSMutableArray *lines in self.drawPoints) {
            CGPoint point = [[lines objectAtIndex:0] CGPointValue];
            CGContextMoveToPoint(context, point.x, point.y);
            for (NSValue *value in lines) {
                point = [value CGPointValue];
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }
        CGContextStrokePath(context);
    }

    if (self.currentLine.count > 0) {
        CGContextBeginPath(context);
        CGPoint point = [[self.currentLine objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(context, point.x, point.y);
        for (NSValue *value in self.currentLine) {
            point = [value CGPointValue];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextStrokePath(context);
    }
    UIGraphicsPopContext();
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        self.currentLine = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint: touchPoint]];
        isDrawing = YES;
    } else {
        isDrawing = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self && [[event allTouches] count] == 1) {
        CGPoint touchPoint = [touch locationInView:self];
        [self.currentLine addObject:[NSValue valueWithCGPoint: touchPoint]];
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch view] == self) {
        self.currentLine = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self && [[event allTouches] count] == 1) {
        CGPoint touchPoint = [touch locationInView:self];
        [self.currentLine addObject:[NSValue valueWithCGPoint: touchPoint]];
        [self.drawPoints addObject: self.currentLine];
    } else if(isDrawing == NO) {
        self.currentLine = nil;
        self.drawPoints = nil;
    }
    [self setNeedsDisplay];
}


#pragma mark - Getters/Setters methods

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setDrawPoints:(NSMutableArray *)drawPoints
{
    _drawPoints = drawPoints;
    [self setNeedsDisplay];
}

- (NSMutableArray *)drawPoints
{
    if (_drawPoints == nil) {
        _drawPoints = [[NSMutableArray alloc] init];
    }
    return _drawPoints;
}

- (void)setCurrentLine:(NSMutableArray *)currentLine
{
    _currentLine = currentLine;
    [self setNeedsDisplay];
}

- (NSMutableArray *)currentLine
{
    if (_currentLine == nil) {
        _currentLine = [[NSMutableArray alloc] init];
    }
    return _currentLine;
}


@end
