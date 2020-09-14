//
//  ChatInputBar.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "ChatInputBar.h"
#import "QHWPermissionManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatRecordView.h"
#import "ChatFileHelper.h"
#import "ChatEmojiUtil.h"

@interface ChatInputBar () <UITextViewDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) ChatRecordView *recordView;
@property (nonatomic, strong) NSDate *recordStartTime;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *recordTimer;

@end

@implementation ChatInputBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;

    _micButton = UIButton.btnInit().btnImage(kImageMake(@"chat_voice")).btnAction(self, @selector(clickVoiceBtn:));
    [self addSubview:_micButton];
    
    _faceButton = UIButton.btnInit().btnImage(kImageMake(@"chat_face")).btnAction(self, @selector(clickFaceBtn:));
    [self addSubview:_faceButton];
    
    _keyboardButton = UIButton.btnInit().btnImage(kImageMake(@"chat_keyboard")).btnAction(self, @selector(clickKeyboardBtn:));
    _keyboardButton.hidden = YES;
    [self addSubview:_keyboardButton];
    
    _moreButton = UIButton.btnInit().btnImage(kImageMake(@"chat_add")).btnAction(self, @selector(clickMoreBtn:));
    [self addSubview:_moreButton];
    
    _recordButton = UIButton.btnInit().btnTitle(@"按住说话").btnTitleColor(kColorTheme2a303c).btnFont(kFontTheme14).btnBkgColor(kColorThemef5f5f5).btnCornerRadius(5);
    [_recordButton addTarget:self action:@selector(recordBtnDown:) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(recordBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(recordBtnCancel:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_recordButton addTarget:self action:@selector(recordBtnExit:) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(recordBtnEnter:) forControlEvents:UIControlEventTouchDragEnter];
    _recordButton.hidden = YES;
    [self addSubview:_recordButton];
    
    _inputTextView = [[ChatResponderTextView alloc] init];
    _inputTextView.backgroundColor = kColorThemef5f5f5;
    _inputTextView.textColor = kColorTheme2a303c;
    _inputTextView.delegate = self;
    [_inputTextView setFont:kFontTheme14];
    [_inputTextView.layer setMasksToBounds:YES];
    [_inputTextView.layer setCornerRadius:5];
    [_inputTextView setReturnKeyType:UIReturnKeySend];
    UILabel *label = UILabel.labelFrame(CGRectMake(0, 0, 200, 20)).labelText(@"  点击输入").labelFont(kFontTheme14).labelTitleColor(kColorFromHexString(@"bfbfbf"));
    [_inputTextView addSubview:label];
    _inputTextView.contentInset = UIEdgeInsetsMake(4, 7, 0, 0);
    [_inputTextView setValue:label forKey:@"_placeholderLabel"];
    [self addSubview:_inputTextView];
}

- (void)defaultLayout {
    CGFloat buttonWidth = 35;
    CGFloat buttonHeight = 35;
    CGFloat buttonOriginY = (60-35)/2.0;
    _micButton.frame = CGRectMake(15, buttonOriginY, buttonWidth, buttonHeight);
    _keyboardButton.frame = _micButton.frame;
    _moreButton.frame = CGRectMake(kScreenW - buttonWidth - 15, buttonOriginY, buttonWidth, buttonHeight);
    _faceButton.frame = CGRectMake(_moreButton.left - buttonWidth, buttonOriginY, buttonWidth, buttonHeight);
    
    CGFloat beginX = _micButton.right + 5;
    CGFloat endX = _faceButton.left - 5;
    _recordButton.frame = CGRectMake(beginX, 10, endX - beginX, 40);
    _inputTextView.frame = _recordButton.frame;
}

- (void)layoutButton:(CGFloat)height {
    CGFloat offset = height - self.height;
    self.height = height;
    
    CGFloat originY = (60-35)/2.0;
    
    _faceButton.y = originY;
    _moreButton.y = originY;
    _micButton.y = originY;
    
    if(_delegate && [_delegate respondsToSelector:@selector(inputBar:didChangeInputHeight:)]){
        [_delegate inputBar:self didChangeInputHeight:offset];
    }
}

- (void)clickVoiceBtn:(UIButton *)sender {
    _recordButton.hidden = NO;
    _inputTextView.hidden = YES;
    _micButton.hidden = YES;
    _keyboardButton.hidden = NO;
    _faceButton.hidden = NO;
    [_inputTextView resignFirstResponder];
    [self layoutButton:60];
    if(_delegate && [_delegate respondsToSelector:@selector(inputBarDidTouchMore:)]){
        [_delegate inputBarDidTouchVoice:self];
    }
    _keyboardButton.frame = _micButton.frame;
}

- (void)clickKeyboardBtn:(UIButton *)sender {
    _micButton.hidden = NO;
    _keyboardButton.hidden = YES;
    _recordButton.hidden = YES;
    _inputTextView.hidden = NO;
    _faceButton.hidden = NO;
    [self layoutButton:_inputTextView.height + 2 * 10];
    if(_delegate && [_delegate respondsToSelector:@selector(inputBarDidTouchKeyboard:)]){
        [_delegate inputBarDidTouchKeyboard:self];
    }
}

- (void)clickFaceBtn:(UIButton *)sender {
    _micButton.hidden = NO;
    _faceButton.hidden = YES;
    _keyboardButton.hidden = NO;
    _recordButton.hidden = YES;
    _inputTextView.hidden = NO;
    if(_delegate && [_delegate respondsToSelector:@selector(inputBarDidTouchFace:)]){
        [_delegate inputBarDidTouchFace:self];
    }
    _keyboardButton.frame = _faceButton.frame;
}

- (void)clickMoreBtn:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(inputBarDidTouchMore:)]){
        [_delegate inputBarDidTouchMore:self];
    }
}

