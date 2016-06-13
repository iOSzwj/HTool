//
//  HConstController.m
//  HToolDemo
//
//  Created by hare27 on 16/6/13.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HConstController.h"
#import "HConst.h"
#import "HConstCell.h"

@interface HConstController ()

@end

@implementation HConstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HConst";
    
    // hlog 和 HScreenW 、 HScreenH
    HLog(@"屏幕宽：%lf,屏幕高：%lf",HScreenW,HScreenH);
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentigy = @"const";
    HConstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentigy];
    
    // 颜色相关
    cell.contentView.backgroundColor = HRandColor;
    cell.rgbLabel.backgroundColor = HRGBColor(15, 200, 180);
    cell.rgbaLabel.backgroundColor = HRGBAColor(15, 200, 180, 200);
    return cell;
}

@end
