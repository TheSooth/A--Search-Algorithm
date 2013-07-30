//
//  AARootView.h
//  A-Algorithm
//
//  Created by TheSooth on 7/29/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAPointNode.h"

#define POINT_OPEN 0
#define POINT_WALL 1
#define POINT_START 2
#define POINT_FINISH 3
#define POINT_MARKED 4

#define xMAX 8
#define yMAX 12

@interface AARootView : UIView
{
    unsigned char map[xMAX][yMAX];
}

@property (nonatomic, assign) NSInteger startX;
@property (nonatomic, assign) NSInteger startY;

@property (nonatomic, assign) NSInteger endX;
@property (nonatomic, assign) NSInteger endY;

@end
