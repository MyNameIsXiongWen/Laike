//
//  CRMScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMScrollContentViewController.h"
#import "CRMTableViewCell.h"

@interface CRMScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CRMScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-180-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:CRMTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CRMTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        
    }];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTableViewCell.class)];
    return cell;
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
