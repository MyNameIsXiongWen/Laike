//
//  CRMAddCustomerViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMAddCustomerViewController.h"
#import "CRMService.h"
#import "QHWSystemService.h"
#import "CRMTextFieldView.h"

@interface CRMAddCustomerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QHWSystemService *systemService;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation CRMAddCustomerViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"reloadTableViewHeight" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = (self.customerId.length > 0 || self.realName.length > 0) ? @"完善客户" : @"新增客户";
    self.kNavigationView.rightBtn.btnTitle(@"保存").btnFont(kMediumFontTheme16).btnTitleColor(kColorTheme21a8ff);
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadTableViewHeight:) name:@"reloadTableViewHeight" object:nil];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.crmService.crmModel.realName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入客户姓名"];
        return;
    }
    if (self.crmService.crmModel.mobileNumber.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入客户手机号"];
        return;
    }
    if (self.crmService.crmModel.clientSourceCode == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择客户来源"];
        return;
    }
    [self.crmService CRMAddCustomerRequestWithComplete:^{
        
    }];
}

- (void)getMainData {
    [self getFilterDataRequest];
    [self getCountryInfoRequest];
    if (self.customerId.length > 0) {
        [self getCRMInfoRequest];
    }
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        if (self.customerId.length == 0) {
            self.crmService.crmModel.realName = self.realName;
            self.crmService.crmModel.mobileNumber = self.mobilePhone;
        }
        [self.crmService handleCRMDetailInfoData];
        for (QHWBaseModel *model in self.crmService.tableViewDataArray) {
            [self.tableView registerClass:NSClassFromString(model.identifier) forCellReuseIdentifier:model.identifier];
        }
        [self.tableView reloadData];
    });
}

- (void)getFilterDataRequest {
    dispatch_group_enter(self.group);
    [self.crmService getCRMFilterDataRequestWithComplete:^(id  _Nullable responseObject) {
        dispatch_group_leave(self.group);
    }];
}

- (void)getCRMInfoRequest {
    dispatch_group_enter(self.group);
    [self.crmService getCRMDetailInfoRequestWithComplete:^{
        dispatch_group_leave(self.group);
    }];
}

- (void)getCountryInfoRequest {
    dispatch_group_enter(self.group);
    [self.systemService getCountryDataRequestWithComplete:^{
        self.crmService.countryArray = self.systemService.countryArray;
        dispatch_group_leave(self.group);
    }];
}

#pragma mark ------------NSNotification-------------
- (void)reloadTableViewHeight:(NSNotification *)notification {
    NSString *identifier = notification.object;
    [self.crmService.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([identifier isEqualToString:@"country"] && [obj.identifier isEqualToString:@"AddCustomerCountryCell"]) {
            CGFloat height = self.crmService.intentionCountryHeight;
//            if (obj.height != height) {
                obj.height = height;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            }
        }
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crmService.tableViewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.crmService.tableViewDataArray[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.crmService.tableViewDataArray[indexPath.row];
    UITableViewCell <QHWBaseCellProtocol>*cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
        if (self.customerId.length > 0) {
            _crmService.customerId = self.customerId;
        }
    }
    return _crmService;
}

- (QHWSystemService *)systemService {
    if (!_systemService) {
        _systemService = QHWSystemService.new;
    }
    return _systemService;
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

@end

@interface AddCustomerTFViewCell ()

@property (nonatomic, strong) CRMModel *crmModel;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation AddCustomerTFViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)configCellData:(id)data {
    NSDictionary *dic = (NSDictionary *)data;
    self.dataDic = dic;
    self.crmModel = dic[@"data"];
    self.tfView.title = dic[@"title"];
    self.tfView.textField.placeholder = dic[@"placeholder"];
    
    if ([dic[@"disable"] boolValue]) {
        self.tfView.textField.userInteractionEnabled = NO;
    }
    BOOL selection = [dic[@"selection"] boolValue];
    if (selection) {
        self.tfView.textField.userInteractionEnabled = !selection;
        self.tfView.rightLabel.hidden = self.tfView.arrowImgView.hidden = !selection;
    } else {
        if ([dic[@"disable"] boolValue]) {
            self.tfView.textField.userInteractionEnabled = NO;
        } else {
            self.tfView.textField.userInteractionEnabled = YES;
        }
        self.tfView.rightLabel.hidden = self.tfView.arrowImgView.hidden = YES;
    }
    
    if (selection) {
        if (self.crmModel.countryStr) {
    //        self.tfView.rightLabel.text = self.dataArray[index];
            self.tfView.textField.placeholder = @"";
        }
    } else {
        self.tfView.textField.text = [self.crmModel valueForKey:dic[@"identifier"]];
    }
    if ([dic[@"identifier"] isEqualToString:@"mobileNumber"]) {
        self.tfView.textField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        self.tfView.textField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if ([self.dataDic[@"identifier"] isEqualToString:@"mobileNumber"]) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    [self.crmModel setValue:textField.text forKey:self.dataDic[@"identifier"]];
}

- (CRMTextFieldView *)tfView {
    if (!_tfView) {
        _tfView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        _tfView.textField.textColor = kColorTheme21a8ff;
        [_tfView.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        WEAKSELF
        _tfView.clickTFViewBlock = ^{
            
        };
        [self.contentView addSubview:_tfView];
    }
    return _tfView;
}

@end

@interface AddCustomerRemarkCell () <UITextViewDelegate>

@property (nonatomic, strong) CRMModel *crmModel;

@end

@implementation AddCustomerRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.remarkTextView];
    }
    return self;
}

