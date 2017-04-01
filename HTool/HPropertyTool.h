//
//  HPropertyTool.h
//  runtime
//
//  Created by hare27 on 16/5/23.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPropertyTool : NSObject

/** 讲字典转换成用于创建文件的字符串，并打印出来*/
+(void)logPropertyForDict:(NSDictionary *)dict;

/** 生成json的.h文件*/
+(void)getFileForJson:(id)json;
+(void)getFileForJson:(id)json toFile:(NSString *)filePath;

@end
