//
//  HSImageBanner.h
//  HSImageBanner
//
//  Created by 袁灿 on 16/10/25.
//  Copyright © 2016年 yuancan. All rights reserved.
//  图片轮播

#import <UIKit/UIKit.h>

@interface HSImageBanner : UIView

//点击图片的回调方法
@property (strong, nonatomic) void (^clickImageBanner)(NSInteger index);

/**
 *  自定义图片轮播视图
 *
 *  @param frame            广告轮播视图位置及大小
 *  @param images           轮播的图片
 *  @param titles           轮播的标题（如不需要展示标题，传nil）
 *  @param image            无网络图片时的默认图片
 *
 *  @return 广告轮播视图
 */

+ (HSImageBanner *)initHSImageBannerWithFrame:(CGRect)frame
                                       images:(NSArray *)images
                                       titles:(NSArray *)titles
                              placehoderImage:(UIImage *)image;

@end
