//
//  AARootView.m
//  A-Algorithm
//
//  Created by TheSooth on 7/29/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "AARootView.h"
#define kPointsSize 40

@interface AARootView ()

@property (nonatomic, strong) NSMutableArray *pointsToFill;

@end

@implementation AARootView

- (id)init
{
    self = [super init];
    if (self) {
        self.pointsToFill = [NSMutableArray new];
        map[0][0] = POINT_START;
        map[7][11] = POINT_FINISH;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 84, 84, 84, 1);
    
    for (int y = 0; y < CGRectGetHeight(rect); y+=kPointsSize) {
        for (int x = 0; x < CGRectGetWidth(rect); x+=kPointsSize) {
            CGRect firstTower = CGRectMake(x, y, kPointsSize, kPointsSize);
            CGContextAddRect(context, firstTower);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    CGContextSetRGBFillColor(context, 0, 0, 255, 1);
    
    for (int x = 0; x <= 8 ; x++) {
        for (int y = 0; y <= 12; y++) {
                [self drawWallFromContext:context x:x y:y];
        }
    }
}

- (void)drawWallFromContext:(CGContextRef)aContext x:(NSInteger)aX y:(NSInteger)aY
{
    [self setColorFromPointValue:map[aX][aY] context:aContext];
    
    CGRect wallRect = CGRectMake(aX * kPointsSize, aY * kPointsSize, kPointsSize, kPointsSize);
    
    CGContextAddRect(aContext, wallRect);
    CGContextDrawPath(aContext, kCGPathFillStroke);
}

- (void)setColorFromPointValue:(unsigned char)aPointValue context:(CGContextRef)aContext
{
    switch (aPointValue) {
        case POINT_WALL:
            CGContextSetRGBFillColor(aContext, 0, 0, 255, 1);
            break;
        case POINT_START:
            CGContextSetRGBFillColor(aContext, 0, 255, 0, 1);
            break;
        case POINT_FINISH:
            CGContextSetRGBFillColor(aContext, 255, 0, 0, 1);
            break;
        default:
            CGContextSetRGBFillColor(aContext, 84, 84, 84, 1);
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    CGPoint point = [touch locationInView:self];
    
    NSInteger x = point.x / kPointsSize;
    NSInteger y = point.y / kPointsSize;
    
    if (map[x][y] == POINT_WALL) {
        map[x][y] = POINT_OPEN;
    } else {
        map[x][y] = POINT_WALL;
    }
    
    [self setNeedsDisplay];
}


@end
