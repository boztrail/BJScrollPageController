//
//  BJCategoryLabel.m
//  MomoChat
//
//  Created by booj on 15/10/19.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import "BJCategoryLabel.h"

@implementation BJCategoryLabel

- (instancetype)init {
    self=[super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15.f];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15.f];
    }
    return self;
}

-(void)setSelect:(BOOL)selected {
    
    if (selected) {
        self.textColor = RGBCOLOR(0, 174, 255);
//            self.font = [UIFont systemFontOfSize:16.f];
    } else {
        self.textColor = RGBCOLOR(140, 140, 140);
//        self.font = [UIFont systemFontOfSize:14.f];
    }
}

@end
