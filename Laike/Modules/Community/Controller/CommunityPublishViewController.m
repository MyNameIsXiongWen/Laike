//
//  CommunityPublishViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityPublishViewController.h"
#import "CTMediator+Publish.h"
#import "CTMediator+TZImgPicker.h"
#import "CommunityPublishService.h"
#import "QHWPhotoBrowser.h"
#import "QHWActionSheetView.h"

@interface CommunityPublishViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QHWActionSheetViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IndustryView *industryView;
@property (nonatomic, strong) CommunityPublishService *publishService;

@end

@implementation CommunityPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"海外圈";
    [self.kNavigationView.leftBtn setTitle:@"取消" forState:0];
    [self.kNavigationView.leftBtn setTitleColor:kColorThemea4abb3 forState:0];
    self.kNavigationView.leftBtn.titleLabel.font = kFontTheme16;
    [self.kNavigationView.leftBtn setImage:nil forState:0];
    self.kNavigationView.rightBtn.frame = CGRectMake(kScreenW-80, kStatusBarHeight, 60, 44);
    [self.kNavigationView.rightBtn setTitle:@"发布" forState:0];
    [self.kNavigationView.rightBtn setTitleColor:kColorThemefb4d56 forState:0];
    self.kNavigationView.rightBtn.titleLabel.font = kFontTheme16;
    [self addKeyboardNotification];
    [self.view addSubview:UIView.viewFrame(CGRectMake(15, kTopBarHeight, kScreenW-30, 0.5)).bkgColor(kColorThemeeee)];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.industryView];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.textView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入内容"];
        return;
    }
    if (self.publishService.imageArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择图片"];
        return;
    }
    if (self.publishService.industryId == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择分类"];
        [self clickIndustryView];
        return;
    }
    [self.publishService uploadImageWithContent:self.textView.text Completed:^{
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationPublishSuccess object:nil];
        [CTMediator.sharedInstance CTMediator_viewControllerForPublishViewController];
    }];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.publishService.imageArray.count + 1, kPublishImgCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    return [CTMediator.sharedInstance CTMediator_collectionViewCellWithIndexPath:indexPath
                                                                  CollectionView:collectionView
                                                                       ImageArray:self.publishService.imageArray ResultBlk:^{
        [weakSelf.publishService.imageArray removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.publishService.imageArray.count) {
        WEAKSELF
        [CTMediator.sharedInstance CTMediator_showTZImagePickerWithMaxCount:kPublishImgCount-self.publishService.imageArray.count ResultBlk:^(NSArray<UIImage *> * _Nonnull photos) {
            for (UIImage *img in photos) {
                QHWImageModel *tempModel = QHWImageModel.new;
                tempModel.image = img;
                [weakSelf.publishService.imageArray addObject:tempModel];
            }
            [collectionView reloadData];
        }];
    } else {
        QHWPhotoBrowser *browser = [[QHWPhotoBrowser alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) ImgArray:self.publishService.imageArray.mutableCopy CurrentIndex:indexPath.row];
        [browser show];
    }
}

- (void)clickIndustryView {
    [self.textView endEditing:YES];
    QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*(self.publishService.industryArray.count+1)+7) title:@""];
    sheetView.dataArray = self.publishService.industryArray;
    sheetView.sheetDelegate = self;
    [sheetView show];
}

#pragma mark ------------QHWActionSheetViewDelegate-------------
- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    if (index == self.publishService.industryArray.count-1) {
        self.publishService.industryId = 102001;
    } else {
        self.publishService.industryId = index+1;
    }
    self.industryView.industryLabel.text = self.publishService.industryArray[index];
    self.industryView.industryLabel.textColor = kColorTheme2a303c;
}

#pragma mark ------------键盘通知-------------
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.industryView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height+kBottomDangerHeight+10);
    }];
}

- (void)keyboardWillBeHiden:(NSNotification *)notification {
     self.industryView.transform = CGAffineTransformIdentity;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.tvFrame(CGRectMake(15, kTopBarHeight+15, kScreenW-30, 250)).tvFont(kFontTheme16).tvPlaceholder(@"在此输入正文");
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = floor((kScreenW-40)/3);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, self.textView.bottom+15, kScreenW, kScreenH-self.textView.bottom-30-50) Layout:flowLayout Object:self];
        [_collectionView registerClass:NSClassFromString(@"PublishImgViewCell") forCellWithReuseIdentifier:@"PublishImgViewCell"];
    }
    return _collectionView;
}

- (IndustryView *)industryView {
    if (!_industryView) {
        _industryView = [[IndustryView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-50, kScreenW, 40)];
        _industryView.userInteractionEnabled = YES;
        [_industryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIndustryView)]];
    }
    return _industryView;
}

- (CommunityPublishService *)publishService {
    if (!_publishService) {
        _publishService = CommunityPublishService.new;
    }
    return _publishService;
}

@end

@implementation IndustryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemefff;
        UILabel *leftLabel = UILabel.labelFrame(CGRectMake(15, 0, 100, 40)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelText(@"发布到");
        [self addSubview:leftLabel];
        self.industryLabel = UILabel.labelFrame(CGRectMake(leftLabel.right, 0, kScreenW-160, 40)).labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentRight).labelText(@"选择分类");
        [self addSubview:self.industryLabel];
        UIImageView *arrowImgView = UIImageView.ivFrame(CGRectMake(kScreenW-22, 13, 7, 14)).ivImage(kImageMake(@"arrow_right"));
        [self addSubview:arrowImgView];
        [self addSubview:UIView.viewFrame(CGRectMake(15, 0, kScreenW-30, 0.5)).bkgColor(kColorThemeeee)];
        [self addSubview:UIView.viewFrame(CGRectMake(15, 39.5, kScreenW-30, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

@end
