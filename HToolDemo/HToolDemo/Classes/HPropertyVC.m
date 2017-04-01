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
    
    // 直接生成模型文件
    // 默认路径
    [HPropertyTool getFileForJson:dictionary useMJ:YES];
    // 传入路径
//    [HPropertyTool getFileForJson:dictionary useMJ:NO toFile:@"/Users/hare/Desktop/modelDirectory"];
    
    // 打印模型内容
    [HPropertyTool logPropertyForJson:dictionary useMJ:YES];
    
    
    
    // Do any additional setup after loading the view.
}

@end
