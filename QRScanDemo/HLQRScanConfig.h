//
//  QRScanConfig.h
//  QRScanDemo
//
//  Created by Lucky on 2018/10/24.
//  Copyright © 2018年 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Photos/PHPhotoLibrary.h>

/**
 扫描器类型
 
 - QRScannerTypeQRCode: 仅支持二维码
 - QRScannerTypeBarCode: 仅支持条码
 - QRScannerTypeBoth: 支持二维码以及条码
 */
typedef NS_ENUM(NSInteger, QRScannerType) {
    QRScannerTypeQRCode,
    QRScannerTypeBarCode,
    QRScannerTypeBoth,
};

@interface HLQRScanConfig : NSObject

+ (NSArray *)QR_metadataObjectTypesWithType:(QRScannerType)scannerType;

/**
 校验是否有相机权限
 
 @param permissionGranted 获取相机权限回调
 */
+ (void)QR_checkCameraAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted;

/**
 校验是否有相册权限
 
 @param permissionGranted 获取相机权限回调
 */
+ (void)QR_checkAlbumAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted;

@end
