//
//  GalleryGenerateScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryGenerateScrollContentViewController.h"
#import "CTMediator+TZImgPicker.h"

@interface GalleryGenerateScrollContentViewController ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation GalleryGenerateScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.addBtn];
}

- (void)clickAddBtn {
    [CTMediator.sharedInstance CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:1 ResultBlk:^(NSArray<UIImage *> * _Nonnull photos) {
        self.imgView.image = photos.firstObject;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = UIButton.btnFrame(CGRectMake(20, 10, kScreenW-40, (kScreenH-kTopBarHeight-48) * 2 / 3)).btnBorderColor(kColorThemea4abb3).btnAction(self, @selector(clickAddBtn));
        UIView *line1 = UIView.viewFrame(CGRectMake(_addBtn.width/4.0, _addBtn.height/2.0, _addBtn.width/2.0, 1)).bkgColor(kColorThemea4abb3);
        UIView *line2 = UIView.viewFrame(CGRectMake(_addBtn.width/2.0, _addBtn.height/4.0, 1, _addBtn.height/2.0)).bkgColor(kColorThemea4abb3);
        UILabel *label = UILabel.labelFrame(CGRectMake(0, line2.bottom+10, _addBtn.width, 20)).labelText(@"添加图片，生成专属海报").labelFont(kFontTheme16).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        self.imgView = UIImageView.ivFrame(_addBtn.bounds);
        [_addBtn addSubview:line1];
        [_addBtn addSubview:line2];
        [_addBtn addSubview:label];
        [_addBtn addSubview:self.imgView];
    }
    return _addBtn;
}

@end
