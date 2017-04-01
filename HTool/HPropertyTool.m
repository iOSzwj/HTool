//
//  HPropertyTool.m
//  runtime
//
//  Created by hare27 on 16/5/23.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HPropertyTool.h"
#import "NSString+Sub.h"

#warning 使用前，先修改下这里的路径
#define kLocationPath @"/Users/hare/Desktop/modelDirectory"

@interface HPropertyTool()

/** 用于保存所有字典的字典*/
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableDictionary *> *dict_all;

/** 保存json里面元素类型的集合*/
@property(nonatomic,strong)NSMutableSet *classNameSet;

@end


@implementation HPropertyTool

#pragma mark - 主方法

/** 讲字典转换成用于创建文件的字符串，并打印出来*/
+(void)logPropertyForDict:(id)json{
    
    HPropertyTool *tool = [HPropertyTool new];
    
    // 获取json中的所有dict
    [tool getAllDictForJson:json];
    
    [tool.dict_all enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableDictionary * _Nonnull dict, BOOL * _Nonnull stop) {
        NSLog(@"%@",[tool getPropertyString:dict  className:key.uppercaseString]);
    }];
    
    
    
}

/** 生成json的.h文件*/
+(void)getFileForJson:(id)json{
    
    [self getFileForJson:json toFile:kLocationPath];
    
}
+(void)getFileForJson:(id)json toFile:(NSString *)filePath{
    
    HPropertyTool *tool = [HPropertyTool new];
    
    // 获取json中的所有dict
    [tool getAllDictForJson:json];
    
    // 保存到本地
    [tool saveDict:tool.dict_all ToPath:filePath];
    // 再将json保存到本地
    if ([json writeToFile:[filePath stringByAppendingPathComponent:@"json.plist"] atomically:YES]) {
        NSLog(@"%s json文件写入成功",__func__);
    }
    
}

#pragma mark - 实例方法

/** 获取json中的所有dict*/
-(void)getAllDictForJson:(id)json{
    
    // 如果是字典
    if ([json isKindOfClass:[NSDictionary class]]) {
        [self addDictToAll:json andKey:@"index"];
        // 如果是数组
    }else if ([json isKindOfClass:[NSArray class]]){
        [self addArrToAll:json andKey:@"index"];
    }else{
        return;
    }
}

/** 添加一个字典到self.dict_all*/
-(void)addDictToAll:(NSDictionary *)json andKey:(NSString *)key{
    
    NSMutableDictionary *dict = self.dict_all[key];
    
    if (dict) {
        
        [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([self isDictForJson:obj]) {
                dict[key] = [NSDictionary dictionary];
                [self addDictToAll:obj andKey:key];
            }else if ([self isArrForJson:obj]) {
                [self addArrToAll:obj andKey:key];
            }else{
                dict[key] = obj;
            }
        }];
        
    }else{
        
        dict = [NSMutableDictionary new];
        
        [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([self isDictForJson:obj]) {
                dict[key] = [NSDictionary dictionary];
                [self addDictToAll:obj andKey:key];
            }else if ([self isArrForJson:obj]) {
                dict[key] = [NSArray array];
                [self addArrToAll:obj andKey:key];
            }else{
                dict[key] = obj;
            }
        }];
        
        self.dict_all[key] = dict;
    }
}

/** 添加数组中的字典到self.dict_all*/
-(void)addArrToAll:(NSArray *)arr andKey:(NSString *)key{
    
    if (arr.count) {
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self isDictForJson:obj]) {
                [self addDictToAll:obj andKey:key];
            }
        }];
    }
}


/** 保存到本地*/
-(void)saveDict:(NSDictionary<NSString *, NSDictionary *> *)dict ToPath:(NSString *)path{
    __block NSInteger count = 0;
    
    // 遍历所有字典，写进文件
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSError *error;
        
        // 判断该路劲是否存在，不存在就创建
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path] == NO) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"%s文件夹创建失败:%@ %@",__func__,error,error.userInfo);
                return;
            }
        }
        
        // 写到文件中
        NSString *propertyString = [self getPropertyString:obj className:key];
        [propertyString writeToFile:[NSString stringWithFormat:@"%@/%@.h",path,key] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@写入失败:%@ %@",key,error,error.userInfo);
        }else{
            count ++;
        }
    }];
    
    NSLog(@"成功生成%ld个文件",count);
}


/** 讲字典转换成用于创建.h文件的字符串*/
-(NSString *)getPropertyString:(NSDictionary *)dict className:(NSString *)className{
    // 打印所有属性类型名
    //    [propertyM getClassNameForJson:dict];
    //    NSLog(@"%@",propertyM.classNameSet);
    
    //    __NSCFDictionary,
    //    __NSCFBoolean,
    //    __NSArray0,
    //    __NSArrayM,
    //    __NSCFArray
    //    __NSCFNumber,
    //    __NSCFString
    
    NSMutableString *propertyString = [NSMutableString stringWithFormat:@"\n@interface %@ : NSObject\n",className.uppercaseFirstChar];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *type;
        NSString *className;
        
        if ([self isDictForJson:obj]) {
            type = @"strong";
            className = key.uppercaseFirstChar;
        }else if ([self isArrForJson:obj]){
            type = @"strong";
            className = [@"NSArray" stringByAppendingFormat:@"<%@*>",key.uppercaseFirstChar];
            key=[key stringByAppendingString:@"s"];
            
            
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"assign";
            className = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]){
            type = @"copy";
            className = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            type = @"assign";
            className = @"BOOL";
        }else if ([obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]){
            type = @"copy";
            className = @"NSString";
        }else{
            NSLog(@"出现了未知类型%@",[obj class]);
            NSAssert1(0, @"出现了未知类型%@",[obj class]);
        }
        
        if ([type isEqualToString:@"assign"]) {
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ %@;\n",type,className,key];
        }else{
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ *%@;\n",type,className,key];
        }
        
    }];
    
    [propertyString appendString:@"\n@end\n"];
    
    return  [propertyString copy];
    
}

/** 获取json里面的所有类型，并保存到self.classNameSet里面*/
-(void)getClassNameForJson:(id)json{
    
    // 字典
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)json;
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.classNameSet addObject:[obj class]];
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                [self getClassNameForJson:obj];
            }
        }];
    }else if ([json isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)json;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.classNameSet addObject:[obj class]];
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                [self getClassNameForJson:obj];
            }
        }];
    }else{
        [self.classNameSet addObject:[json class]];
    }
    
}

#pragma mark - 判断
/** 判断一个对象是否是字典类型*/
-(BOOL)isDictForJson:(id)json{
    if ([json isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else if ([json isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
        return YES;
    }
    return NO;
}

/** 判断一个对象是否是数组类型*/
-(BOOL)isArrForJson:(id)json{
    if ([json isKindOfClass:[NSArray class]]) {
        return YES;
    }else if ([json isKindOfClass:NSClassFromString(@"__NSArrayM")]){
        return YES;
    }else if ([json isKindOfClass:NSClassFromString(@"__NSArray0")]){
        return YES;
    }else if ([json isKindOfClass:NSClassFromString(@"__NSCFArray")]){
        return YES;
    }
    return NO;
}

#pragma mark - 懒加载 Lazy Load

- (NSMutableSet *)classNameSet {
    if(_classNameSet == nil) {
        _classNameSet = [[NSMutableSet alloc] init];
    }
    return _classNameSet;
}

- (NSMutableDictionary *)dict_all {
    if(_dict_all == nil) {
        _dict_all = [[NSMutableDictionary alloc] init];
    }
    return _dict_all;
}

@end
