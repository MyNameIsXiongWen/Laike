//
//  ChatInputViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ChatInputViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UserModel.h"
#import "ChatFileHelper.h"
#import "QHWPermissionManager.h"
//#import "ChatCommonWordSettingViewController.h"
//#import "ChatAddWordViewController.h"
#import "ChatMsgService.h"
#import "QHWLabelAlertView.h"
#import "CTMediator+TZImgPicker.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWStudentModel.h"
#import "QHWMigrationModel.h"
#import "QHWTreatmentModel.h"

typedef NS_ENUM(NSUInteger, InputStatus) {
    Input_Status_Input,
    Input_Status_Input_Face,
    Input_Status_Input_More,
    Input_Status_Input_Keyboard,
    Input_Status_Input_Talk,
    Input_Status_Input_CommonWord,
    Input_Status_Input_TopView,
};
@interface ChatInputViewController () <ChatInputBarDelegate, ChatMoreViewDelegate, ChatGifViewDelegate, ChatFaceViewDelegate, ChatInputBarTopViewDelegate, ChatCommonWordViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) InputStatus status;
@property (nonatomic, strong) ChatMsgService *msgService;

@end

@implementation ChatInputViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCommonWordSendMSg object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationAddCommonWord object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self setupVieweakSelf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonWordSendMsgNotification:) name:kNotificationCommonWordSendMSg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommonWordNotification:) name:kNotificationAddCommonWord object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setConversation:(EMConversation *)conversation {
    _conversation = conversation;
    [self setupVieweakSelf];
}

- (void)setupVieweakSelf {
    self.view.backgroundColor = UIColor.whiteColor;
    _status = Input_Status_Input;
    if ([self.conversation.conversationId isEqualToString:UserModel.shareUser.customerData.id]) {
        _inputBar = [[ChatInputBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    } else {
        _topView = [[ChatInputBarTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        _topView.delegate = self;
        [self.view addSubview:_topView];
        _inputBar = [[ChatInputBar alloc] initWithFrame:CGRectMake(0, 40, kScreenW, 60)];
    }
    _inputBar.delegate = self;
    [self.view addSubview:_inputBar];
    self.msgService = ChatMsgService.new;
}

- (void)setMainBusinessModel:(QHWMainBusinessDetailBaseModel *)mainBusinessModel {
    _mainBusinessModel = mainBusinessModel;
    [self sendProductWithMainBusinessModel:mainBusinessModel];
}

#pragma mark ------------Notification-------------
- (void)keyboardWillHide:(NSNotification *)notification {
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:_inputBar.bottom + kBottomDangerHeight];
    }
    if (_status == Input_Status_Input_Face) {
        [self hideFaceAnimation];
    } else if (_status == Input_Status_Input_More) {
        [self hideMoreAnimation];
    } else if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    _status = Input_Status_Input;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (_status == Input_Status_Input_Face) {
        [self hideFaceAnimation];
    } else if (_status == Input_Status_Input_More) {
        [self hideMoreAnimation];
    } else if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    _status = Input_Status_Input_Keyboard;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:keyboardFrame.size.height + _inputBar.bottom];
    }
}

- (void)commonWordSendMsgNotification:(NSNotification *)notification {
//    NSString *msg = (NSString *)notification.object;
//    [self sendMsgWithContent:msg];
//    [self.commonWordView getCommonWordListRequest];
}

- (void)addCommonWordNotification:(NSNotification *)notification {
//    [self.commonWordView getCommonWordListRequest];
}

- (void)hideGifAnimation {
    self.gifView.hidden = NO;
    self.gifView.alpha = 1.0;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.gifView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.gifView.hidden = YES;
        weakSelf.gifView.alpha = 1.0;
        [weakSelf.gifView removeFromSuperview];
    }];
}

- (void)showGifAnimation {
    [self.view addSubview:self.gifView];
    self.gifView.hidden = NO;
    self.gifView.y = kScreenH;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.gifView.y = weakSelf.inputBar.bottom;
    } completion:nil];
}

- (void)hideFaceAnimation {
    self.faceView.hidden = NO;
    self.faceView.alpha = 1.0;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.faceView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.faceView.hidden = YES;
        weakSelf.faceView.alpha = 1.0;
        [weakSelf.faceView removeFromSuperview];
    }];
}

