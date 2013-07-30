//
//  AAToolBar.h
//  A-Algorithm
//
//  Created by TheSooth on 7/30/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

@protocol AAToolBarDelegate <NSObject>

- (void)startPointButtonDidPressed;
- (void)wallToolButtonDidPressed;
- (void)finishPointButtonDidPressed;
- (void)openPointButtonDidPressed;

- (void)startButtonDidPressed;
- (void)resetButtonDidPressed;

@end

@interface AAToolBar : UIView

@property (nonatomic, weak) id <AAToolBarDelegate> delegate;

@end
