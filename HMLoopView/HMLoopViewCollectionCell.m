//
//  HMLoopViewCollectionCell.m
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import "HMLoopViewCollectionCell.h"

@interface HMLoopViewCollectionCell ()
/// 图片视图
@property (strong, nonatomic) UIImageView *coverImageView;
@end

@implementation HMLoopViewCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAppearance];
    }
    return self;
}

// 赋值
- (void)setCoverURLStr:(NSString *)coverURLStr {
    _coverURLStr = coverURLStr;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:coverURLStr]];
}

/// 设置外观
- (void)setupAppearance {
    //添加控件
    /// 封面图片
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:coverImageView];
    self.coverImageView = coverImageView;
}

/// 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片撑满
    self.coverImageView.frame = self.bounds;
}
@end