- (void)showFaceAnimation {
    [self.view addSubview:self.faceView];
    self.faceView.hidden = NO;
    self.faceView.y = kScreenH;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.faceView.y = weakSelf.inputBar.bottom;
    } completion:nil];
}

- (void)hideMoreAnimation {
    self.moreView.hidden = NO;
    self.moreView.alpha = 1.0;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.moreView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.moreView.hidden = YES;
        weakSelf.moreView.alpha = 1.0;
        [weakSelf.moreView removeFromSuperview];
    }];
}

- (void)showMoreAnimation {
    [self.view addSubview:self.moreView];
    self.moreView.hidden = NO;
    self.moreView.y = kScreenH;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.moreView.y = weakSelf.inputBar.bottom;
    } completion:nil];
}

- (void)hideCommonWordAnimation {
    self.commonWordView.hidden = NO;
    self.commonWordView.alpha = 1.0;
    self.topView.commonWordBtnSelected = NO;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.commonWordView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.commonWordView.hidden = YES;
        weakSelf.commonWordView.alpha = 1.0;
        [weakSelf.commonWordView removeFromSuperview];
    }];
}

- (void)showCommonWordAnimation {
    [self.view addSubview:self.commonWordView];
    self.commonWordView.hidden = NO;
    self.commonWordView.y = kScreenH;
    self.topView.commonWordBtnSelected = YES;
    WEAKSELF
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.commonWordView.y = weakSelf.inputBar.bottom;
    } completion:nil];
}

#pragma mark ------------ChatInputBarTopViewDelegate-------------
- (void)inputBarTopView_didClickTopView:(ChatInputBarTopView *)topView didSelectTopCell:(NSString *)cellIdentifier {
    if ([cellIdentifier isEqualToString:@"chat_wantPhone"]) {//获取联系方式
        [self authActionRequestComplete:^(NSString *idString, NSString *phone) {
            if (idString.length > 0) {
                NSDictionary *ext = @{@"message_attr_is_authorize": @"1",
                                      @"message_attr_authorize_id": idString ?: @"",
                                      @"message_attr_authorize_phone": phone ?: @""
                };
                EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"[授权...]"];
                [self sendMessageWithElem:body Identifier:@"MessageChatPhoneTableViewCell" ExtraInfo:ext];
            }
        }];
    }
}

- (void)authActionRequestComplete:(void(^)(NSString *idString, NSString *phone))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kIMAuthorizeRequest parameters:@{@"acceptId": self.conversation.conversationId} success:^(id responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        complete(dic[@"id"], dic[@"mobileNumber"]);
    } failure:^(NSError *error) {
        complete(@"", @"");
    }];
}

#pragma mark ------------ChatInputBarDelegate-------------
- (void)inputBarDidTouchVoice:(ChatInputBar *)textView {
    if (_status == Input_Status_Input_Talk) {
        return;
    }
    [_inputBar.inputTextView resignFirstResponder];
    [self hideFaceAnimation];
    [self hideMoreAnimation];
    [self hideCommonWordAnimation];
    _status = Input_Status_Input_Talk;
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.inputBar.bottom + kBottomDangerHeight];
    }
}

- (void)inputBarDidTouchMore:(ChatInputBar *)textView {
    if (_status == Input_Status_Input_More) {
        return;
    }
    if (_status == Input_Status_Input_Face) {
        [self hideFaceAnimation];
    }
    if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    [_inputBar.inputTextView resignFirstResponder];
    [self showMoreAnimation];
    _status = Input_Status_Input_More;
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.moreView.bottom + kBottomDangerHeight];
    }
}

- (void)inputBarDidTouchFace:(ChatInputBar *)textView {
    if (_status == Input_Status_Input_More) {
        [self hideMoreAnimation];
    }
    if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    [_inputBar.inputTextView resignFirstResponder];
    [self showFaceAnimation];
    _status = Input_Status_Input_Face;
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.gifView.bottom + kBottomDangerHeight];
    }
}

- (void)inputBarDidTouchKeyboard:(ChatInputBar *)textView {
    if (_status == Input_Status_Input_More) {
        [self hideMoreAnimation];
    }
    if (_status == Input_Status_Input_Face) {
        [self hideFaceAnimation];
    }
    if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    _status = Input_Status_Input_Keyboard;
    [_inputBar.inputTextView becomeFirstResponder];
}