- (void)recordBtnDown:(UIButton *)sender {
    [QHWPermissionManager openRecordService:^(BOOL isOpen) {
        if (!isOpen) {
            return;
        }
        if(!self.recordView){
            self.recordView = [[ChatRecordView alloc] init];
            self.recordView.frame = [UIScreen mainScreen].bounds;
        }
        [self.window addSubview:self.recordView];
        self.recordStartTime = [NSDate date];
        [self.recordView setStatus:Record_Status_Recording];
        self.recordButton.backgroundColor = [UIColor lightGrayColor];
        [self.recordButton setTitle:@"松开结束" forState:UIControlStateNormal];
        [self startRecord];
    }];
}

- (void)recordBtnUp:(UIButton *)sender {
    _recordButton.backgroundColor = kColorThemef5f5f5;
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordStartTime];
    if(interval < 1 || interval > 60){
        if(interval < 1){
            [_recordView setStatus:Record_Status_TooShort];
        } else{
            [_recordView setStatus:Record_Status_TooLong];
        }
        [self cancelRecord];
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.recordView removeFromSuperview];
        });
    } else{
        [_recordView removeFromSuperview];
        NSString *path = [self stopRecord];
        if (path) {
            if(_delegate && [_delegate respondsToSelector:@selector(inputBar:didSendVoice:)]){
                [_delegate inputBar:self didSendVoice:path];
            }
        }
    }
}

- (void)recordBtnCancel:(UIButton *)sender {
    [_recordView removeFromSuperview];
    _recordButton.backgroundColor = kColorThemef5f5f5;
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self cancelRecord];
}

- (void)recordBtnExit:(UIButton *)sender {
    [_recordView setStatus:Record_Status_Cancel];
    [_recordButton setTitle:@"松开取消" forState:UIControlStateNormal];
}

- (void)recordBtnEnter:(UIButton *)sender {
    [_recordView setStatus:Record_Status_Recording];
    [_recordButton setTitle:@"松开结束" forState:UIControlStateNormal];
}

