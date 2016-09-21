//
//  HARCollectionViewStackLayout.m
//  collectionView
//
//  Created by tarena on 15/6/24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "HCollectionViewStackLayout.h"

@implementation HCollectionViewStackLayout

//设置显示的边界发生改变的时候重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributeses=[NSMutableArray array];
    //获取cell的数量
    NSInteger itemCount=[self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];

        [attributeses addObject:attributes];
    }
    
    return attributeses;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    //创建attributes
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置大小
    attributes.size=CGSizeMake(100, 100);
    //设置位置
    attributes.center=CGPointMake(self.collectionView.bounds.size.width/2, self.collectionView.bounds.size.height/2);
    //创建角度数组
    NSArray *angry=@[@(0),@(-M_PI_4/2),@(M_PI_4/2),@(-M_PI_4),@(-M_PI_4)];
    if (indexPath.item>=5) {
        attributes.hidden=YES;
    }else{
        //设置旋转角度
        attributes.transform=CGAffineTransformMakeRotation([angry[indexPath.item] floatValue]);
        //设置显示优先级
        attributes.zIndex=500-indexPath.item;
    } 
    return attributes;
}

@end
