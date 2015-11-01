//
//  BJScrollVPageController.m
//  MomoChat
//
//  Created by booj on 15/10/23.
//  Copyright © 2015年 booj.com. All rights reserved.
//

#import "BJScrollPageController.h"
#import "BJCategoryScrollView.h"
#import "BJCategoryLabel.h"

#define kTextBack           LocalizedStringWithKey(@"返回")

@interface BJScrollPageController ()
<BJCateGoryScrollViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) BJCategoryScrollView *categoryView;
@property (nonatomic, strong) UIScrollView *bigscrollView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation BJScrollPageController

- (id)init {
    self = [super init];
    if (self) {
        //提前初始化
        [self prepare];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepare];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavi];
    [self reloadViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)reloadViews {
    if ((!_reuseSource && self.categoryTexts.count && self.viewControllers.count)
        || (_reuseSource && self.categoryTexts.count))
    {
        [self addControllers];
        [self addCategoryScrollView];
        [self addBigScrollView];
        [self addFirstController];
    }
}

- (void)addCategoryScrollView {
    
    if (_categoryView.superview) {
        [_categoryView removeFromSuperview];
    }
    if (self.selectCategory && [self.categoryTexts containsObject:self.selectCategory]) {
        _selectIndex = [self.categoryTexts indexOfObject:self.selectCategory];
        _categoryView = [[BJCategoryScrollView alloc] initWith:self.categoryTexts select:_selectIndex colors:@[_cateTagColor,_cateNormalColor,_cateSelectedColor]];
    } else {
        _selectIndex = 0;
        _categoryView = [[BJCategoryScrollView alloc] initWith:self.categoryTexts colors:@[_cateTagColor,_cateNormalColor,_cateSelectedColor]];
    }
    _categoryView.categoryDelegate = self;
    _categoryView.backgroundColor = _catebgColor;
    
    [self.view addSubview:_categoryView];
}

- (void)addBigScrollView {
    
    _bigscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_categoryView.frame), BJScreenWidth, self.view.frame.size.height - CGRectGetMaxY(_categoryView.frame))];
    _bigscrollView.pagingEnabled = YES;
    _bigscrollView.delegate = self;
    _bigscrollView.showsHorizontalScrollIndicator = NO;
    _bigscrollView.showsVerticalScrollIndicator = NO;
    _bigscrollView.contentSize = CGSizeMake(BJScreenWidth * self.categoryTexts.count, BJScreenHeight - _categoryView.frame.size.height - 64);
    
    [self.view addSubview:_bigscrollView];
    
    for (int i = 0; i < self.categoryTexts.count; i++) {
        UIImageView * bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Appicon"]];
        bgimage.center = CGPointMake(BJScreenWidth * (i + 0.5), _bigscrollView.contentSize.height/2.0);
        [_bigscrollView addSubview:bgimage];
    }
}

- (void)addFirstController {
    
    UIViewController *vc = nil;
    if (_reuseSource) {
        vc = [self queueController:BJQueueTypeMid];
        if (_selectIndex > 0) {
            UIViewController *lvc = [self queueController:BJQueueTypeLeft];
            [self addSubController:lvc index:_selectIndex - 1];
        }
        if (_selectIndex < self.categoryTexts.count) {
            UIViewController *rvc = [self queueController:BJQueueTypeRight];
            [self addSubController:rvc index:_selectIndex + 1];
        }
    } else {
        [self.viewControllers objectAtIndex:_selectIndex];
    }
    [self addSubController:vc index:_selectIndex];
    [_bigscrollView setContentOffset:CGPointMake(vc.view.frame.origin.x, _bigscrollView.contentOffset.y)];
}

- (void)addSubController:(UIViewController *)vc index:(NSInteger)index
{
    if (vc.view.superview) {
        [vc.view removeFromSuperview];
    }
    CGRect rect = _bigscrollView.bounds;
    rect.origin.x = BJScreenWidth * index;
    vc.view.frame = rect;
    [_bigscrollView addSubview:vc.view];
}

