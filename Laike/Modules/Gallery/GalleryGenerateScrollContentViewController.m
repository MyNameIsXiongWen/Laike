//
//  GalleryGenerateScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryGenerateScrollContentViewController.h"
#import "CTMediator+TZImgPicker.h"
#import "QHWShareView.h"

@interface GalleryGenerateScrollContentViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation GalleryGenerateScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
}

- (void)clickAddBtn {
    [CTMediator.sharedInstance CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:1 ResultBlk:^(NSArray<UIImage *> * _Nonnull photos) {
        for (UIView *vvv in self.scrollView.subviews) {
            if (![vvv isKindOfClass:UIImageView.class]) {
                vvv.hidden = YES;
            }
        }
        UIImage *img = photos.firstObject;
        CGFloat height = img.size.height * self.imgView.width / img.size.width;
        self.scrollView.height = MIN(kScreenH-kTopBarHeight-48-30, height);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, height);
        self.imgView.height = height;
        self.imgView.image = img;
        QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"coverImg":img, @"shareType": @(ShareTypeGallery)}];
        [shareView show];
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 10, kScreenW-40, (kScreenH-kTopBarHeight-48) * 2 / 3)];
        _scrollView.userInteractionEnabled = YES;
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddBtn)]];
        
        UIView *line1 = UIView.viewFrame(CGRectMake(_scrollView.width/4.0, _scrollView.height/2.0, _scrollView.width/2.0, 1)).bkgColor(kColorThemea4abb3);
        UIView *line2 = UIView.viewFrame(CGRectMake(_scrollView.width/2.0, _scrollView.height/4.0, 1, _scrollView.height/2.0)).bkgColor(kColorThemea4abb3);
        UILabel *label = UILabel.labelFrame(CGRectMake(0, line2.bottom+10, _scrollView.width, 20)).labelText(@"添加图片，生成专属海报").labelFont(kFontTheme16).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        self.imgView = UIImageView.ivFrame(_scrollView.bounds);
        [_scrollView addSubview:line1];
        [_scrollView addSubview:line2];
        [_scrollView addSubview:label];
        [_scrollView addSubview:self.imgView];
    }
    return _scrollView;
}

@end
