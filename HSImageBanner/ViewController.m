//
//  ViewController.m
//  HSImageBanner
//
//  Created by 袁灿 on 16/10/25.
//  Copyright © 2016年 yuancan. All rights reserved.
//

#import "ViewController.h"
#import "HSImageBanner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *arrImage = @[@"http://ofmw9dt1n.bkt.clouddn.com/image_banner_1.jpg",
                          @"http://ofmw9dt1n.bkt.clouddn.com/image_banner_2.jpg",
                          @"http://ofmw9dt1n.bkt.clouddn.com/image_banner_3.jpg",
                          @"http://ofmw9dt1n.bkt.clouddn.com/image_banner_4.jpg",
                          @"http://ofmw9dt1n.bkt.clouddn.com/image_banner_5.jpg",
                          @"http://ofmw9dt1n.bkt.clouddn.com/image_banner_6.jpg"];
    
    NSArray *arrTitles = @[@"第一张图片",@"第二张图片",@"第三张图片",@"第四张图片",@"第五张图片",@"第六张图片"];
    
    HSImageBanner *imageBanner = [HSImageBanner initHSImageBannerWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)
                                                                    images:arrImage
                                                                    titles:arrTitles
                                                           placehoderImage:[UIImage imageNamed:@"avator"]];
    imageBanner.clickImageBanner = ^(NSInteger index) {
         NSLog(@"点击了第%ld图片",index+1);
    };
    
    [self.view addSubview:imageBanner];

}

@end