- (void)inputBar:(ChatInputBar *)textView didChangeInputHeight:(CGFloat)offset {
    if(_status == Input_Status_Input_Face) {
        [self showFaceAnimation];
    } else if (_status == Input_Status_Input_More) {
        [self showMoreAnimation];
    } else if (_status == Input_Status_Input_CommonWord) {
        [self showCommonWordAnimation];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.view.height + offset];
    }
}

- (void)reset {
    if(_status == Input_Status_Input){
        return;
    } else if (_status == Input_Status_Input_More) {
        [self hideMoreAnimation];
    } else if (_status == Input_Status_Input_Face) {
        [self hideFaceAnimation];
    } else if (_status == Input_Status_Input_CommonWord) {
        [self hideCommonWordAnimation];
    }
    _status = Input_Status_Input;
    [_inputBar.inputTextView resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.inputBar.bottom + kBottomDangerHeight];
    }
}

- (void)inputBar:(ChatInputBar *)textView didSendText:(NSString *)text {
    [self sendMsgWithContent:text];
}

- (void)inputBar:(ChatInputBar *)textView didSendVoice:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    int duration = (int)CMTimeGetSeconds(audioAsset.duration);
    int length = (int)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    
    EMVoiceMessageBody *elem = [[EMVoiceMessageBody alloc] initWithLocalPath:path displayName:@"语音"];
    elem.duration = duration;
//    elem.dataSize = length;
    [self sendMessageWithElem:elem Identifier:@"MessageChatVoiceTableViewCell" ExtraInfo:nil];
}

#pragma mark ------------ChatGifViewDelegate-------------
- (void)gifView:(ChatGifView *)gifView didSelectGif:(nonnull LZFaceImgModel *)faceModel {
//    TIMFaceElem *elem = TIMFaceElem.new;
//    elem.data = [faceModel.imageSrc dataUsingEncoding:NSUTF8StringEncoding];
//    [self sendMessageWithElem:elem Identifier:@"MessageChatFaceTableViewCell"];
}

#pragma mark ------------ChatFaceViewDelegate-------------
- (void)faceView:(ChatFaceView *)gifView didSelectFace:(LZFaceImgModel *)faceModel {
    [self.inputBar addEmoji:faceModel.imageName];
}

- (void)faceViewClickSend {
    [self sendMsgWithContent:self.inputBar.inputTextView.text];
    [self.inputBar clearInput];
}

- (void)faceViewClickDelete {
    [self.inputBar backDelete];
}

#pragma mark ------------ChatCommonWordViewDelegate-------------
- (void)commonWordView_didClickAddBtn {
//    ChatAddWordViewController *vc = ChatAddWordViewController.new;
//    WEAKSELF
//    vc.addCommonWordBlock = ^{
//        [weakSelf.commonWordView getCommonWordListRequest];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commonWordView_didClickSettingBtn {
//    ChatCommonWordSettingViewController *vc = ChatCommonWordSettingViewController.new;
//    WEAKSELF
//    vc.editCommonWordBlock = ^{
//        [weakSelf.commonWordView getCommonWordListRequest];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commonWordView_didClickTableViewIndexpath:(ChatCommonWordModel *)model {
//    [self sendMsgWithContent:model.userImCommonLanguageContent];
}

#pragma mark ------------ChatMoreViewDelegate-------------
- (void)moreView:(ChatMoreView *)moreView didSelectMoreCell:(nonnull NSString *)cellIdentifier {
    if ([cellIdentifier isEqualToString:@"chat_scheme"]) {//案例
        
    } else if ([cellIdentifier isEqualToString:@"chat_evaluate"]) {//评价TA
        [self selectEvaluate];
    } else if ([cellIdentifier isEqualToString:@"chat_album"]) {//相册
        [self selectAlbum];
    } else if ([cellIdentifier isEqualToString:@"chat_camera"]) {//拍照
        [self selectCameraPhoto];
    } else if ([cellIdentifier isEqualToString:@"chat_video"]) {//短视频
        [self selectCameraVideo];
    } else if ([cellIdentifier isEqualToString:@"chat_location"]) {//位置
        [self selectLocation];
    }
}

- (void)selectCommonWords {
    if(_status == Input_Status_Input_CommonWord){
        return;
    }
    if(_status == Input_Status_Input_Face){
        [self hideFaceAnimation];
    }
    if(_status == Input_Status_Input_More){
        [self hideMoreAnimation];
    }
    [_inputBar.inputTextView resignFirstResponder];
    [self showCommonWordAnimation];
    _status = Input_Status_Input_CommonWord;
    if (_delegate && [_delegate respondsToSelector:@selector(inputController:didChangeHeight:)]){
        [_delegate inputController:self didChangeHeight:self.commonWordView.bottom + kBottomDangerHeight];
    }
}

