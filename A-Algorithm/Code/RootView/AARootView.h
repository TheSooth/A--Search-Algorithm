//
//  AARootView.h
//  A-Algorithm
//
//  Created by TheSooth on 7/29/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINT_OPEN 0
#define POINT_WALL 1
#define POINT_START 2
#define POINT_FINISH 3

@interface AARootView : UIView
{
    int map[8][12];
}

@end
