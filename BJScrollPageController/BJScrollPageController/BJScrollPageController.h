//
//  BJScrollPageControllerViewController.h
//  MomoChat
//
//  Created by booj on 15/10/23.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import "BJCategoryScrollView.h"
#import "BJCategoryScrollView.h"


typedef NS_ENUM(NSInteger, BJQueueType)
{
    BJQueueTypeLeft = 0,
    BJQueueTypeMid  = 1,
    BJQueueTypeRight    = 2,
    BJQueueTypeMoveLeft = 3,
    BJQueueTypeMoveRight    = 4,
};

@interface BJScrollPageController : UIViewController

/*UI相关属性*/
@property (nonatomic, strong) UIColor *catebgColor;
@property (nonatomic, strong) UIColor *cateNormalColor;
@property (nonatomic, strong) UIColor *cateSelectedColor;
@property (nonatomic, strong) UIColor *cateTagColor;

@property (nonatomic, assign) BOOL reuseSource;
@property (nonatomic, strong) UIViewController *selectVC;

- (void)reloadViews;

/*子类复写方法
 *  懒加载头部分类和需添加到pages里面的controller
 */
- (void)prepare;

- (NSArray *)categoryTexts;

- (NSString *)selectCategory;

- (NSArray *)viewControllers;
//需复用Controller时使用
- (NSMutableArray *)queueArray;

-(void)didSelect:(UIViewController *)controller atIndex:(NSInteger)index;

@end