- (void)selectEvaluate {
    UIViewController *vc = NSClassFromString(@"ChatEvaluateViewController").new;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectAlbum {
    [CTMediator.sharedInstance CTMediator_showTZImagePickerOnlyPhotoWithMaxCount:9 ResultBlk:^(NSArray<UIImage *> * _Nonnull photos) {
        for (UIImage *image in photos) {
            [self sendImageMessage:image];
        }
    }];
}

- (void)selectCameraPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
//    picker.mediaTypes= @[(NSString *)kUTTypeImage];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [QHWPermissionManager openCaptureDeviceService:^(BOOL isOpen) {
        if (isOpen) {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

- (void)selectCameraVideo {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
//    picker.mediaTypes= @[(NSString *)kUTTypeMovie];
    picker.videoMaximumDuration = 30;
    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [QHWPermissionManager openCaptureDeviceService:^(BOOL isOpen) {
        if (isOpen) {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

- (void)selectLocation {
//    ChatSelectLocationViewController *locationVc = ChatSelectLocationViewController.new;
//    WEAKSELF
//    locationVc.selectLocationBlock = ^(AMapPOI * _Nonnull POIModel, UIImage * _Nonnull image) {
//        TIMLocationElem *locationElem = TIMLocationElem.new;
//        locationElem.longitude = POIModel.location.longitude;
//        locationElem.latitude = POIModel.location.latitude;
//        locationElem.desc = POIModel.address;
//        [weakSelf sendLocationWithLocationElem:locationElem Image:image];
//    };
//    [self.navigationController pushViewController:locationVc animated:YES];
}

#pragma mark ------------UIImagePickerController Delegate-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [self sendImageMessage:photo];
        }
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [self sendVideoMessage:videoUrl];
        }
    }
}

- (void)sendImageMessage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:TIMChat_Image_Path isDirectory:&isDir]) {
        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [TIMChat_Image_Path stringByAppendingString:[ChatFileHelper genImageName:nil]];
    NSString *imageP = [NSString stringWithFormat:@"%p", image];
    path = [path stringByAppendingString:imageP];
    [fileManager createFileAtPath:path contents:data attributes:nil];
    EMImageMessageBody *elem = [[EMImageMessageBody alloc] initWithData:data displayName:[ChatFileHelper genImageName:nil]];
    [self sendMessageWithElem:elem Identifier:@"MessageChatImageTableViewCell" ExtraInfo:nil];
}

- (void)sendVideoMessage:(NSURL *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:TIMChat_Video_Path isDirectory:&isDir]) {
        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Video_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *videoPath = [NSString stringWithFormat:@"%@%@.%@", TIMChat_Video_Path, [ChatFileHelper genVideoName:nil], url.pathExtension];
    NSURL *newUrl = [NSURL fileURLWithPath:videoPath];
    [self compressVideoQuailtyWithInputURL:url outputURL:newUrl completeHandler:^(NSURL *resultUrl) {
        NSData *videoData = [NSData dataWithContentsOfURL:resultUrl];
        [fileManager createFileAtPath:videoPath contents:videoData attributes:nil];
        
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:resultUrl options:opts];
        int duration = (int)urlAsset.duration.value / urlAsset.duration.timescale;
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
        gen.appliesPreferredTrackTransform = YES;
        gen.maximumSize = CGSizeMake(192, 192);
        NSError *error = nil;
        CMTime actualTime;
        CMTime time = CMTimeMakeWithSeconds(0.0, 30);
        CGImageRef imageRef = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *imagePath = [TIMChat_Video_Path stringByAppendingString:[ChatFileHelper genSnapshotName:nil]];
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
        
        UIImage *snapshot = [UIImage imageWithContentsOfFile:imagePath];
        EMVideoMessageBody *videoElem = [[EMVideoMessageBody alloc] initWithLocalPath:videoPath displayName:[ChatFileHelper genVideoName:nil]];
//        videoElem.snapshotPath = imagePath;
//        videoElem.snapshot = TIMSnapshot.new;
//        videoElem.snapshot.width = snapshot.size.width;
//        videoElem.snapshot.height = snapshot.size.height;
//        videoElem.videoPath = videoPath;
//        videoElem.video = TIMVideo.new;
//        videoElem.video.duration = duration;
//        videoElem.video.type = resultUrl.pathExtension;
        [self sendMessageWithElem:videoElem Identifier:@"MessageChatVideoTableViewCell" ExtraInfo:nil];
    }];
}

