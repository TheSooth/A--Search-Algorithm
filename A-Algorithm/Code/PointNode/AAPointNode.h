//
//  AAPointNode.h
//  A-Algorithm
//
//  Created by TheSooth on 7/30/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAPointNode : NSObject

@property (nonatomic, assign) NSInteger xPoint;
@property (nonatomic, assign) NSInteger yPoint;

@property (nonatomic, assign) NSInteger cost;

@property (nonatomic, weak) AAPointNode *rootNode;

+ (AAPointNode *)pointNode;

@end
