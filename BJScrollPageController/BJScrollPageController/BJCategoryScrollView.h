//
//  BJCategoryScrollView.h
//  MomoChat
//
//  Created by booj on 15/10/19.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJCategoryLabel.h"
@protocol BJCateGoryScrollViewDelegate;

@interface BJCategoryScrollView : UIScrollView

@property (nonatomic, assign) id <BJCateGoryScrollViewDelegate> categoryDelegate;

- (id)initWith:(NSArray *)categorys colors:(NSArray *)colors;
- (id)initWith:(NSArray *)categorys select:(NSInteger)index colors:(NSArray *)colors;

- (BJCategoryLabel *)labelIndex:(NSInteger)index;

-(void)setSelect:(BJCategoryLabel *)cateLabel by:(BOOL)byself;

- (void)updateBottomTag:(BJCategoryLabel*)cateLabel offsetX:(CGFloat)offsetx;
- (void)updateFontSize:(BJCategoryLabel *)leftLabel rightLabel:(BJCategoryLabel *)rightLabel scale:(CGFloat)scale;

- (void)updateContentOffset;

@end


@protocol BJCateGoryScrollViewDelegate <NSObject>

@optional
- (void)didSelectCategory:(NSInteger)index;

@end