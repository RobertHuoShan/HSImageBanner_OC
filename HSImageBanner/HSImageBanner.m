//  HSImageBanner.m
//  HSImageBanner
//
//  Created by 袁灿 on 16/10/25.
//  Copyright © 2016年 yuancan. All rights reserved.
//

#define IMAGEBANNER_WIDTH   _scrollView.bounds.size.width
#define IMAGEBANNER_HEIGHT  _scrollView.bounds.size.height


#import "HSImageBanner.h"
#import "UIImageView+WebCache.h"

@interface HSImageBanner ()<UIScrollViewDelegate>
{
    NSInteger index1,index2,index3;
    
    NSArray        *arrTitles;
    NSMutableArray *imageUrls;
}

@property (nonatomic, strong) UIImageView *imageView1; //左
@property (nonatomic, strong) UIImageView *imageView2; //中
@property (nonatomic, strong) UIImageView *imageView3; //右

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;




@end

@implementation HSImageBanner

+ (HSImageBanner *)initHSImageBannerWithFrame:(CGRect)frame images:(NSArray *)images titles:(NSArray *)titles placehoderImage:(UIImage *)image
{
    if (images.count == 0) return nil; //没有图片时，直接return
    HSImageBanner *imageBanner = [[HSImageBanner alloc] initWithFrame:frame];
    [imageBanner setImageBannerImages:images];
    [imageBanner setImageBannerTitle:titles];
    [imageBanner setPlaceHolderImage:image];
    [imageBanner setImageBannerPageControl];
    return imageBanner;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(IMAGEBANNER_WIDTH, 0);
        _scrollView.contentSize = CGSizeMake(IMAGEBANNER_WIDTH*3, IMAGEBANNER_HEIGHT);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEBANNER_WIDTH*0, 0, IMAGEBANNER_WIDTH, IMAGEBANNER_HEIGHT)];
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEBANNER_WIDTH*1, 0, IMAGEBANNER_WIDTH, IMAGEBANNER_HEIGHT)];
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEBANNER_WIDTH*2, 0, IMAGEBANNER_WIDTH, IMAGEBANNER_HEIGHT)];
        
        [_scrollView addSubview:_imageView1];
        [_scrollView addSubview:_imageView2];
        [_scrollView addSubview:_imageView3];
        
        _imageView2.userInteractionEnabled = YES;  //添加图片点击事件
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(setImageBannerAutoMove) userInfo:nil repeats:YES];
        [_imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageBannerClick)]];
    }
    return self;
}

//设置图片轮播的图片
- (void)setImageBannerImages:(NSArray *)images
{
    index1 = images.count-1; //指向最后一张图片
    index2 = 0;              //指向最第一张图片
    index3 = 1;              //指向最第二张图片
    
    //如果只有一张图片，则禁止滑动
    if (images.count == 1) {
        _scrollView.scrollEnabled = NO;
        index3 = 0;
    }
    
    imageUrls = [[NSMutableArray alloc] init];

    for (NSString *string in images) {
        [imageUrls addObject:[NSURL URLWithString:string]];
    }
    
    [_imageView1 sd_setImageWithURL:imageUrls[index1] placeholderImage:_placeHolderImage];
    [_imageView2 sd_setImageWithURL:imageUrls[index2] placeholderImage:_placeHolderImage];
    [_imageView3 sd_setImageWithURL:imageUrls[index3] placeholderImage:_placeHolderImage];
}

//设置图片轮播标题
- (void)setImageBannerTitle:(NSArray *)titles
{
    if (titles.count == 0) return;
    
    arrTitles = [NSArray arrayWithArray:titles];
    
    //灰色遮罩层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)-30, IMAGEBANNER_WIDTH, 30)];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.3;
    [self addSubview:grayView];
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, IMAGEBANNER_WIDTH-imageUrls.count*20, 30)];
    _labTitle.text          = arrTitles[index2];
    _labTitle.textColor     = [UIColor whiteColor];
    _labTitle.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:_labTitle];
}

//设置图片轮播的PageControl
- (void)setImageBannerPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(IMAGEBANNER_WIDTH-imageUrls.count*10,  CGRectGetMaxY(_scrollView.frame)-30, 0, 30)];
    _pageControl.numberOfPages = imageUrls.count;
    _pageControl.backgroundColor = [UIColor redColor];
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}

//设置图片轮播自动滚动
- (void)setImageBannerAutoMove
{
    index1 = index1+1;
    index2 = index2+1;
    index3 = index3+1;
    
    if (index1 == imageUrls.count) {
        index1 = 0;
    }
    if (index2 == imageUrls.count) {
        index2 = 0;
    }
    if (index3 == imageUrls.count) {
        index3 = 0;
    }
    
    [_imageView1 sd_setImageWithURL:imageUrls[index1] placeholderImage:_placeHolderImage];
    [_imageView2 sd_setImageWithURL:imageUrls[index2] placeholderImage:_placeHolderImage];
    [_imageView3 sd_setImageWithURL:imageUrls[index3] placeholderImage:_placeHolderImage];
    
    _labTitle.text           = arrTitles[index2];
    _pageControl.currentPage = index2;
    _scrollView.contentOffset = CGPointMake(IMAGEBANNER_WIDTH, 0);
}

//设置图片轮播点击事件
- (void)setImageBannerClick
{
    if (self.clickImageBanner) {
        self.clickImageBanner(index2);
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == 0) { //左滑
        
        index1 = index1-1;
        index2 = index2-1;
        index3 = index3-1;
        
        if (index1 == -1) {
            index1 = imageUrls.count-1;
        }
        if (index2 == -1) {
            index2 = imageUrls.count-1;
        }
        if (index3 == -1) {
            index3 = imageUrls.count-1;
        }
        
    } else if (_scrollView.contentOffset.x == IMAGEBANNER_WIDTH*2) { //右滑
        
        index1 = index1+1;
        index2 = index2+1;
        index3 = index3+1;
        
        if (index1 == imageUrls.count) {
            index1 = 0;
        }
        if (index2 == imageUrls.count) {
            index2 = 0;
        }
        if (index3 == imageUrls.count) {
            index3 = 0;
        }
    } else return;
    
    [_imageView1 sd_setImageWithURL:imageUrls[index1] placeholderImage:_placeHolderImage];
    [_imageView2 sd_setImageWithURL:imageUrls[index2] placeholderImage:_placeHolderImage];
    [_imageView3 sd_setImageWithURL:imageUrls[index3] placeholderImage:_placeHolderImage];
    
    _labTitle.text           = arrTitles[index2];
    _pageControl.currentPage = index2;
    _scrollView.contentOffset = CGPointMake(IMAGEBANNER_WIDTH, 0);

}


@end
