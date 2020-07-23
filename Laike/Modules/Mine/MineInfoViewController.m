//
//  MineInfoViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/15.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MineInfoViewController.h"
#import "QHWGeneralTableViewCell.h"
#import "QHWActionSheetView.h"
#import "MineUpdateNameViewController.h"
#import "UserModel.h"
#import "QHWPermissionManager.h"
#import "MineService.h"
#import "QHWSystemService.h"
#import "CTMediator+TZImgPicker.h"

@interface MineInfoViewController () <UITableViewDelegate, UITableViewDataSource, MineInfoTimeViewDelegate, QHWActionSheetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) MineService *service;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"个人信息";
    [self initialData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initialData {
    UserModel *user = UserModel.shareUser;
    self.dataArray = @[@{@"title": @"头像", @"image": user.headPath ?: @"", @"identifier": @"headPath"},
                       @{@"title": @"姓名", @"detailTitle": user.realName ?: @"", @"identifier": @"realName"},
                       @{@"title": @"个性签名", @"detailTitle": user.slogan ?: @"", @"identifier": @"slogan"},
                       @{@"title": @"业务微信", @"detailTitle": user.wechatNo ?: @"", @"identifier": @"wechatNo"},
                       @{@"title": @"性别", @"detailTitle": user.genderStr ?: @"", @"identifier": @"gender"}].mutableCopy;
}

#pragma mark ------------UITableView-------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    cell.detailLabel.font = kFontTheme14;
    cell.detailLabel.textColor = kColorThemea4abb3;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.rightImageView.hidden = dic[@"image"] == nil;
    cell.detailLabel.hidden = dic[@"image"] != nil;
    cell.titleLabel.text = dic[@"title"];
    cell.titleLabel.font = kFontTheme16;
    if (dic[@"image"]) {
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:kFilePath(dic[@"image"])]];
    } else {
        cell.detailLabel.text = [dic[@"detailTitle"] length] == 0 ? @"未设置" : dic[@"detailTitle"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDic = self.dataArray[indexPath.row];
    NSString *identifier = cellDic[@"identifier"];
    if ([identifier isEqualToString:@"headPath"]) {
        [CTMediator.sharedInstance CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:1 ResultBlk:^(NSArray<UIImage *> * _Nonnull photos) {
            if (photos.count > 0) {
                QHWImageModel *model = QHWImageModel.new;
                model.image = photos.firstObject;
                [self uploadImageRequest:@[model].mutableCopy];
            }
        }];
    } else if ([identifier isEqualToString:@"gender"]) {
        NSArray *array = @[@"女士", @"先生"];
        QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*(array.count+1)+7) title:@""];
        sheetView.dataArray = array;
        sheetView.sheetDelegate = self;
        sheetView.identifier = identifier;
        [sheetView show];
    } else {
        MineUpdateNameViewController *updateVC = MineUpdateNameViewController.new;
        updateVC.identifier = identifier;
        updateVC.placeholder = cellDic[@"title"];
        updateVC.content = cellDic[@"detailTitle"];
        WEAKSELF
        updateVC.updateNameBlock = ^(NSString * _Nonnull name) {
            NSMutableDictionary *dic = [weakSelf.dataArray[indexPath.row] mutableCopy];
            dic[@"detailTitle"] = name;
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}

#pragma mark ------------UIImagePickerController Delegate-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    WEAKSELF
    [picker dismissViewControllerAnimated:YES completion:^{
        QHWImageModel *model = QHWImageModel.new;
        model.image = image;
        [weakSelf uploadImageRequest:@[model].mutableCopy];
    }];
}

#pragma mark ------------QHWActionSheetViewDelegate-------------
- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    if ([actionsheetView.identifier isEqualToString:@"gender"]) {
        [self updateUserInfoWithKey:@"gender" Value:@(index == 0 ? 2 : 1)];
    }
}

#pragma mark ------------网络请求-------------
//上传图片
- (void)uploadImageRequest:(NSMutableArray *)imageArray {
    [QHWSystemService.new uploadImageWithArray:imageArray Completed:^(NSMutableArray * _Nonnull pathArray) {
        [self updateUserInfoWithKey:@"headPath" Value:pathArray.firstObject[@"path"]];
    }];
}

//更新信息
- (void)updateUserInfoWithKey:(NSString *)key Value:(id)value {
    NSInteger index = 0;
    for (NSDictionary *dic in self.dataArray) {
        if ([dic[@"identifier"] isEqualToString:key]) {
            index = [self.dataArray indexOfObject:dic];
            break;
        }
    }
    [self.service updateMineInfoRequestWithParam:@{key: value} Complete:^{
        NSMutableDictionary *dic = [self.dataArray[index] mutableCopy];
        UserModel *userModel = UserModel.shareUser;
        switch (index) {
            case 0:
                dic[@"image"] = value;
                userModel.headPath = value;
                break;
                
            case 4:
                userModel.gender = [value integerValue];
                dic[@"detailTitle"] = userModel.genderStr;
                break;
                
            default:
                break;
        }
        [self.dataArray replaceObjectAtIndex:index withObject:dic.copy];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)clickLogoutBtn {
    [UserModel logout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ------------UI-------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 53;
        [_tableView registerClass:QHWGeneralTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    }
    return _tableView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = UIButton.btnFrame(CGRectMake(15, kTopBarHeight + 53*8 + 20, kScreenW-30, 45)).btnTitle(@"退出登录").btnTitleColor(kColorThemefff).btnFont(kFontTheme20).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(8).btnAction(self, @selector(clickLogoutBtn));
    }
    return _logoutBtn;
}

- (MineService *)service {
    if (!_service) {
        _service = MineService.new;
    }
    return _service;
}

@end

@interface MineInfoTimeView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation MineInfoTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.datePicker];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.confirmBtn];
        UIView *line = [UICreateView initWithFrame:CGRectMake(0, 44.5, kScreenW, 0.5) BackgroundColor:kColorThemeeee CornerRadius:0];
        [self addSubview:line];
        self.popType = PopTypeBottom;
        [self addBezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight CornerSize:CGSizeMake(10, 10)];
    }
    return self;
}

- (void)setCurrentDate:(NSString *)currentDate {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateformatter dateFromString:currentDate];
    if (date) {
        [self.datePicker setDate:date];
    }
}

- (void)clickCancelBtn {
    [self dismiss];
    if ([self.timeDelegate respondsToSelector:@selector(mineInfoTimeView_cancel)]) {
        [self.timeDelegate mineInfoTimeView_cancel];
    }
}

- (void)clickConfirmBtn {
    [self dismiss];
    if ([self.timeDelegate respondsToSelector:@selector(mineInfoTimeView_confirm:)]) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateformatter stringFromDate:self.datePicker.date];
        [self.timeDelegate mineInfoTimeView_confirm:date];
    }
}

- (void)dateChange:(UIDatePicker *)picker {
    
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 45, self.width, self.height-45)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = NSDate.date;
        [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh"]];
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UICreateView initWithFrame:CGRectMake(10, 0, 48, 45) Title:@"取消" Image:nil SelectedImage:nil Font:kFontTheme15 TitleColor:kColorTheme9399a5 BackgroundColor:UIColor.whiteColor CornerRadius:0];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UICreateView initWithFrame:CGRectMake(kScreenW-58, 0, 48, 45) Title:@"确定" Image:nil SelectedImage:nil Font:kFontTheme15 TitleColor:kColorTheme21a8ff BackgroundColor:UIColor.whiteColor CornerRadius:0];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
