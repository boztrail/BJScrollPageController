//
//  BJCategoryLabel.h
//  MomoChat
//
//  Created by booj on 15/10/19.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BJScreenWidth   [UIScreen mainScreen].bounds.size.width
#define BJScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface BJCategoryLabel : UILabel

@end
