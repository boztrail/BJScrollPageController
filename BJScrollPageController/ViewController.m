//
//  ViewController.m
//  BJScroollPageController
//
//  Created by booj on 15/10/31.
//  Copyright © 2015年 booj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepare {
    [super prepare];
    
    self.cateTagColor = [UIColor redColor];
    self.cateSelectedColor = [UIColor redColor];//RGBCOLOR(0, 0, 0);
    self.reuseSource = YES;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _viewControllers = [NSMutableArray array];
    [_viewControllers addObject:[board instantiateViewControllerWithIdentifier:@"controller1"]];
    [_viewControllers addObject:[board instantiateViewControllerWithIdentifier:@"controller2"]];
    [_viewControllers addObject:[board instantiateViewControllerWithIdentifier:@"controller3"]];
}

- (NSArray *)categoryTexts {
    return @[@"新闻",@"消息中心",@"个人",@"更多",@"生活",@"天气",@"新闻",@"消息中心"];
}

- (NSString *)selectCategory {
    return @"消息中心";
}

- (NSArray *)viewControllers {
    return _viewControllers;
}

-(NSMutableArray *)queueArray {
    return _viewControllers;
}

-(void)didSelect:(UIViewController *)controller atIndex:(NSInteger)index {
    NSLog(@"%@,%@",controller,@(index));
}

@end
