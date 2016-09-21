
//

#import "HCollectionViewFallLayout.h"

@interface HCollectionViewFallLayout()

@property(nonatomic,strong)NSMutableArray *attArr;

@end

@implementation HCollectionViewFallLayout

// 界面更新了，是否响应
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// 界面将要显示的时候会掉
- (void)prepareLayout{
    [super prepareLayout];
    [self.attArr removeAllObjects];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    for (int i = 0; i < 20; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attArr addObject:att];
    }
}

// 设置滚动区域的大小
- (CGSize)collectionViewContentSize{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat miniW = (screenW - 30)/3.0;
    CGFloat sectionH = miniW * 4 + 10;
    int count = (int)([self layoutAttributesForElementsInRect:[UIScreen mainScreen].bounds].count);
    int sectionCount = count/6;
    int areaCount = count%6;
    CGFloat height = 10 + (sectionH + 10)*sectionCount;
    
    switch (areaCount) {
        case 0:
        case 1:
        case 2:
            height = height + miniW*2 + 10;
            break;
        case 3:
        case 4:
        case 5:
            height = height + sectionH;
            break;
    }
    return CGSizeMake(0, height);
}

// 返回所有cell的小秘书
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attArr;
}

// 返回每个cell的小秘书
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat miniW = (screenW - 30)/3.0;
    CGFloat miniH = (miniW*2 - 10)/3.0;
    CGFloat sectionH = miniW * 4 + 10;
    //6个一个区，得到区
    int sectionNum = (int)(indexPath.row/6);
    //第几个
    int areaNum = indexPath.row%6;
    //取得区的高度
    CGFloat startY = 10 + (10+sectionH)*sectionNum;
    CGFloat cellY = startY;
    CGFloat cellX = 20 + miniW;
    CGFloat cellW = miniW*2;
    CGFloat cellH = miniH * 3 + 10;
    switch (areaNum) {
        case 0:{
            cellX = 10;
            cellW = miniW;
        }
            break;
        case 1:{
            cellH = miniH;
        }
            break;
        case 2:{
            cellY = startY + miniH + 10;
            cellH = miniH * 2;
        }
            break;
        case 3:{
            cellX = 10;
            cellY = miniW * 2 + 10 + startY;
            cellH = miniH;
        }
            break;
        case 4:{
            cellX = 10;
            cellY = startY + miniH*4 + 30;
            cellH = miniH * 2;
        }
            break;
        case 5:{
            cellX = 2*miniW + 20;
            cellY = miniW * 2 + 10 + startY;
            cellW = miniW;
        }
            break;
    }
    
    //得到当前小秘书
    att.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    return att;
}

-(NSMutableArray *)attArr{
    if (_attArr == nil) {
        _attArr = [NSMutableArray array];
    }
    return _attArr;
}


@end
