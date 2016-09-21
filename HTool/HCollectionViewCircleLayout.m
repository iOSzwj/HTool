//
//  HARCollectionViewCircleLayout.m
//  collectionView
//
//  Created by tarena on 15/6/24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "HCollectionViewCircleLayout.h"

@implementation HCollectionViewCircleLayout

//设置显示的边界发生改变的时候重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//返回所有cell的相关设置
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributeses=[NSMutableArray array];
    //获取cell的数量
    NSInteger itemCount=[self.collectionView numberOfItemsInSection:0];
    //遍历
    for (int i=0; i<itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [attributeses addObject:attributes];
    }
    
    return attributeses;
    
}

//返回cell的相关设置
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //创建atttibutes
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置大小
    attributes.size=CGSizeMake(50, 50);
    //圆的半径
    CGFloat circleRadius=70;
    CGPoint circleCenter=CGPointMake(self.collectionView.bounds.size.width/2, self.collectionView.bounds.size.height/2);
    //计算当前item的角度
    CGFloat angle=M_PI*2/[self.collectionView numberOfItemsInSection:indexPath.section]*indexPath.item;
    //计算当前的位置
    attributes.center=CGPointMake(circleCenter.x+circleRadius*cosf(angle), circleCenter.y+circleRadius*sinf(angle));
    //设置显示优先级
    attributes.zIndex=indexPath.item;
    return attributes;
}

@end
