//
//  HPropertyVC.m
//  HToolDemo
//
//  Created by hare27 on 16/8/7.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HPropertyVC.h"
#import "HPropertyTool.h"

@interface HPropertyVC ()

@end

@implementation HPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json.plist" ofType:nil]];
    
    [HPropertyTool getFileForJson:dictionary];
    
    // Do any additional setup after loading the view.
}

@end
