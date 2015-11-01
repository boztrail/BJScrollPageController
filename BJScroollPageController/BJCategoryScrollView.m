//
//  BJCategoryScrollView.m
//  MomoChat
//
//  Created by booj on 15/10/19.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import "BJCategoryScrollView.h"
#import "BJCategoryLabel.h"

#define kCateGoryViewHeight     44.f
#define kBottomTagViewHeight    2.f

@interface BJCategoryScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat containerWidth;
@property (nonatomic, assign) BJCategoryLabel *selectLabel;

@property (nonatomic, strong) UIView *bottomtTag;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIColor *cateNormalColor;
@property (nonatomic, strong) UIColor *cateSelectedColor;
@property (nonatomic, strong) UIColor *cateTagColor;

@end

@implementation BJCategoryScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
    }
    return self;
}

- (void)updateBottomTag:(BJCategoryLabel*)cateLabel offsetX:(CGFloat)offsetx {
    
    CGPoint point = CGPointMake(CGRectGetMidX(cateLabel.frame)+offsetx, self.frame.size.height-1);
    _bottomtTag.center = point;
}

- (void)updateFontSize:(BJCategoryLabel *)leftLabel rightLabel:(BJCategoryLabel *)rightLabel scale:(CGFloat)scale {
    
    leftLabel.textColor = [self normalColorWith:fabs(scale)];
    rightLabel.textColor = [self selectedColorWith:fabs(scale)];
    
    CGFloat ltextWidth = 20 + [leftLabel.text boundingRectWithSize:CGSizeMake(BJScreenWidth, 20) options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:
                           [NSDictionary dictionaryWithObjectsAndKeys:leftLabel.font, NSFontAttributeName, nil] context:nil].size.width;
    CGFloat rtextWidth = 20 + [rightLabel.text boundingRectWithSize:CGSizeMake(BJScreenWidth, 20) options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:
                          [NSDictionary dictionaryWithObjectsAndKeys:rightLabel.font, NSFontAttributeName, nil] context:nil].size.width;
    CGRect rect = _bottomtTag.frame;
    rect.size.width = ltextWidth + fabs(scale)*(rtextWidth-ltextWidth);
    _bottomtTag.frame = rect;
}

- (UIColor *)normalColorWith:(CGFloat)scale {
    NSDictionary *nDic = [self getRGBDictionaryByColor:_cateNormalColor];
    NSDictionary *sDic = [self getRGBDictionaryByColor:_cateSelectedColor];
    CGFloat _r = [[sDic objectForKey:@"R"] floatValue] - [[nDic objectForKey:@"R"] floatValue];
    CGFloat _g = [[sDic objectForKey:@"G"] floatValue] - [[nDic objectForKey:@"G"] floatValue];
    CGFloat _b = [[sDic objectForKey:@"B"] floatValue] - [[nDic objectForKey:@"B"] floatValue];
    return RGBCOLOR(([[sDic objectForKey:@"R"] floatValue]-scale*_r)*255,
                    ([[sDic objectForKey:@"G"] floatValue]-scale*_g)*255,
                    ([[sDic objectForKey:@"B"] floatValue]-scale*_b)*255);
}

- (UIColor *)selectedColorWith:(CGFloat)scale {
    NSDictionary *nDic = [self getRGBDictionaryByColor:_cateNormalColor];
    NSDictionary *sDic = [self getRGBDictionaryByColor:_cateSelectedColor];
    CGFloat _r = [[sDic objectForKey:@"R"] floatValue] - [[nDic objectForKey:@"R"] floatValue];
    CGFloat _g = [[sDic objectForKey:@"G"] floatValue] - [[nDic objectForKey:@"G"] floatValue];
    CGFloat _b = [[sDic objectForKey:@"B"] floatValue] - [[nDic objectForKey:@"B"] floatValue];

    return RGBCOLOR(([[nDic objectForKey:@"R"] floatValue]+scale*_r)*255,
                    ([[nDic objectForKey:@"G"] floatValue]+scale*_g)*255,
                    ([[nDic objectForKey:@"B"] floatValue]+scale*_b)*255);
}

- (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @{@"R":@(r),@"G":@(g),@"B":@(b),@"A":@(a)};
}

- (BJCategoryLabel *)labelIndex:(NSInteger)index {
    
    return (BJCategoryLabel*)[_containerView viewWithTag:index];
}

-(void)setCateTagColor:(UIColor *)cateTagColor {
    _cateTagColor = cateTagColor;
    _bottomtTag.backgroundColor = _cateTagColor;
}

- (id)initWith:(NSArray *)categorys colors:(NSArray *)colors {
    
    return [self initWith:categorys select:0 colors:colors];
}