#pragma mark ------------输入框相关-------------
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.keyboardButton.hidden = YES;
    self.micButton.hidden = NO;
    self.faceButton.hidden = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [_inputTextView sizeThatFits:CGSizeMake(_inputTextView.width, 80)];
    CGFloat oldHeight = _inputTextView.height;
    CGFloat newHeight = size.height;
    
    if (newHeight > 80) {
        newHeight = 80;
    }
    if (newHeight < 40) {
        newHeight = 40;
    }
    if (oldHeight == newHeight){
        return;
    }
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.inputTextView.height += newHeight-oldHeight;
        [weakSelf layoutButton:newHeight+20];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if(_delegate && [_delegate respondsToSelector:@selector(inputBar:didSendText:)]) {
            NSString *sp = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (sp.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"不能发送空白消息"];
            } else {
                [_delegate inputBar:self didSendText:textView.text];
                [self clearInput];
            }
        }
        return NO;
    } else if ([text isEqualToString:@""]) {
        //因为删除的是表情不是文字，所以直接删除一个rangeLength的就可以
////        这里是点击键盘的删除
//        if (textView.text.length > range.location && [textView.text characterAtIndex:range.location] == ']') {
//            NSUInteger location = range.location;
//            NSUInteger length = range.length;
//            while (location != 0) {
//                location --;
//                length ++ ;
//                char c = [textView.text characterAtIndex:location];
//                if (c == '[') {
//                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
//                    return NO;
//                } else if (c == ']') {
//                    return YES;
//                }
//            }
//        } else if (textView.text.length > 0 && (textView.text.length-1 == range.location)) {
////            这里是点击emoji的删除
//            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(textView.text.length-1, 1) withString:@""];
//            return NO;
//        }
    }
    return YES;
}

- (void)clearInput {
    _inputTextView.text = @"";
    [self textViewDidChange:_inputTextView];
}

- (NSString *)getInput {
    return _inputTextView.text;
}

- (void)addEmoji:(NSString *)emoji {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    [attr addAttribute:NSFontAttributeName value:kFontTheme16 range:NSMakeRange(0, self.inputTextView.attributedText.length)];
    if (emoji.length > 0) {
        NSRange range = [self.inputTextView selectedRange];
        ChatEmojiUtil *emojiUtil = ChatEmojiUtil.new;
        [emojiUtil getRichTextAttributeString:emoji Font:kFontTheme16];
        [attr insertAttributedString:emojiUtil.richTextAttribute atIndex:range.location];
        self.inputTextView.attributedText = attr;
    }
    
    if(_inputTextView.contentSize.height > 80){
        float offset = _inputTextView.contentSize.height - _inputTextView.frame.size.height;
        [_inputTextView scrollRectToVisible:CGRectMake(0, offset, _inputTextView.frame.size.width, _inputTextView.frame.size.height) animated:YES];
    }
    [self textViewDidChange:_inputTextView];
//    不知道为什么，选了表情之后字体就变小了？？？
    _inputTextView.font = kFontTheme14;
}

- (void)backDelete {
    NSString *chatText = self.inputTextView.text;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    [attr addAttribute:NSFontAttributeName value:kFontTheme16 range:NSMakeRange(0, self.inputTextView.attributedText.length)];
    if (chatText.length > 0) {
        NSInteger length = 1;
        if (chatText.length >= 2) {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            //这里是为了删输入法自带的表情比如😄😡
            if ([ChatEmojiUtil stringContainsEmoji:subStr]) {
                length = 2;
            }
        }
        NSRange range = [self.inputTextView selectedRange];
        if (range.location != 0) {
            [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
        }
        self.inputTextView.attributedText = attr;
    }
    [self textViewDidChange:_inputTextView];
}

#pragma mark ------------语音相关-------------
- (void)startRecord {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:TIMChat_Voice_Path isDirectory:&isDir]) {
        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Voice_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [TIMChat_Voice_Path stringByAppendingString:[ChatFileHelper genVoiceName:nil withExtension:@"wav"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    [_recorder updateMeters];
    
    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recordTick:) userInfo:nil repeats:YES];
}

- (void)recordTick:(NSTimer *)timer {
    [_recorder updateMeters];
    float power = [_recorder averagePowerForChannel:0];
    [_recordView setPower:power];
}

- (NSString *)stopRecord {
    if (_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if ([_recorder isRecording]) {
        [_recorder stop];
    }
    _recordView = nil;
    NSString *wavPath = _recorder.url.path;
    NSString *amrpath = [[wavPath stringByDeletingPathExtension] stringByAppendingString:@".amr"];
    [ChatFileHelper convertWav:wavPath toAmr:amrpath];
    [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
    return amrpath;
}

- (void)cancelRecord {
    if (_recordTimer) {
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if ([_recorder isRecording]) {
        [_recorder stop];
    }
    NSString *path = _recorder.url.path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end


@implementation ChatResponderTextView

- (UIResponder *)nextResponder {
    if(_overrideNextResponder == nil) {
        return [super nextResponder];
    }
    else {
        return _overrideNextResponder;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_overrideNextResponder != nil)
        return NO;
    else
        return [super canPerformAction:action withSender:sender];
}
@end