- (void)addControllers {

    for (UIViewController *vc in self.viewControllers) {
        [self addChildViewController:vc];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setUpNavi
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeTop;
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (contentOffset.x <= 0 || contentOffset.x > (self.categoryTexts.count-1) * BJScreenWidth) {
        return;
    }
    
    NSInteger index = contentOffset.x / BJScreenWidth;
    if (index < 0) {
        index = 0;
    } else if (index >= self.categoryTexts.count - 1){
        index = self.categoryTexts.count - 2;
    }
    
    BJCategoryLabel *leftLabel = [_categoryView labelIndex:index];
    BJCategoryLabel *rightLabel = [_categoryView labelIndex:index+1];
    
    CGFloat leftWidth = contentOffset.x -(index * BJScreenWidth);
    CGFloat rightWidth = BJScreenWidth - leftWidth;
    if (leftWidth == 0) {
        return;
    }
    
    CGFloat lrWidth = rightLabel.center.x - leftLabel.center.x;
    
    if (index == _selectIndex) {
        [_categoryView updateBottomTag:leftLabel offsetX:lrWidth * leftWidth/ BJScreenWidth];
        [_categoryView updateFontSize:leftLabel rightLabel:rightLabel scale:leftWidth/BJScreenWidth];
    } else {
        [_categoryView updateBottomTag:rightLabel offsetX:- lrWidth * rightWidth/ BJScreenWidth];
        [_categoryView updateFontSize:rightLabel rightLabel:leftLabel scale:-rightWidth/BJScreenWidth];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    NSInteger index = contentOffset.x / BJScreenWidth;
    
    if (index < 0) {
        index = 0;
        [_bigscrollView setContentOffset:CGPointMake(0, _bigscrollView.contentOffset.y)];
        return;
    } else if (index > self.categoryTexts.count - 1){
        [_bigscrollView setContentOffset:CGPointMake(BJScreenWidth * (self.categoryTexts.count - 1), _bigscrollView.contentOffset.y)];
        return;
    }
    
    BJCategoryLabel *leftLabel = [_categoryView labelIndex:index-1];
    BJCategoryLabel *rightLabel = [_categoryView labelIndex:index];
    
    CGFloat leftWidth = contentOffset.x -(index * BJScreenWidth);
    CGFloat rightWidth = BJScreenWidth - leftWidth;
    
    if (index == _selectIndex) {
        if (leftWidth > BJScreenWidth/2.0) {
            [_categoryView setSelect:leftLabel by:NO];
            [_categoryView updateFontSize:rightLabel rightLabel:leftLabel scale:1];
        }
    } else {
        if (rightWidth > BJScreenWidth/2.0) {
            [_categoryView setSelect:rightLabel by:NO];
            [_categoryView updateFontSize:leftLabel rightLabel:rightLabel scale:1];
        }
    }
    [_categoryView updateContentOffset];
}


#pragma -mark 子类复写方法
-(void)prepare {
    _catebgColor = RGBCOLOR(240, 240, 240);
    _cateNormalColor = RGBCOLOR(140, 140, 140);
    _cateSelectedColor = RGBCOLOR(0, 174, 255);
    _cateTagColor = RGBCOLOR(0, 174, 255);
}

-(NSArray *)categoryTexts {
//    return @[@"骑行",@"户外",@"远方"];
    return nil;
}

-(NSString *)selectCategory {
//    return @"户外";
    return nil;
}

-(NSArray *)viewControllers {
//    if (!_viewControllers) {
//         _viewControllers = @[vc,vc,vc];
//    }
//    return _viewControllers;
    return nil;
}

- (NSMutableArray *)queueArray {
    //返回包含3个Controller对象的可变数组
    return nil;
}

//Controller 复用
-(UIViewController *)queueController:(BJQueueType)type {
    
    switch (type) {
        case BJQueueTypeLeft:
            return [[self queueArray] objectAtIndex:0];
            break;
        case BJQueueTypeMid:
            return [[self queueArray] objectAtIndex:1];
            break;
        case BJQueueTypeRight:
            return [[self queueArray] objectAtIndex:2];
            break;
        case BJQueueTypeMoveLeft:
        {
            UIViewController *vc = [[self queueArray] firstObject];
            [[self queueArray] removeObjectAtIndex:0];
            [[self queueArray] addObject:vc];
            return [[self queueArray] objectAtIndex:1];
        }
            break;
        case BJQueueTypeMoveRight:
        {
            UIViewController *vc = [[self queueArray] lastObject];
            [[self queueArray] removeLastObject];
            [[self queueArray] insertObject:vc atIndex:0];
            return [[self queueArray] objectAtIndex:1];
        }
            break;
        default:
            break;
    }
    return nil;
}



#pragma -mark BJCateGoryScrollViewDelegate
-(void)didSelectCategory:(NSInteger)index {
    
    if (index == _selectIndex ) {
        return;
    }
    
    if (_reuseSource) {
        if (_selectIndex == index - 1 ) {
            [self queueController:BJQueueTypeMoveLeft];
            if (index < self.categoryTexts.count - 1) {
                [self addSubController:[self queueController:BJQueueTypeRight] index:index + 1];
                self.selectVC = [self queueController:BJQueueTypeMid];
            }
        } else if (_selectIndex == index + 1) {
            [self queueController:BJQueueTypeMoveRight];
            if (index > 0) {
                [self addSubController:[self queueController:BJQueueTypeLeft] index:index - 1];
                self.selectVC = [self queueController:BJQueueTypeMid];
            }
        } else if (_selectIndex < index) {
            if (index == self.categoryTexts.count-1) {
                [self queueController:BJQueueTypeMoveLeft];
                [self addSubController:[self queueController:BJQueueTypeRight] index:index];
                [self addSubController:[self queueController:BJQueueTypeMid] index:index - 1];
                self.selectVC = [self queueController:BJQueueTypeRight];
            } else {
                [self queueController:BJQueueTypeMoveLeft];
                [self queueController:BJQueueTypeMoveLeft];
                [self addSubController:[self queueController:BJQueueTypeRight] index:index + 1];
                [self addSubController:[self queueController:BJQueueTypeMid] index:index];
                [self addSubController:[self queueController:BJQueueTypeLeft] index:index - 1];
                self.selectVC = [self queueController:BJQueueTypeMid];
            }
        } else if (_selectIndex > index) {
            if (index == 0) {
                [self queueController:BJQueueTypeMoveRight];
                [self addSubController:[self queueController:BJQueueTypeLeft] index:0];
                [self addSubController:[self queueController:BJQueueTypeMid] index:index + 1];
                self.selectVC = [self queueController:BJQueueTypeLeft];
            } else {
                [self queueController:BJQueueTypeMoveRight];
                [self queueController:BJQueueTypeMoveRight];
                [self addSubController:[self queueController:BJQueueTypeLeft] index:index - 1];
                [self addSubController:[self queueController:BJQueueTypeMid] index:index];
                [self addSubController:[self queueController:BJQueueTypeRight] index:index + 1];
                self.selectVC = [self queueController:BJQueueTypeMid];
            }
        }
        [_bigscrollView setContentOffset:CGPointMake(BJScreenWidth * index, _bigscrollView.contentOffset.y)];
        _selectIndex = index;
        [self didSelect:_selectVC atIndex:_selectIndex];
        return;
    }
    
    _selectIndex = index;
    
    UIViewController * vc = [self.viewControllers objectAtIndex:_selectIndex];
    
    if (vc.view.superview) {
        [_bigscrollView setContentOffset:CGPointMake(_selectIndex * BJScreenWidth, _bigscrollView.contentOffset.y)];
        [self didSelect:vc atIndex:_selectIndex];
        return;
    }
    CGRect rect = _bigscrollView.bounds;
    rect.origin.x = BJScreenWidth * _selectIndex;
    vc.view.frame = rect;
    [_bigscrollView addSubview:vc.view];
    [_bigscrollView setContentOffset:CGPointMake(_selectIndex * BJScreenWidth, _bigscrollView.contentOffset.y)];
    _selectVC = vc;
    [self didSelect:vc atIndex:_selectIndex];
}

- (void)didSelect:(UIViewController *)controller atIndex:(NSInteger)index {
    //
}

@end
