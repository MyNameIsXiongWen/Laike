//
//  BaseTabBarViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/9.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "QHWTabBarViewController.h"
#import "QHWNavigationController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "CTMediator+ViewController.h"

@interface QHWTabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong, readwrite) QHWTabBar *centerTabbar;
@property (nonatomic, strong) UITabBarItem *homeTabBarItem;

@end

@implementation QHWTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMsgCountShow:) name:kNotificationNewMsg object:nil];
    self.delegate = self;
    [self setValue:self.centerTabbar forKey:@"tabBar"];
    [self configTabbar];
    [self addChildViewControllers];
}

- (void)newMsgCountShow:(NSNotification *)notification {
    NSInteger msgCount = UserModel.shareUser.unreadMsgCount;
    NSString *countStr;
    if (msgCount > 99) {
        countStr = @"99+";
    } else {
        countStr = [NSString stringWithFormat:@"%ld", (long)msgCount];
    }
    self.centerTabbar.msgCountLabel.text = countStr;
    self.centerTabbar.msgCountLabel.width = MAX(15, [countStr getWidthWithFont:kFontTheme12 constrainedToSize:CGSizeMake(CGFLOAT_MAX, 17)]+6);
    self.centerTabbar.msgCountLabel.hidden = msgCount == 0;
}

- (void)configTabbar {
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.backgroundColor = UIColor.whiteColor;
    self.tabBar.shadowImage = UIImage.new;
    self.tabBar.backgroundImage = UIImage.new;
    self.tabBar.layer.shadowColor = kColorThemea4abb3.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowOpacity = 0.15;
    self.tabBar.layer.shadowRadius = 2;
    self.tabBar.clipsToBounds = NO;
}

-(void)addChildViewControllers {
    NSArray *controllers = @[@"HomeViewController", @"MessageViewController", @"CRMViewController", @"DistributionViewController", @"MineViewController"];
    NSArray *icon = @[@"tabbar_home", @"tabbar_message", @"", @"tabbar_community", @"tabbar_mine"];
    NSArray *titleArray = @[@"首页", @"微聊", @"客户", @"分销", @"我的"];
    for (int i = 0; i < controllers.count; i++) {
        id vc = [NSClassFromString(controllers[i]) new];
        QHWNavigationController *navC = [[QHWNavigationController alloc] initWithRootViewController:vc];
        navC.navigationBar.tintColor = kColorThemea4abb3;
        navC.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",icon[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navC.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",icon[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navC.tabBarItem.title = titleArray[i];
        [navC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorTheme2a303c, NSFontAttributeName: kFontTheme10} forState:UIControlStateSelected];
        
        navC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        
        [self addChildViewController:navC];
    }
//    self.selectedIndex = 4;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    QHWNavigationController *navC = (QHWNavigationController *)viewController;
//    if ([NSStringFromClass(navC.topViewController.class) isEqualToString:@"CRMViewController"]) {
//        if (UserModel.shareUser.bindStatus == 2) {
//            [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
//            return NO;
//        }
//    }
    return YES;
}

- (void)centerTabbarAction:(UIButton *)btn {
    self.selectedIndex = 2;
}

- (QHWTabBar *)centerTabbar {
    if (!_centerTabbar) {
        _centerTabbar = [[QHWTabBar alloc] init];
        [_centerTabbar.centerBtn addTarget:self action:@selector(centerTabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerTabbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
