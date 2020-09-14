//
//  MessageChatVoiceTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatVoiceTableViewCell.h"
#import "ChatFileHelper.h"

@import AVFoundation;
@interface MessageChatVoiceTableViewCell () <AVAudioPlayerDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSString *wavPath;

@end

@implementation MessageChatVoiceTableViewCell

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
        [self.container addSubview:self.durationLabel];
        self.bubbleImgView.hidden = NO;
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    [super fillWithData:data];
    EMVoiceMessageBody *soundElem = (EMVoiceMessageBody *)data.innerMessage.body;
    if (soundElem.duration > 0) {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld\"", (long)soundElem.duration];
    }
    else {
        self.durationLabel.text = @"1\"";
    }
    self.durationLabel.frame = CGRectMake(0, 7.5, self.container.width-42, 20);
    UIImage *voiceImg;
    NSArray *animationImgs;
    if (data.innerMessage.direction == EMMessageDirectionSend) {
        voiceImg = kImageMake(@"sender_voice");
        animationImgs = @[kImageMake(@"sender_voice_play_1"),
                          kImageMake(@"sender_voice_play_2"),
                          kImageMake(@"sender_voice_play_3")];
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        self.durationLabel.x = 0;
        self.imgView.x = self.durationLabel.right+5;
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_self_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 5, 5, 12) resizingMode:UIImageResizingModeStretch];
    }
    else {
        voiceImg = kImageMake(@"receiver_voice");
        animationImgs = @[kImageMake(@"receiver_voice_play_1"),
                          kImageMake(@"receiver_voice_play_2"),
                          kImageMake(@"receiver_voice_play_3")];
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
        self.imgView.x = 15;
        self.durationLabel.x = self.imgView.right + 5;
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 12, 5, 5) resizingMode:UIImageResizingModeStretch];
    }
    self.imgView.image = voiceImg;
    self.imgView.animationImages = animationImgs;
}

- (void)playVoiceMessage {
    if (self.messageData.isPlaying) {
        return;
    }
    self.messageData.isPlaying = YES;
    [self.imgView startAnimating];

    __block EMVoiceMessageBody *imSound = (EMVoiceMessageBody *)self.messageData.innerMessage.body;
//    if (imSound.downloadStatus == EMDownloadStatusSucceed || imSound.downloadStatus == EMDownloadStatusSuccessed) {
//        [self playInternal:imSound.localPath];
//    } else if (imSound.downloadStatus == EMDownloadStatusDownloading) {
//        [SVProgressHUD showInfoWithStatus:@"正在下载语音，稍后点击"];
//    } else if (imSound.downloadStatus == EMDownloadStatusFailed || imSound.downloadStatus == EMDownloadStatusPending) {
//        [SVProgressHUD showInfoWithStatus:@"正在下载语音"];
//        [[EMClient sharedClient].chatManager downloadMessageAttachment:self.messageData.innerMessage progress:nil completion:^(EMMessage *message, EMError *error) {
//            imSound = (EMVoiceMessageBody *)message.body;
//            [self playInternal:imSound.localPath];
//        }];
//    }
//    return;
    
    BOOL isExist = NO;
    NSString *path = [self getVoicePath:&isExist];
    if (isExist) {
        [self playInternal:path];
    } else {
        if(self.messageData.isDownloadingVoice) {
            return;
        }
        //网络下载
        self.messageData.isDownloadingVoice = YES;
        [[EMClient sharedClient].chatManager downloadMessageAttachment:self.messageData.innerMessage progress:nil completion:^(EMMessage *message, EMError *error) {
            self.messageData.isDownloadingVoice = NO;
            if (error) {
                [self stopVoiceMessage];
                return;
            }
            imSound = (EMVoiceMessageBody *)message.body;
            [self playInternal:imSound.localPath];
        }];
    }
}

- (NSString *)getVoicePath:(BOOL *)isExist {
    NSString *path = nil;
    BOOL isDir = false;
    *isExist = NO;
    EMVoiceMessageBody *imSound = (EMVoiceMessageBody *)self.messageData.innerMessage.body;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TIMChat_Voice_Path isDirectory:&isDir]) {
        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Voice_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(self.messageData.isSelf) {
        //上传方本地是否有效
        path = [NSString stringWithFormat:@"%@%@", TIMChat_Voice_Path, imSound.localPath.lastPathComponent];
        if([fileManager fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist) {
        //查看本地是否存在
//        path = [NSString stringWithFormat:@"%@%@.amr", TIMChat_Voice_Path, imSound.uuid];
        path = [NSString stringWithFormat:@"%@%@.amr", TIMChat_Voice_Path, imSound.localPath.lastPathComponent];
        if([fileManager fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }
    return path;
}

- (void)playInternal:(NSString *)path {
    if (!self.messageData.isPlaying)
        return;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    bool result = [self.audioPlayer play];
    if (!result) {
        self.wavPath = [[path stringByDeletingPathExtension] stringByAppendingString:@".wav"];
        [ChatFileHelper convertAmr:path toWav:self.wavPath];
        NSURL *url = [NSURL fileURLWithPath:self.wavPath];
        [self.audioPlayer stop];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
}

- (void)stopVoiceMessage {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.messageData.isPlaying = NO;
    [self.imgView stopAnimating];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag; {
    self.messageData.isPlaying = NO;
    [self.imgView stopAnimating];
    [[NSFileManager defaultManager] removeItemAtPath:self.wavPath error:nil];
}

#pragma mark ------------UI-------------
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 20, 20)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.animationDuration = 1;
    }
    return _imgView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UICreateView initWithFrame:CGRectZero Text:@"" Font:kFontTheme12 TextColor:kColorTheme666 BackgroundColor:UIColor.clearColor];
    }
    return _durationLabel;
}

@end
