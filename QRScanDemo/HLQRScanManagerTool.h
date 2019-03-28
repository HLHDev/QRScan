//
//  QRScanManagerTool.h
//  QRScanDemo
//
//  Created by Lucky on 2018/10/24.
//  Copyright © 2018年 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "HLQRScanView.h"

/**
 ** 扫描完成的回调
 ** @param scanString 扫描出的字符串
 */
typedef void(^HQRScanFinishedBlock)( NSString * _Nullable scanString);

typedef void(^HQRScanFailureBlock)(void);

/**
 ** 监听环境光感的回调
 ** @param brightness 亮度值
 */
typedef void(^HQRMonitorLightBlock)( float brightness);

@interface HLQRScanManagerTool : NSObject

/**
 ** 初始化 扫描工具
 ** @param preview 展示输出流的视图
 ** @param scanView 扫描中心识别区域范围
 */
- (instancetype )initWithQRScanPreview:(UIView *)preview andScanView:(HLQRScanView *)scanView;

/** 扫描出结果后的回调 ，注意循环引用的问题 */
@property (nonatomic, copy) HQRScanFinishedBlock _Nullable scanFinishedBlock;

@property (nonatomic, copy) HQRScanFailureBlock _Nullable scanFailureBlock;

/** 监听环境光感的回调,如果 != nil 表示开启监测环境亮度功能 */
@property (nonatomic, copy) HQRMonitorLightBlock _Nullable monitorLightBlock;

/** 闪光灯的状态,不需要设置，仅供外边判断状态使用 */
@property (nonatomic, assign) BOOL flashOpen;

/** 闪光灯开关 */
- (void)openFlashSwitch:(BOOL)open;

/** 开始扫描 */
- (void)sessionStartRunning;

/** 结束扫描 */
- (void)sessionStopRunning;

- (void)scanFinishedResultSuccessBlock:(HQRScanFinishedBlock)successBlock failureBlock:(HQRScanFailureBlock)failureBlcok;

/** 跳转相册 */ 
- (void)imagePickerWithJumpController:(UIViewController *)controller;

/** 使用 string / 头像 异步生成二维码图像
 ** @param string     二维码图像的字符串
 ** @param avatar     头像图像，默认比例 0.2
 */
- (UIImage *)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar;

/** 使用 string / 头像 异步生成二维码图像
 ** @param string     二维码图像的字符串
 ** @param avatar     头像图像，默认比例 0.2
 ** @param scale      头像占二维码图像的比例
 */
- (UIImage *)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar scale:(CGFloat)scale;

/**
 ** 生成自定义样式二维码
 ** 注意：有些颜色结合生成的二维码识别不了
 ** @param codeString 字符串
 ** @param size 大小
 ** @param backColor 背景色
 ** @param frontColor 前景色
 ** @param centerImage 中心图片
 ** @return image二维码
 */
+ (UIImage *)createQRCodeImageWithString:(nonnull NSString *)codeString andSize:(CGSize)size andBackColor:(nullable UIColor *)backColor andFrontColor:(nullable UIColor *)frontColor andCenterImage:(nullable UIImage *)centerImage;

/**
 ** 自定义二维码图片颜色
 **
 */

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
