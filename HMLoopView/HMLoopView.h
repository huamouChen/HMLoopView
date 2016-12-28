//
//  HMLoopView.h
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMLoopViewDelegate;

@interface HMLoopView : UIView
/// 图片地址数组
@property (strong, nonatomic) NSArray *coverURLs;
/// 标题数组
@property (strong, nonatomic) NSArray *titles;
/// 代理
@property (weak, nonatomic) id<HMLoopViewDelegate>delegate;


/// 构造函数
- (instancetype)initWithCoverURLs:(NSArray *)coverURLs titles:(NSArray *)titles;
@end


@protocol HMLoopViewDelegate <NSObject>
@optional
/// 点击了轮播器哪个图片
- (void)loopView:(HMLoopView *)loopView didSelectedItem:(NSInteger)index;
@end
