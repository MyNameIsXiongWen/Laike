//
//  QSchoolOrganizerViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolOrganizerViewController.h"
#import "QHWBaseCellProtocol.h"

@interface QSchoolOrganizerViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation QSchoolOrganizerViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationReloadRichText object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadRichTextCellNotification:) name:kNotificationReloadRichText object:nil];
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopBarHeight - kBottomDangerHeight - 40 - 200) Style:UITableViewStylePlain Object:self];
    for (QHWBaseModel *baseModel in self.service.tableViewDataArray) {
        [self.tableView registerClass:NSClassFromString(baseModel.identifier) forCellReuseIdentifier:baseModel.identifier];
    }
    [self.view addSubview:self.tableView];
}

#pragma mark ------------Notification-------------
- (void)reloadRichTextCellNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *identifier = dic[@"identifier"];
    [self.service.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.data isKindOfClass:NSDictionary.class]) {
            NSDictionary *subDic = (NSDictionary *)model.data;
            if ([identifier isEqualToString:subDic[@"identifier"]]) {
                model.height = [dic[@"height"] floatValue];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:idx]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.service.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.service.tableViewDataArray[indexPath.section];
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.service.tableViewDataArray[indexPath.section];
    UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
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
