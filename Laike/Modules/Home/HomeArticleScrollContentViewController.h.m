//
//  HomeArticleScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "HomeArticleScrollContentViewController.h"
#import "QHWArticleTableViewCell.h"
#import "CommunityService.h"
#import "CTMediator+ViewController.h"

@interface HomeArticleScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CommunityService *communityService;

@end

@implementation HomeArticleScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomBarHeight-kStatusBarHeight-32) Style:UITableViewStylePlain Object:self];
    [self.tableView registerClass:QHWArticleTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWArticleTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.communityService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.communityService getCoummunityDataWithComplete:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.communityService.itemPageModel];
        [self.tableView showNodataView:self.communityService.dataArray.count == 0 offsetY:0 button:nil];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.communityService.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommunityArticleModel *model = self.communityService.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.communityService.dataArray.count) {
        NSString *identifier = kFormat(@"QHWArticleTableViewCell-%ld-%ld", (long)indexPath.section, (long)indexPath.row);
        QHWArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[QHWArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.articleModel = self.communityService.dataArray[indexPath.row];
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWCommunityContentModel *model = self.communityService.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:model.id CommunityType:1];
}

#pragma mark ------------UIScrollView-------------
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"接触屏幕");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"离开屏幕");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    NSLog(@"subScroll======%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeSwipeLeaveTop" object:nil];//到顶通知父视图改变状态
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CommunityService *)communityService {
    if (!_communityService) {
        _communityService = CommunityService.new;
        _communityService.communityType = 1;
        _communityService.businessType = self.businessType;
    }
    return _communityService;
}

@end
