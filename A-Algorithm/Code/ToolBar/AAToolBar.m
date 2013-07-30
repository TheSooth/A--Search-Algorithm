//
//  AAToolBar.m
//  A-Algorithm
//
//  Created by TheSooth on 7/30/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "AAToolBar.h"

@interface AAToolBar ()

@property (nonatomic, strong) UIButton *startPointToolButton;

@end

@implementation AAToolBar

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self setupView];
    }
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithWhite:.3f alpha:.8f];
    
    [self addButtonWithColor:[UIColor greenColor] xPoint:0 action:@selector(startPointToolButtonDidPressed)];
    [self addButtonWithColor:[UIColor blueColor] xPoint:kPointsSize + 1 action:@selector(wallToolButtonDidPressed)];
    [self addButtonWithColor:[UIColor redColor] xPoint:kPointsSize * 2 action:@selector(finishPointToolButtonDidPressed)];
    [self addButtonWithColor:[UIColor whiteColor] xPoint:kPointsSize * 3 action:@selector(openPointToolButtonDidPressed)];
    [self addButtonWithColor:[UIColor orangeColor] frame:CGRectMake(kPointsSize * 4, 0, kPointsSize * 2, kPointsSize) action:@selector(startButtonDidPressed) title:@"Start"];
    [self addButtonWithColor:[UIColor magentaColor] frame:CGRectMake(kPointsSize * 6, 0, kPointsSize * 2, kPointsSize) action:@selector(resetButtonDidPressed) title:@"Reset"];
}

- (void)addButtonWithColor:(UIColor *)aColor xPoint:(NSInteger)aXPoint action:(SEL)aAction
{
    CGRect frame = CGRectMake(aXPoint, 0, kPointsSize, kPointsSize);
    
    [self addButtonWithColor:aColor frame:frame action:aAction title:Nil];
}

- (void)addButtonWithColor:(UIColor *)aColor frame:(CGRect)aFrame action:(SEL)aAction title:(NSString *)aTitle
{
    UIButton *button = [UIButton new];
    button.frame = aFrame;
    button.backgroundColor = aColor;
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    
    [button addTarget:self action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)wallToolButtonDidPressed
{
    [self.delegate wallToolButtonDidPressed];
}

- (void)startPointToolButtonDidPressed
{
    [self.delegate startPointButtonDidPressed];
}

- (void)finishPointToolButtonDidPressed
{
    [self.delegate finishPointButtonDidPressed];
}

- (void)openPointToolButtonDidPressed
{
    [self.delegate openPointButtonDidPressed];
}

- (void)startButtonDidPressed
{
    [self.delegate startButtonDidPressed];
}

- (void)resetButtonDidPressed
{
    [self.delegate resetButtonDidPressed];
}

@end
