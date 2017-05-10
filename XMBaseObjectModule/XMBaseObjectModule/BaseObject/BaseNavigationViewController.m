//
//  BaseNavigationViewController.m
//  Shoneme
//
//  Created by 薛坤龙 on 2017/5/5.
//  Copyright © 2017年 xm. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSMutableArray *blackList;

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - Public
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController
{
    if (!viewController)
    {
        return ;
    }
    [self.blackList addObject:viewController];
}

- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController
{
    for (UIViewController *vc in self.blackList)
    {
        if (vc == viewController)
        {
            [self.blackList removeObject:vc];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;
    
    for (UIViewController *viewController in self.blackList)
    {
        if ([self topViewController] == viewController)
        {
            return NO;
        }
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0)
    {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}

#pragma mark - Lazy load
- (NSMutableArray *)blackList
{
    if (!_blackList)
    {
        _blackList = [NSMutableArray array];
    }
    return _blackList;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