- (void)configCellData:(id)data {
    _crmModel = (CRMModel *)data;
    self.remarkTextView.text = _crmModel.note;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    self.crmModel.note = textView.text;
}

- (UITextView *)remarkTextView {
    if (!_remarkTextView) {
        UILabel *label = UILabel.labelFrame(CGRectMake(20, 10, kScreenW-40, 25)).labelText(@"客户备注").labelFont(kFontTheme16);
        [self.contentView addSubview:label];
        _remarkTextView = UITextView.tvFrame(CGRectMake(20, 40, kScreenW-40, 120)).tvFont(kFontTheme16).tvPlaceholder(@"如果有其他信息需要备注，请在此补充。（100字）");
        _remarkTextView.delegate = self;
        [self.contentView addSubview:UIView.viewFrame(CGRectMake(0, _remarkTextView.bottom+4, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _remarkTextView;
}

@end

@interface AddCustomerGenderCell ()

@property (nonatomic, strong) CRMModel *crmModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;

@end

@implementation AddCustomerGenderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = UILabel.labelFrame(CGRectMake(20, 0, 80, 60)).labelText(@"   性别").labelTitleColor(kColorTheme000).labelFont(kFontTheme16);
        [self addSubview:self.titleLabel];
        
        self.maleBtn = UIButton.btnFrame(CGRectMake(self.titleLabel.right + 10, 10, 60, 40)).btnTitle(@"先生").btnFont(kFontTheme16).btnTitleColor(kColorTheme999).btnAction(self, @selector(clickBtn:));
        self.maleBtn.tag = 1;
        self.maleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.maleBtn setTitleColor:kColorTheme21a8ff forState:UIControlStateSelected];
        [self addSubview:self.maleBtn];
        
        self.femaleBtn = UIButton.btnFrame(CGRectMake(self.maleBtn.right + 10, 10, 60, 40)).btnTitle(@"女士").btnFont(kFontTheme16).btnTitleColor(kColorTheme999).btnAction(self, @selector(clickBtn:));
        self.femaleBtn.tag = 2;
        self.femaleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.femaleBtn setTitleColor:kColorTheme21a8ff forState:UIControlStateSelected];
        [self addSubview:self.femaleBtn];
        
        [self addSubview:UIView.viewFrame(CGRectMake(0, 59.0, self.width, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)configCellData:(id)data {
    _crmModel = (CRMModel *)data;
    self.maleBtn.selected = _crmModel.gender == 1;
    self.femaleBtn.selected = _crmModel.gender == 2;
}

- (void)clickBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.tag == 1) {
        self.femaleBtn.selected = NO;
    } else if (btn.tag == 2) {
        self.maleBtn.selected = NO;
    }
    if (btn.selected) {
        self.crmModel.gender = btn.tag;
    }
}

@end

#import "SearchContentLayout.h"
#import "CRMBtnCollectionViewCell.h"
#import "QHWFilterModel.h"

@interface AddCustomerSelectionCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SearchContentLayout *layout;
@property (nonatomic, strong) NSDictionary *btnDic;
@property (nonatomic, strong) CRMModel *crmModel;

@end

@implementation AddCustomerSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.btnDic = (NSDictionary *)data;
    NSString *title = self.btnDic[@"title"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSForegroundColorAttributeName: UIColor.redColor} range:[title rangeOfString:@"*"]];
    self.titleLabel.attributedText = attr;
    
    self.crmModel = self.btnDic[@"model"];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.btnDic[@"data"];
    return array.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *array = self.btnDic[@"data"];
//    FilterCellModel *model = array[indexPath.row];
//    CGSize labelSize = [model.name getSizeWithFont:kFontTheme14 constrainedToSize:CGSizeMake(1000, 20)];
//    if (labelSize.width < 30) {
//        labelSize.width = 30;
//    }
//    return CGSizeMake(labelSize.width + self.cellWidth, 40);
    return CGSizeMake(floor((kScreenW-70)/3.0), 30);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRMBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CRMBtnCollectionViewCell" forIndexPath:indexPath];
    NSArray *array = self.btnDic[@"data"];
    FilterCellModel *model = array[indexPath.row];
    [cell.titleBtn setTitle:model.name forState:0];
    cell.itemSelected = model.selected;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL unselectable = [self.btnDic[@"unselectable"] boolValue];
    if (unselectable) {
        return;
    }
    BOOL mutable = [self.btnDic[@"mutable"] boolValue];
    NSArray *array = self.btnDic[@"data"];
    FilterCellModel *model = array[indexPath.row];
    if (mutable) {
        model.selected = !model.selected;
        CRMBtnCollectionViewCell *cell = (CRMBtnCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.itemSelected = model.selected;
    } else {
        if (model.selected) {
            return;
        }
        for (FilterCellModel *temp in array) {
            if (temp.selected) {
                CRMBtnCollectionViewCell *cell = (CRMBtnCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[array indexOfObject:temp] inSection:indexPath.section]];
                temp.selected = NO;
                cell.itemSelected = temp.selected;
            }
        }
        model.selected = YES;
        CRMBtnCollectionViewCell *cell = (CRMBtnCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.itemSelected = model.selected;
        if ([self.btnDic[@"identifier"] isEqualToString:@"source"]) {
            self.crmModel.clientSourceCode = model.code.integerValue;
        } else if ([self.btnDic[@"identifier"] isEqualToString:@"intentionLevel"]) {
            self.crmModel.intentionLevelCode = model.code.integerValue;
        } else if ([self.btnDic[@"identifier"] isEqualToString:@"clientLevel"]) {
            self.crmModel.clientLevel = model.code.integerValue;
        }
    }
}

#pragma mark ------------UI-------------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:self.layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"CRMBtnCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CRMBtnCollectionViewCell"];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (SearchContentLayout *)layout {
    if (!_layout) {
        _layout = [[SearchContentLayout alloc] init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _layout.minimumInteritemSpacing = 15;
        _layout.minimumLineSpacing = 15;
        _layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return _layout;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

#import "SelectCountryView.h"
@interface AddCustomerCountryCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SearchContentLayout *layout;
@property (nonatomic, strong) NSDictionary *btnDic;
@property (nonatomic, strong) CRMService *crmService;

@end

@implementation AddCustomerCountryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.mas_equalTo(20);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.right.top.bottom.mas_equalTo(0);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    self.btnDic = (NSDictionary *)data;
    self.crmService = self.btnDic[@"data"];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.crmService.intentionCountryArray.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.crmService.intentionCountryArray.count) {
        FilterCellModel *model = self.crmService.intentionCountryArray[indexPath.row];
        return model.size;
    }
    return CGSizeMake(50, 30);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CountrySubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CountrySubCell.class) forIndexPath:indexPath];
    cell.deleteBtn.hidden = indexPath.row == self.crmService.intentionCountryArray.count;
    if (indexPath.row < self.crmService.intentionCountryArray.count) {
        FilterCellModel *model = self.crmService.intentionCountryArray[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.nameLabel.textColor = kColorTheme21a8ff;
    } else {
        cell.nameLabel.text = @"添加";
        cell.nameLabel.textColor = kColorTheme707070;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.crmService.intentionCountryArray.count) {
        FilterCellModel *cityModel = self.crmService.intentionCountryArray[indexPath.row];
        cityModel.selected = NO;
        [self.crmService.intentionCountryArray removeObjectAtIndex:indexPath.row];
        [NSNotificationCenter.defaultCenter postNotificationName:@"reloadTableViewHeight" object:@"country"];
    } else {
        SelectCountryView *countryView = [[SelectCountryView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, self.crmService.countryArray.count * 40)];
        countryView.dataArray = self.crmService.countryArray;
        WEAKSELF
        countryView.didSelectedBlock = ^(FilterCellModel * _Nonnull cityCellModel) {
            if (cityCellModel.selected) {
                [weakSelf.crmService.intentionCountryArray addObject:cityCellModel];
            } else {
                [weakSelf.crmService.intentionCountryArray removeObject:cityCellModel];
            }
            [NSNotificationCenter.defaultCenter postNotificationName:@"reloadTableViewHeight" object:@"country"];
        };
        [countryView show];
    }
}

#pragma mark ------------UI-------------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000).labelText(@"意向国家");
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:self.layout Object:self];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:CountrySubCell.class forCellWithReuseIdentifier:NSStringFromClass(CountrySubCell.class)];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (SearchContentLayout *)layout {
    if (!_layout) {
        _layout = [[SearchContentLayout alloc] init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _layout.minimumInteritemSpacing = 15;
        _layout.minimumLineSpacing = 15;
        _layout.sectionInset = UIEdgeInsetsMake(15, 0, 15, 15);
    }
    return _layout;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

@implementation CountrySubCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.nameLabel = UILabel.labelInit().labelBorderColor(kColorTheme707070).labelTitleColor(kColorTheme21a8ff).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(8);
        [self.contentView addSubview:self.nameLabel];
        
        self.deleteBtn = UIButton.btnInit().btnImage(kImageMake(@"global_delete")).btnAction(self, @selector(clickDeleteBtn));
        self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.deleteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.deleteBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.deleteBtn];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3);
            make.right.mas_equalTo(-3);
            make.width.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)clickDeleteBtn {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }
}

@end
