//
//  QHWContentTableViewCell.m
//  GoOverSeas
//
//  Created by 熊文 on 2020/5/17.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWContentTableViewCell.h"
#import "QHWImageViewCell.h"
#import "QHWImageModel.h"
#import "QHWCellBottomShareView.h"
#import "UserModel.h"
#import "QHWShareView.h"

#define itemWidth (kScreenW-30-10)/3
@interface QHWContentTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *contentTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *contentSubtitleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;//图片
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentBtn;//评论
@property (nonatomic, strong) UIButton *praiseBtn;//点赞
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) QHWCellBottomShareView *shareView;

@end

@implementation QHWContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headImgView.mas_right);
            make.bottom.equalTo(self.headImgView.mas_bottom);
            make.width.height.mas_equalTo(15);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImgView.mas_right).offset(10);
            make.centerY.equalTo(self.headImgView);
        }];
        [self.contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.headImgView.mas_bottom).offset(10);
        }];
        [self.contentSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.contentTitleLabel.mas_bottom).offset(10);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.contentSubtitleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(kScreenW-30, itemWidth));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        }];
//        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-15);
//            make.centerY.equalTo(self.timeLabel);
//            make.size.mas_equalTo(CGSizeMake(50, 30));
//        }];
//        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.praiseBtn.mas_left).offset(-15);
//            make.centerY.equalTo(self.praiseBtn);
//            make.size.equalTo(self.praiseBtn);
//        }];
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(22);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.shareView.mas_bottom).offset(8);
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)]];
    }
    return self;
}

- (void)longPressGes:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock(self.contentModel.id);
        }
    }
}

- (void)setContentModel:(QHWCommunityContentModel *)contentModel {
    _contentModel = contentModel;
    self.collectionView.hidden = contentModel.filePathList.count == 0;
    
    self.nameLabel.text = UserModel.shareUser.realName;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(UserModel.shareUser.headPath)] placeholderImage:kPlaceHolderImage_Avatar];
    self.contentTitleLabel.text = contentModel.title;
    self.contentSubtitleLabel.text = contentModel.content;
    self.timeLabel.text = contentModel.createTime;
    self.tagImgView.hidden = contentModel.subjectData.subjectType != 1;
    [self.commentBtn setTitle:contentModel.commentStr forState:UIControlStateNormal];
    [self.praiseBtn setTitle:contentModel.likeStr forState:UIControlStateNormal];
    [self.praiseBtn setImage:kImageMake(contentModel.likeStatus == 2 ? @"big_like_white_orange" : @"big_like_white") forState:0];
    
    if (contentModel.fileType == 1 && contentModel.filePathList.count > 0) {
        if (contentModel.coverPath.length > 0) {
            contentModel.filePathList = @[kFilePath(contentModel.coverPath)];
        } else {
            if ([contentModel.filePathList.firstObject isKindOfClass:NSDictionary.class]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    id object = contentModel.filePathList.firstObject;
                    if ([object isKindOfClass:NSDictionary.class]) {
                        contentModel.filePathList = @[UIImage.new];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.collectionView reloadData];
                        });
                        NSDictionary *dic = (NSDictionary *)object;
                        [dic[@"path"] thumbnailImageForVideoWithComplete:^(UIImage *img) {
                            contentModel.videoImg = img;
                            contentModel.filePathList = @[img];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionView reloadData];
                            });
                        }];
                    }
                });
            }
        }
    }
    if (contentModel.filePathList.count == 0) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentSubtitleLabel.mas_bottom).offset(10);
        }];
    } else {
        [self.collectionView reloadData];
    }
}

#pragma mark ------------UICollectionView-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.contentModel.filePathList.count, 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    cell.playImageView.hidden = YES;
    if (indexPath.row < self.contentModel.filePathList.count) {
        id imgObject = self.contentModel.filePathList[indexPath.row];
        if ([imgObject isKindOfClass:NSString.class]) {
            NSString *imgSrc = (NSString *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgSrc] placeholderImage:kPlaceHolderImage_Banner];
            cell.playImageView.hidden = self.contentModel.fileType != 1;
        } else if ([imgObject isKindOfClass:QHWImageModel.class]) {
            QHWImageModel *imgModel = (QHWImageModel *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.imageSrc] placeholderImage:kPlaceHolderImage_Banner];
        } else if ([imgObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *imgDic = (NSDictionary *)imgObject;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(imgDic[@"path"])] placeholderImage:kPlaceHolderImage_Banner];
        } else if ([imgObject isKindOfClass:UIImage.class]) {
            UIImage *img = (UIImage *)imgObject;
            cell.imgView.image = img;
            cell.playImageView.hidden = NO;
        }
        cell.imgView.layer.cornerRadius = 5;
        cell.centerLabel.hidden = YES;
        if (indexPath.row == 2 && self.contentModel.filePathList.count > 3) {
            cell.centerLabel.text = kFormat(@"+%lu", self.contentModel.filePathList.count-3);
            cell.centerLabel.hidden = NO;
        }
    }
    return cell;
}

#pragma mark ------------UI-------------
- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = UIImageView.ivFrame(CGRectMake(15, 10, 40, 40)).ivCornerRadius(20).ivBorderColor(kColorThemeeee);
        [self.contentView addSubview:_headImgView];
    }
    return _headImgView;
}

- (UIImageView *)tagImgView {
    if (!_tagImgView) {
        _tagImgView = UIImageView.ivInit().ivBkgColor(kColorThemefff).ivCornerRadius(7.5).ivImage(kImageMake(@"v_expert"));
        [self addSubview:_tagImgView];
    }
    return _tagImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelFrame(CGRectMake(self.headImgView.right+10, 20, kScreenW-80, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)contentTitleLabel {
    if (!_contentTitleLabel) {
        _contentTitleLabel = UILabel.labelInit().labelFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium]).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_contentTitleLabel];
    }
    return _contentTitleLabel;
}

- (UILabel *)contentSubtitleLabel {
    if (!_contentSubtitleLabel) {
        _contentSubtitleLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
        [self.contentView addSubview:_contentSubtitleLabel];
    }
    return _contentSubtitleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [UICreateView initWithFrame:CGRectZero Layout:layout Object:self];
        [_collectionView registerClass:QHWImageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = NO;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme11).labelTitleColor(kColorTheme9399a5);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = UIButton.btnInit().btnFont(kFontTheme11).btnTitleColor(kColorTheme2a303c).btnImage(kImageMake((@"big_comment_white")));
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        _commentBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_commentBtn];
    }
    return _commentBtn;
}

- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = UIButton.btnInit().btnFont(kFontTheme11).btnTitleColor(kColorTheme2a303c).btnImage(kImageMake((@"big_like_white")));
        _praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        _praiseBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_praiseBtn];
    }
    return _praiseBtn;
}

- (QHWCellBottomShareView *)shareView {
    if (!_shareView) {
        _shareView = [[QHWCellBottomShareView alloc] initWithFrame:CGRectZero];
        WEAKSELF
        _shareView.clickShareBlock = ^{
            QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":weakSelf.contentModel, @"shareType": @(ShareTypeContent)}];
            [shareView show];
        };
        [self.contentView addSubview:_shareView];
    }
    return _shareView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

@end
