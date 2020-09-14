//
//  MessageChatFaceTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatFaceTableViewCell.h"

@interface MessageChatFaceTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation MessageChatFaceTableViewCell

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
//    TIMFaceElem *faceElem = (TIMFaceElem *)[data.innerMessage getElem:0];
//    NSString *faceSrc = [[NSString alloc] initWithData:faceElem.data encoding:NSUTF8StringEncoding];
//    [self.imgView yy_setImageWithURL:[NSURL URLWithString:faceSrc] placeholder:kPlaceHolderImageGoods];
    self.statusLabel.x += 5;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UICreateView initWithFrame:CGRectMake(0, 0, 60, 60) ImageUrl:@"" Image:UIImage.new ContentMode:UIViewContentModeScaleAspectFill];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

@end
