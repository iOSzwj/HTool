//
//  HARCollectionViewLineLayout.m
//  collectionView
//
//  Created by tarena on 15/6/24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "HCollectionViewLineLayout.h"

#define spacing 150
#define InsetSpacing 50
#define itemWidth 100
#define itemHeight 200

@implementation HCollectionViewLineLayout

//准备工作完成的时候回调
-(void)prepareLayout{
    //设置cell的大小
    self.itemSize=CGSizeMake(itemWidth, itemHeight);
    //设置滚动的方向
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置cell之间的间距
    self.minimumLineSpacing=spacing;
    //设置显示间距
    self.sectionInset=UIEdgeInsetsMake(itemHeight, self.collectionView.frame.size.width/2-itemWidth/2, itemHeight, self.collectionView.frame.size.height/2);
}

//设置显示的边界发生改变的时候重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//scrollview停止滚动的时候回调
//proposedContentOffset停止滚动时的位置
//velocity滚动速度
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    //计算出滚动最后停留的范围
    CGRect lastRect;
    lastRect.origin=proposedContentOffset;
    lastRect.size=self.collectionView.frame.size;
    //取出范围内的所有attributes
    NSArray *attributeses=[self layoutAttributesForElementsInRect:lastRect];
    //计算屏幕的中间的x值
    CGFloat centerX=proposedContentOffset.x+self.collectionView.frame.size.width/2;
    //遍历所有attributes 计算出最小距离
    CGFloat minSpacing=MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in attributeses) {
        minSpacing=MIN(MAXFLOAT, attributes.center.x-centerX);
    }
    return CGPointMake(proposedContentOffset.x+minSpacing, proposedContentOffset.y);
}

//设置cell的相关属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    //获取可视区域的frame
    CGRect visibleRect;
    visibleRect.origin=self.collectionView.contentOffset;
    visibleRect.size=self.collectionView.frame.size;
    //计算屏幕的中间的x值
    CGFloat centerX=visibleRect.origin.x+visibleRect.size.width/2;
    //获取所有的attributes
    NSArray *attributeses=[super layoutAttributesForElementsInRect:rect];
    //遍历所有的attributes
    for (UICollectionViewLayoutAttributes *attributes in attributeses) {
        //获取cell的中心点的x左边
        CGFloat itemCenterX=attributes.center.x;
        //计算cell与屏幕中心点的距离
        CGFloat space=ABS(itemCenterX-centerX);
        if (space<visibleRect.size.width) {
            //计算缩放比例
            CGFloat scale=1+(1-space/150);
            //缩放
            attributes.transform3D=CATransform3DMakeScale(scale, scale, 1);
        }
    }
    return attributeses;
}

@end