- (id)initWith:(NSArray *)categorys select:(NSInteger)index colors:colors {
    
    self = [self initWithFrame:CGRectMake(0, 64, BJScreenWidth, kCateGoryViewHeight)];
    self.contentSize = self.bounds.size;
    if (self) {
        
        _cateTagColor = [colors objectAtIndex:0];
        _cateNormalColor = [colors objectAtIndex:1];
        _cateSelectedColor = [colors objectAtIndex:2];
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.tag = 99;
        _containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containerView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCateGoryViewHeight-0.5, self.frame.size.width, 0.5)];
        line.tag = 100;
        line.backgroundColor = RGBCOLOR(220, 220, 220);
        [_containerView addSubview:line];
        
        _bottomtTag = [[UIView alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - 2, 60, kBottomTagViewHeight)];
        _bottomtTag.backgroundColor = _cateTagColor;
        _bottomtTag.tag = 101;
        [_containerView addSubview:_bottomtTag];
        
        BJCategoryLabel *leftLabel = nil;
        _containerWidth  = 0;
        if (categorys && categorys.count) {
            for (int i = 0; i < categorys.count; i++) {
                BJCategoryLabel *cateLabel = [[BJCategoryLabel alloc] init];
                cateLabel.text = [categorys objectAtIndex:i];
                cateLabel.userInteractionEnabled = YES;
                cateLabel.tag = i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
                [cateLabel addGestureRecognizer:tap];
                
                CGFloat width = [cateLabel.text boundingRectWithSize:CGSizeMake(BJScreenWidth, 20) options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:
                                 [NSDictionary dictionaryWithObjectsAndKeys:cateLabel.font, NSFontAttributeName, nil] context:nil].size.width;
                _containerWidth += (width + 30);
                
                CGRect rect = CGRectMake( leftLabel ? CGRectGetMaxX(leftLabel.frame):0, 0, width+30, self.frame.size.height);
                cateLabel.frame = rect;
                [_containerView addSubview:cateLabel];
                
                if (i == index) {
                    _selectLabel = cateLabel;
                    cateLabel.textColor = _cateSelectedColor;
                    
                    CGRect rect = _bottomtTag.frame;
                    rect.size.width = width+20;
                    rect.origin.x = cateLabel.center.x - (width+30)/2;
                    _bottomtTag.frame = rect;
                } else {
                    cateLabel.textColor = _cateNormalColor;
                }
                
                leftLabel = cateLabel;
            }
        }
        
        CGRect rect = _containerView.frame;
        CGRect lRect = line.frame;
        if (_containerWidth < self.frame.size.width) {
            
            CGFloat leftSpace = (self.frame.size.width - _containerWidth) / 2.0;
            rect.size.width = BJScreenWidth;
            rect.origin.x = leftSpace;
            lRect.origin.x = -(self.frame.size.width-_containerWidth)/2;
        } else {
            rect.size.width = _containerWidth;
            lRect.size.width = _containerWidth;
        }
        _containerView.frame = rect;
        line.frame = lRect;
    }
    return self;
}

- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    BJCategoryLabel *cateLabel = (BJCategoryLabel *)recognizer.view;
    
    [self setSelect:cateLabel by:YES];
}

- (void)updateContentOffset {
    
    BJCategoryLabel *cateLabel = _selectLabel;
    
    CGPoint point = cateLabel.center;
    
    CGFloat offsetX = 0;
    if (_containerView.frame.size.width > BJScreenWidth && point.x > BJScreenWidth / 2.0) {
        if (point.x < (_containerWidth - BJScreenWidth / 2.0)) {
            offsetX = point.x - BJScreenWidth/2.0;
        } else {
            offsetX = _containerWidth - BJScreenWidth;
        }
    } else {
        offsetX = 0;
    }
    
    
    CGFloat offsetY = self.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self setContentOffset:offset animated:YES];
}

- (void)setSelect:(BJCategoryLabel *)cateLabel by:(BOOL)byself {
    if (cateLabel == _selectLabel) {
        return;
    }
    
    cateLabel.textColor = _cateSelectedColor;
    if (_selectLabel) {
        _selectLabel.textColor = _cateNormalColor;
        if (byself) {
            CGPoint point = CGPointMake(CGRectGetMidX(cateLabel.frame), self.frame.size.height-1);
            _bottomtTag.center = point;
        }
    }
    _selectLabel = cateLabel;
    

    if ([self.categoryDelegate respondsToSelector:@selector(didSelectCategory:)]) {
        [self.categoryDelegate didSelectCategory:cateLabel.tag];
    }
    
    if (byself) {
        [self performSelector:@selector(updateContentOffset) withObject:nil afterDelay:0.15];
    }
}

@end
