//
//  IntervalCRMViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "IntervalCRMViewController.h"
#import "CRMViewController.h"

@interface IntervalCRMViewController ()

@property (nonatomic, strong) CRMViewController *CRMVc;

@end

@implementation IntervalCRMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    self.CRMVc = CRMViewController.new;
    self.CRMVc.interval = YES;
    [self addChildViewController:self.CRMVc];
    [self.view addSubview:self.CRMVc.view];
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
