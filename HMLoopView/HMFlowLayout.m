//
//  HMFlowLayout.m
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import "HMFlowLayout.h"

@implementation HMFlowLayout

- (void)prepareLayout {
    // 设置大小
    self.itemSize = self.collectionView.bounds.size;
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 水平方向滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
}
@end
