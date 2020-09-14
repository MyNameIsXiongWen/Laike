//
//  MessageChatImageTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatImageTableViewCell.h"
#import "ChatFileHelper.h"

@implementation MessageChatImageTableViewCell

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
        [self.container addSubview:self.imgView];
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    [super fillWithData:data];
    self.imgView.frame = self.container.bounds;
    self.statusLabel.x += 5;
    [self downloadImage];
}

- (void)downloadImage {
    EMImageMessageBody *imgElem = (EMImageMessageBody *)self.messageData.innerMessage.body;
    UIImage *img = [UIImage imageWithContentsOfFile:imgElem.thumbnailLocalPath];
    if (img) {
        self.imgView.image = img;
    } else {
        img = [UIImage imageWithContentsOfFile:imgElem.localPath];
        if (img) {
            self.imgView.image = img;
        } else {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgElem.thumbnailRemotePath]];
        }
    }
    return;
    //web端多了一个images（他们图片TIMImageElem发不了）
    if ([imgElem isKindOfClass:EMCustomMessageBody.class]) {
        EMCustomMessageBody *customElem = (EMCustomMessageBody *)imgElem;
        NSDictionary *dictionary = customElem.ext;
        if (dictionary) {
            NSString *imgUrl = dictionary[@"data"];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }
        return;
    }
    BOOL isExist = NO;
    NSString *path = [self getImagePathisExist:&isExist];
    if (isExist) {
        [self decodeImage];
        return;
    }
//    if (imgElem.imageList.count > 0) {
//        TIMImage *imImage = imgElem.imageList.lastObject;
//        [imImage getImage:path progress:^(NSInteger curSize, NSInteger totalSize) {
//            
//        } succ:^{
//            [self decodeImage];
//        } fail:^(int code, NSString *msg) {
//            
//        }];
//    }
}

- (void)decodeImage {
    BOOL isExist = NO;
    NSString *path = [self getImagePathisExist:&isExist];
    if (!isExist) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgView.image = [UIImage imageWithContentsOfFile:path];
    });
}

- (NSString *)getImagePathisExist:(BOOL *)isExist {
    EMImageMessageBody *imgElem = (EMImageMessageBody *)self.messageData.innerMessage.body;
    NSString *path = nil;
    BOOL isDir = NO;
    *isExist = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TIMChat_Image_Path isDirectory:&isDir]) {
        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(self.messageData.isSelf) {
        //上传方本地原图是否有效
        path = [NSString stringWithFormat:@"%@%@", TIMChat_Image_Path, imgElem.remotePath];
        if([fileManager fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }
    
    if(!*isExist) {
        //查看本地是否存在
//        if (imgElem.imageList.count == 0) {
//            self.imgView.image = [UIImage imageWithContentsOfFile:imgElem.path];
//        }
//        else {
//            TIMImage *image = imgElem.imageList.lastObject;
//            path = [NSString stringWithFormat:@"%@%@", TIMChat_Image_Path, image.uuid];
//            if([fileManager fileExistsAtPath:path isDirectory:&isDir]){
//                if(!isDir){
//                    *isExist = YES;
//                }
//            }
//        }
    }
    return path;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UICreateView initWithFrame:CGRectZero ImageUrl:@"" Image:UIImage.new ContentMode:UIViewContentModeScaleAspectFill];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
    }
    return _imgView;
}

@end
