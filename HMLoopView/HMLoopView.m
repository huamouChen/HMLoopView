//
//  HMLoopView.m
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import "HMLoopView.h"
#import "HMFlowLayout.h"
#import "HMLoopViewCollectionCell.h"
#import "HMWeakTimer.h"

@interface HMLoopView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/// collectionView
@property (strong, nonatomic) UICollectionView *collectionView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 阴影
@property (strong, nonatomic) UIView *shadowView, *container;
/// 分页指示器
@property (strong, nonatomic) UIPageControl *pageControl;
/// 定时器
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HMLoopView

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [_collectionView reloadData];
}

- (void)setCoverURLs:(NSArray *)coverURLs {
    _coverURLs = coverURLs;
    [_collectionView reloadData];
    _pageControl.numberOfPages = coverURLs.count;
}

#pragma mark - 构造函数
- (instancetype)initWithCoverURLs:(NSArray *)coverURLs titles:(NSArray *)titles {
    if (self = [super init]) {
        self.coverURLs = coverURLs;
        self.titles = titles;
        [self setupAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAppearance];
    }
    
    return self;
}

/// 设置外观
- (void)setupAppearance {
    // 1. 创建控件
    /// collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[HMFlowLayout alloc] init]];
    // 注册cell
    [collectionView registerClass:[HMLoopViewCollectionCell class] forCellWithReuseIdentifier:@"HMLoopViewCollectionCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 一进来就设置偏移量
    dispatch_async(dispatch_get_main_queue(), ^{
        // 如果数组为空，直接返回
        if (self.coverURLs.count == 0) {
            return ;
        }
        // 先设置数据源后再偏移
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.coverURLs.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        // 修改title
        self.titleLabel.text = self.titles[self.titles.count % self.titles.count];
        // 修改分页指示器
        self.pageControl.currentPage = self.titles.count % self.titles.count;
        
        // 添加定时器
        [self addTimer];
    });
    
    // 阴影
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubview:shadowView];
    self.shadowView = shadowView;
    // 容器
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];
    [self addSubview:container];
    self.container = container;
    /// 标题
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.font = [UIFont systemFontOfSize:14];
    titlelabel.textColor = kColorF;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [titlelabel sizeToFit];
    [self addSubview:titlelabel];
    self.titleLabel = titlelabel;
    
    /// 分页指示器
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.coverURLs.count;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPageIndicatorTintColor = MCAppearanceColor;
    pageControl.pageIndicatorTintColor = kColorce;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(loopView:didSelectedItem:)]) {
        [self.delegate loopView:self didSelectedItem:(indexPath.item % self.coverURLs.count)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 1.获取偏移量，获得当前是那张图片
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / self.bounds.size.width;
    
    // 修改title
    self.titleLabel.text = self.titles[page % self.titles.count];
    // 修改分页指示器
    self.pageControl.currentPage = page % self.titles.count;
    
    // 滚到第一张了
    if (page == 0) {
        // 默默改变偏移量
        page = self.coverURLs.count;
        self.collectionView.contentOffset = CGPointMake(page * self.bounds.size.width, 0);
    }
    //滚到最后一张了
    else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        page = self.coverURLs.count - 1;
        self.collectionView.contentOffset = CGPointMake(page * self.bounds.size.width, 0);
    }
    // 添加定时器
    [self addTimer];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

#pragma mark - 定时器
/// 添加定时器
- (void)addTimer {
    if (self.timer) {
        return;
    }
    // 解决target强引用
    NSTimer *timer = [HMWeakTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

/// 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/// 定时器回调
- (void)nextImage {
    CGFloat offsetX = self.collectionView.contentOffset.x;
    NSInteger page = offsetX / self.collectionView.bounds.size.width;
    
    [self.collectionView setContentOffset:CGPointMake((page + 1) * self.collectionView.bounds.size.width, 0) animated:YES];
}

#pragma mark - collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 一进来就设置偏移量
    dispatch_async(dispatch_get_main_queue(), ^{
        // 如果数组为空，直接返回
        if (self.coverURLs.count == 0) {
            return ;
        }
        // 先设置数据源后再偏移
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.coverURLs.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        // 修改title
        self.titleLabel.text = self.titles[self.titles.count % self.titles.count];
        // 修改分页指示器
        self.pageControl.currentPage = self.titles.count % self.titles.count;
        
        // 添加定时器
        [self addTimer];
    });

    return (self.coverURLs.count * 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMLoopViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMLoopViewCollectionCell" forIndexPath:indexPath];
    // 取余赋值
    cell.coverURLStr = self.coverURLs[indexPath.item % self.coverURLs.count];
    return cell;
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    // collectinView 的大小和 轮播器一样大
    self.collectionView.frame = self.bounds;
    
    // title高度30
    self.shadowView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30, self.bounds.size.width, 30);
    self.container.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30, self.bounds.size.width, 30);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30, self.bounds.size.width, 30);
    
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 41, self.bounds.size.width, 7);
}
@end
