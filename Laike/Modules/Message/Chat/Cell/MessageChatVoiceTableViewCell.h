//
//  MessageChatVoiceTableViewCell.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageChatVoiceTableViewCell : MessageChatTableViewCell

/**
 *  开始语音播放。
 *  开始当前气泡中的语音播放
 *  1-1、播放语音前会检查是否正在播放。若正在播放则不执行本次播放操作。
 *  1-2、当前为在播放时，则检查待播放音频是否存放在本地，若本地存在，则直接通过 path 获取音频并开始播放。
 *  2、当前音频不存在时，则通过 IM SDK 中 TIMSoundElem 类提供的 getSound 接口进行在线获取。
 *  3、语音消息和文件、图像、视频消息有所不同，获取的语音消息在消息中以 TIMSoundElem 存在，但无需进行二级提取即可使用。
 *  4、在播放时，只需在路径后添加语音文件后缀，生成 URL，即可根据对应 URL通过 iOS 自带的音频播放库播放。音频文件后缀为 “.wav”。
 *  5、下载成功后，会生成语音 path 并存储下来。
 */

@end

NS_ASSUME_NONNULL_END