- (void)compressVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(NSURL *))handler {
    CGFloat inputsize = [self getFileSize:inputURL.path];
    if (inputsize < 28) {
        handler(inputURL);
        return;
    }
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            handler(outputURL);
        }
     }];
}

- (CGFloat)getFileSize:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        // 获取文件的属性
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    } else {
        NSLog(@"没有找到相关文件");
    }
    return filesize;
}

//- (void)sendLocationWithLocationElem:(TIMLocationElem *)locationElem Image:(UIImage *)image {
//    TIMMessage *msg = TIMMessage.new;
//    [msg addElem:locationElem];
//
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = NO;
//    if (![fileManager fileExistsAtPath:TIMChat_Location_Path isDirectory:&isDir]) {
//        BOOL createFire = [fileManager createDirectoryAtPath:TIMChat_Location_Path withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSString *path = [TIMChat_Location_Path stringByAppendingString:[ChatFileHelper genImageName:nil]];
//    [fileManager createFileAtPath:path contents:imageData attributes:nil];
//    TIMImageElem *imageElem = TIMImageElem.new;
//    imageElem.path = path;
//    [msg addElem:imageElem];
//
//    MessageChatMsgCellData *data = MessageChatMsgCellData.new;
//    data.isSelf = YES;
//    data.identifier = UserModel.shareUser.imAccount;
//    data.avatarUrl = [NSURL URLWithString:UserModel.shareUser.imageSrc];
//    data.cellReuseIdentifier = @"MessageChatLocationTableViewCell";
//    data.innerMessage = msg;
//    if(self.delegate && [self.delegate respondsToSelector:@selector(inputController:didSendMessage:)]){
//        [self.delegate inputController:self didSendMessage:data];
//    }
//}

- (void)sendMsgWithContent:(NSString *)content {
    NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.inputBar.inputTextView.attributedText.string];
    [self.inputBar.inputTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                              inRange:NSMakeRange(0, self.inputBar.inputTextView.attributedText.length)
                                              options:NSAttributedStringEnumerationReverse
                                           usingBlock:^(id value, NSRange range, BOOL *stop) {
         if (value) {
             EMTextAttachment* attachment = (EMTextAttachment*)value;
             NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
             [attStr replaceCharactersInRange:range withString:str];
         }
     }];
    
    EMTextMessageBody *elem = [[EMTextMessageBody alloc] initWithText:attStr];
    [self sendMessageWithElem:elem Identifier:@"MessageChatTextTableViewCell" ExtraInfo:nil];
}

