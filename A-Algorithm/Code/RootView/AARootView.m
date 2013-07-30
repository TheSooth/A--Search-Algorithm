//
//  AARootView.m
//  A-Algorithm
//
//  Created by TheSooth on 7/29/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "AARootView.h"
#import "AAToolBar.h"

@interface AARootView () <AAToolBarDelegate>

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) AAToolBar *toolBar;

@property (nonatomic, assign) NSInteger currentTool;

@end

@implementation AARootView

- (id)init
{
    self = [super init];
    if (self) {
        self.currentTool = POINT_WALL;
        
        self.startX = 5;
        self.startY = 5;
        
        self.endX = 1;
        self.endY = 1;
        
        map[self.startX][self.startY] = POINT_START;
        map[self.endX][self.endY] = POINT_FINISH;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 84, 84, 84, 1);
    
    for (int y = 0; y < CGRectGetHeight(rect); y+=kPointsSize) {
        for (int x = 0; x < CGRectGetWidth(rect); x+=kPointsSize) {
            CGRect squareRect = CGRectMake(x, y, kPointsSize, kPointsSize);
            UIRectFill(squareRect);
        }
    }
    
    CGContextSetRGBFillColor(context, 0, 0, 255, 1);
    
    for (int x = 0; x <= 8 ; x++) {
        for (int y = 0; y <= 12; y++) {
            [self drawWallFromContext:context x:x y:y];
        }
    }
    
    [self drawWallFromContext:context x:self.startX y:self.startY];
    
    if (!self.toolBar) {
        self.toolBar = [[AAToolBar alloc] initWithFrame:CGRectMake(0, 440, 320, kPointsSize)];
        self.toolBar.delegate = self;
        [self addSubview:self.toolBar];
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
        case POINT_MARKED:
            CGContextSetRGBFillColor(aContext, 0, 0, 0, 1);
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
    
    if (self.currentTool == POINT_START) {
        map[self.startX][self.startY] = POINT_OPEN;
        
        self.startX = x;
        self.startY = y;
    } else if (self.currentTool == POINT_FINISH) {
        map[self.endX][self.endY] = POINT_OPEN;
        
        self.endX = x;
        self.endY = y;
    } else if (self.currentTool == POINT_OPEN) {
        if ((self.startX == x && self.startY == y) || (self.endX == x && self.endY == y)) {
            return;
        }
    }
    
    map[x][y] = self.currentTool;
    
    [self setNeedsDisplay];
}

- (void)findAtStartX:(NSInteger)aStartX startY:(NSInteger)aStartY endX:(NSInteger)aEndX endY:(NSInteger)aEndY
{
    if (aStartX == aEndX && aStartY == aEndY) {
        return;
    }
    
    NSInteger newXPoint, newYPoint;
    NSInteger currentXPoint, currentYPoint;
    
    NSMutableArray *passedNodes, *passableNodes;
    
    passedNodes = [NSMutableArray new];
    passableNodes = [NSMutableArray new];
    
    AAPointNode *currentNode = nil;
    AAPointNode *nextNode = nil;
    
    AAPointNode *startNode = [AAPointNode pointNode];
    startNode.xPoint = aStartX;
    startNode.yPoint = aStartY;
    startNode.cost = 0;
    
    [passableNodes addObject:startNode];
    
    while (passableNodes.count) {
        currentNode = [self lowestCostNodeFromArray:passableNodes];
        
        if ([self node:currentNode isEqualToEndX:aEndX equalToEndY:aEndY]) {
            [self finish];
            
            nextNode = currentNode.rootNode;
            
            while (nextNode.rootNode) {
                map[nextNode.xPoint][nextNode.yPoint] = POINT_MARKED;
                nextNode = nextNode.rootNode;
            }
            
            return;
        }
        
        [passableNodes removeObject:currentNode];
        [passedNodes addObject:currentNode];
        
        currentXPoint = currentNode.xPoint;
        currentYPoint = currentNode.yPoint;
        
        
        for (int y = -1; y <= 1; y++) {
            newYPoint = currentYPoint + y;
            for (int x = -1; x <= 1; x++) {
                newXPoint = currentXPoint + x;
                
                if ((newXPoint >= 0 && newYPoint >=0) && (newXPoint < 8 && newYPoint < 12)) {
                    
                    if (y || x) {
                        BOOL nodeIsAlreadyInPassableNodesArray = [self nodeFromArray:passableNodes withXPoint:newXPoint withYPoint:newYPoint] != nil;
                        BOOL nodeIsAlreadyInPassedNodesArray = [self nodeFromArray:passedNodes withXPoint:newXPoint withYPoint:newYPoint] != nil;
                        BOOL isBlockedByWall = [self isBlockedWithWallXPoint:newXPoint yPoint:newYPoint];
                        
                        if (!nodeIsAlreadyInPassableNodesArray && !nodeIsAlreadyInPassedNodesArray && !isBlockedByWall) {
                            nextNode = [AAPointNode pointNode];
                            nextNode.xPoint = newXPoint;
                            nextNode.yPoint = newYPoint;
                            nextNode.rootNode = currentNode;
                            nextNode.cost = currentNode.cost + 1;
                            
                            [passableNodes addObject:nextNode];
                            
                            [self setNeedsDisplay];
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"Path not found!");
}

- (BOOL)isBlockedWithWallXPoint:(NSInteger)aXPoint yPoint:(NSInteger)aYPoint
{
    if (map[aXPoint][aYPoint] == POINT_WALL) {
        return YES;
    }
    
    return NO;
}

- (AAPointNode *)lowestCostNodeFromArray:(NSArray *)aArray
{
    AAPointNode *lowestNode = aArray[0];
    
    for (AAPointNode *pointNode in aArray) {
        if (lowestNode.cost > pointNode.cost) {
            lowestNode = pointNode;
        }
    }
    
    return lowestNode;
}

- (AAPointNode *)nodeFromArray:(NSArray *)aArray withXPoint:(NSInteger)aXPoint withYPoint:(NSInteger)aYPoint
{
    for (AAPointNode *pointNode in aArray) {
        if (pointNode.xPoint == aXPoint && pointNode.yPoint == aYPoint) {
            return pointNode;
        }
    }
    
    return nil;
}

- (BOOL)node:(AAPointNode *)aNode isEqualToEndX:(NSInteger)aEndX equalToEndY:(NSInteger)aEndY
{
    return (aNode.xPoint == aEndX && aNode.yPoint == aEndY);
}

- (void)finish
{
    [self setNeedsDisplay];
    
    NSLog(@"Path is Founded!");
}

- (void)startPointButtonDidPressed
{
    self.currentTool = POINT_START;
}

- (void)wallToolButtonDidPressed
{
    self.currentTool = POINT_WALL;
}

- (void)finishPointButtonDidPressed
{
    self.currentTool = POINT_FINISH;
}

- (void)openPointButtonDidPressed
{
    self.currentTool = POINT_OPEN;
}

- (void)startButtonDidPressed
{
    [self start];
}

- (void)start
{
    [self findAtStartX:self.startX startY:self.startY endX:self.endX endY:self.endY];
}

- (void)resetButtonDidPressed
{
    [self reset];
}

- (void)reset
{
    for (int x = 0; x < xMAX; x++) {
        for (int y = 0; y < yMAX; y++) {
            if (map[x][y] != POINT_START && map[x][y] != POINT_FINISH) {
                map[x][y] = POINT_OPEN;
            }
        }
    }
    
    [self setNeedsDisplay];
}

@end
