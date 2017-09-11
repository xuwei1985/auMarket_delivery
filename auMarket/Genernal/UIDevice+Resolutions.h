//
//  UIDevice+Resolutions.h
//  TBClient
//
//  Created by TB.Gao on 12-12-12.
//
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

enum {
	UIDeviceResolution_Unknown			= 0,
    UIDeviceResolution_iPhoneStandard	= 1,    // iPhone 1,3,3GS 标准	(320x480px)
    UIDeviceResolution_iPhoneRetina35	= 2,    // iPhone 4,4S 高清 3.5"	(640x960px)
    UIDeviceResolution_iPhoneRetina4	= 3,    // iPhone 5 高清 4"		(640x1136px)
    UIDeviceResolution_iPadStandard		= 4,    // iPad 1,2 标准		(1024x768px)
    UIDeviceResolution_iPadRetina		= 5,    // iPad 3 高清			(2048x1536px)
    UIDeviceResolution_iPhoneRetina47   = 6,    // iPhone 6 高清 4.7" (750x1334px)
    UIDeviceResolution_iPhoneRetina55   = 7,    // iPhone 6 Plus 高清 5.5" (1242x2208px @3x)
    UIDeviceResolution_iPhoneRetina47_Big   = 8,    // iPhone 6 高清 4.7" 放大模式 (640x1136px)
    UIDeviceResolution_iPhoneRetina55_Big   = 9     // iPhone 6 Plus 高清 5.5" 放大模式 (1125x2001px @3x)
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

- (UIDeviceResolution)resolution;

- (CGSize)resolutionSize;

/**
 *  获取当前设备分辨率宽度
 *
 *  @return 宽度
 */
- (int)currentDeviceResolutionWidth;

/**
 *  获取当前设备分辨率高度
 *
 *  @return 高度
 */
- (int)currentDeviceResolutionHeight;

/*
  如果设备是iPad 标准，对应为UIDeviceResolution_iPhoneStandard，
  如果设备是iPad Retina，对应为UIDeviceResolution_iPhoneRetina35
*/
- (CGSize)resolutionIphoneOnly;

//屏幕是否为retina屏幕
- (BOOL)retinaResolution;

NSString *NSStringFromResolution(UIDeviceResolution resolution);

@end
