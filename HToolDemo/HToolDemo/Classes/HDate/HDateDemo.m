//
//  HDateDemo.m
//  HToolDemo
//
//  Created by hare27 on 16/8/6.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HDateDemo.h"
#import "HDateTool.h"

@interface HDateDemo ()

@property(nonatomic,strong)NSMutableArray *dateArr;

@property(nonatomic,strong)HDateTool *dateTool;

@end

@implementation HDateDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[self.dateTool getStringWithFormat:@"yyyy-MM-dd" FromeDate:[NSDate date]]);
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDate *date = self.dateArr[indexPath.row];
    cell.textLabel.text = [date description];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[self.dateTool dateIsThisMonthForDate:date]];
//    cell.detailTextLabel.text = [self.dateTool detailStringSinceNowForDate:date];
    cell.detailTextLabel.text = [self.dateTool getStringSinceNowForDate :date];
    
    return cell;
}


- (NSMutableArray *)dateArr {
	if(_dateArr == nil) {
		_dateArr = [[NSMutableArray alloc] init];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-50]];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-60*20]];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-60*60*23]];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*17]];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*30*7]];
        [_dateArr addObject:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*30*17]];
	}
	return _dateArr;
}

- (HDateTool *)dateTool {
	if(_dateTool == nil) {
		_dateTool = [[HDateTool alloc] init];
	}
	return _dateTool;
}

@end
