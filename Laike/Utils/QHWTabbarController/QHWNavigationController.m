//
//  QHWNavigationController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "QHWNavigationController.h"

@interface QHWNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation QHWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Do any additional setup after loading the view.
    self.navigationBar.shadowImage = UIImage.new;
    self.navigationBar.barTintColor = UIColor.whiteColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *controllers = @[@"HomeViewController", @"DistributionViewController", @"MessageViewController", @"MineViewController"];
    if (![controllers containsObject:NSStringFromClass(viewController.class)]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self.interactivePopGestureRecognizer setEnabled:YES];
    [super pushViewController:viewController animated:animated];
//    if ([NSStringFromClass(viewController.class) isEqualToString:@"SearchViewController"] || [NSStringFromClass(viewController.class) isEqualToString:@"LoginViewController"]) {
//        viewController.navigationController.navigationBar.hidden = YES;
//        return;
//    }
    
    QHWNavgationView *tempNavigationView = [[QHWNavgationView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTopBarHeight)];
    [tempNavigationView.leftBtn addTarget:viewController action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempNavigationView.rightBtn addTarget:viewController action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempNavigationView.rightAnotherBtn addTarget:viewController action:@selector(rightAnthorNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tempNavigationView.layer.zPosition = 1000;
    viewController.kNavigationView = tempNavigationView;
    [viewController.view addSubview:tempNavigationView];
    viewController.view.backgroundColor = kColorThemefff;
    
}

- (void)navBack {
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
