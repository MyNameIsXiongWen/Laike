//
//  ChatFaceView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ChatFaceView.h"
#import "QHWImageViewCell.h"

@interface ChatFaceView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *faceArray;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ChatFaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.collectionView];
        UIImageView *imgView = UIImageView.ivFrame(CGRectMake(0, self.collectionView.bottom, 60, 35)).ivBkgColor(kColorThemeeee).ivImage(kImageMake(@"ee_1")).ivMode(UIViewContentModeCenter);
        [self addSubview:imgView];
        [self addSubview:self.sendBtn];
        [self addSubview:self.deleteBtn];
        UIView *line1 = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemef5f5f5);
        [self addSubview:line1];
        UIView *line2 = UIView.viewFrame(CGRectMake(0, self.height-35.5, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [self addSubview:line2];
    }
    return self;
}

- (void)clickSendBtn {
    if ([self.delegate respondsToSelector:@selector(faceViewClickSend)]) {
        [self.delegate faceViewClickSend];
    }
}

- (void)clickDeleteBtn {
    if ([self.delegate respondsToSelector:@selector(faceViewClickDelete)]) {
        [self.delegate faceViewClickDelete];
    }
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.faceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class) forIndexPath:indexPath];
    cell.imgView.backgroundColor = UIColor.clearColor;
    cell.imgView.contentMode = UIViewContentModeCenter;
    LZFaceImgModel *faceImgModel = self.faceArray[indexPath.row];
    cell.imgView.image = kImageMake(faceImgModel.imageSrc);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LZFaceImgModel *faceImgModel = self.faceArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(faceView:didSelectFace:)]) {
        [_delegate faceView:self didSelectFace:faceImgModel];
    }
}

#pragma mark ------------UI-------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat space = floor((kScreenW-40*6-40)/5.0);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        flowLayout.itemSize = CGSizeMake(40, 40);
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, self.height-35) Layout:flowLayout Object:self];
        [_collectionView registerClass:[QHWImageViewCell class] forCellWithReuseIdentifier:NSStringFromClass(QHWImageViewCell.class)];
    }
    return _collectionView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = UIButton.btnFrame(CGRectMake(kScreenW-70, self.height-35, 50, 35)).btnTitle(@"发送").btnBkgColor(kColorThemefb4d56).btnTitleColor(kColorThemefff).btnFont(kFontTheme16).btnCornerRadius(5).btnAction(self, @selector(clickSendBtn));
    }
    return _sendBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = UIButton.btnFrame(CGRectMake(kScreenW-70, self.sendBtn.top-35, 50, 30)).btnImage(kImageMake(@"chat_delete")).btnAction(self, @selector(clickDeleteBtn));
//        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _deleteBtn;
}

- (NSMutableArray *)faceArray {
    if (!_faceArray) {
        _faceArray = NSMutableArray.array;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        WEAKSELF
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            LZFaceImgModel *imgModel = LZFaceImgModel.new;
            imgModel.imageSrc = (NSString *)obj;
            imgModel.imageName = (NSString *)key;
            [weakSelf.faceArray addObject:imgModel];
        }];
    }
    return _faceArray;
}

@end