- (void)sendProductWithMainBusinessModel:(QHWMainBusinessDetailBaseModel *)model {
    NSString *subContent = @"", *btmInfo = @"", *product = @"";
    switch (model.businessType) {
        case 1:
        {
            QHWHouseModel *houseModel = (QHWHouseModel *)model;
            subContent = kFormat(@"%@-%@㎡ | 首付 %@%%", [NSString formatterWithValue:houseModel.areaMin], [NSString formatterWithValue:houseModel.areaMax], [NSString formatterWithValue:houseModel.firstPaymentRate]);
            btmInfo = kFormat(@"¥ %@万起", [NSString formatterWithMoneyValue:houseModel.totalPrice]);
            product = @"[房产]";
        }
            break;
        case 2:
        {
            QHWStudyModel *studyModel = (QHWStudyModel *)model;
            subContent = kFormat(@"游学主题%@ | 行程天数%@ | 费用价格%@", studyModel.studyThemeList.firstObject[@"name"], kFormat(@"%ld天", (long)studyModel.tripCycle), kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studyModel.serviceFee]));
            btmInfo = kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studyModel.serviceFee]);
            product = @"[游学]";
        }
            break;
        case 3:
        {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)model;
            subContent = kFormat(@"身份类型%@ | 办理周期%@ | 办理费用%@", migrationModel.dentityTypeList.firstObject[@"name"], migrationModel.handleCycle, kFormat(@"¥%@万", [NSString formatterWithMoneyValue:migrationModel.serviceFee]));
            btmInfo = kFormat(@"¥%@万", [NSString formatterWithMoneyValue:migrationModel.serviceFee]);
            product = @"[移民]";
        }
            break;
        case 4:
        {
            QHWStudentModel *studentModel = (QHWStudentModel *)model;
            if (studentModel.groupList.count >= 3) {
                NSDictionary *dic1 = studentModel.groupList[0];
                NSDictionary *dic2 = studentModel.groupList[1];
                NSDictionary *dic3 = studentModel.groupList[2];
                subContent = kFormat(@"%@%@ | %@%@ | %@%@", dic1[@"key"], dic1[@"value"], dic2[@"key"], dic2[@"value"], dic3[@"key"], dic3[@"value"]);
    //            btmInfo = kFormat(@"¥ %@万起", [NSString formatterWithMoneyValue:houseModel.totalPrice]);
                product = @"[留学]";
            }
        }
            break;
        case 102001:
        {
            QHWTreatmentModel *treatmentModel = (QHWTreatmentModel *)model;
            subContent = kFormat(@"目标国家%@ | 价格%@", treatmentModel.countryName, kFormat(@"¥%@万", [NSString formatterWithMoneyValue:treatmentModel.serviceFee]));
            btmInfo = kFormat(@"¥%@万", [NSString formatterWithMoneyValue:treatmentModel.serviceFee]);
            product = @"[医疗]";
        }
            break;
            
        default:
            break;
    }
    NSDictionary *ext = @{@"message_attr_is_subject": @"1",
                          @"message_attr_subject_id": kFormat(@"%ld", (long)model.businessType),
                          @"message_attr_subject_detail_id": model.id ?: @"",
                          @"message_attr_subject_img": model.coverPath ?: @"",
                          @"message_attr_subject_content": model.name ?: @"",
                          @"message_attr_subject_sub_content": subContent,
                          @"message_attr_subject_bottom": btmInfo
    };
    EMTextMessageBody *elem = [[EMTextMessageBody alloc] initWithText:product];
    [self sendMessageWithElem:elem Identifier:@"MessageChatBusinessTableViewCell" ExtraInfo:ext];
}

//发送所有类型消息
- (void)sendMessageWithElem:(EMMessageBody *)elem Identifier:(NSString *)identifier ExtraInfo:(nullable NSDictionary *)info {
    NSMutableDictionary *ext = @{@"nickname_from": UserModel.shareUser.realName ?: @"",
                                 @"avatar_from": UserModel.shareUser.headPath ?: @"",
                                 @"nickname_to": self.receiverNickName ?: @"",
                                 @"avatar_to": self.receiverHeadPath ?: @""}.mutableCopy;
    if (elem.type == EMMessageBodyTypeText) {
        if (info) {
            [ext addEntriesFromDictionary:info];
        }
    }
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:EMClient.sharedClient.currentUsername to:self.conversation.conversationId body:elem ext:ext];
    MessageChatMsgCellData *data = MessageChatMsgCellData.new;
    data.isSelf = YES;
    data.identifier = EMClient.sharedClient.currentUsername;
    data.avatarUrl = [NSURL URLWithString:kFilePath(UserModel.shareUser.headPath)];
    data.cellReuseIdentifier = identifier;
    data.innerMessage = msg;
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputController:didSendMessage:)]) {
        [self.delegate inputController:self didSendMessage:data];
    }
}

#pragma mark ------------UI-------------
- (ChatGifView *)gifView {
    if(!_gifView){
        _gifView = [[ChatGifView alloc] initWithFrame:CGRectMake(0, self.inputBar.bottom, kScreenW, 255)];
        _gifView.delegate = self;
    }
    return _gifView;
}

- (ChatFaceView *)faceView {
    if(!_faceView){
        _faceView = [[ChatFaceView alloc] initWithFrame:CGRectMake(0, self.inputBar.bottom, kScreenW, 255)];
        _faceView.delegate = self;
    }
    return _faceView;
}

- (ChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[ChatMoreView alloc] initWithFrame:CGRectMake(0, self.inputBar.bottom, kScreenW, 243)];
        _moreView.delegate = self;
    }
    return _moreView;
}

- (ChatCommonWordView *)commonWordView {
    if (!_commonWordView) {
        _commonWordView = [[ChatCommonWordView alloc] initWithFrame:CGRectMake(0, self.inputBar.bottom, kScreenW, 225)];
        _commonWordView.delegate = self;
    }
    return _commonWordView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
