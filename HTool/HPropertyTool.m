//
//  HPropertyTool.m
//  runtime
//
//  Created by hare27 on 16/5/23.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HPropertyTool.h"

@interface HPropertyTool()

/** 用于保存所有字典的字典*/
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableDictionary *> *dict_all;

/** 保存json里面元素类型的集合*/
@property(nonatomic,strong)NSMutableSet *classNameSet;

@end


@implementation HPropertyTool

#pragma mark - 方法 Methods

+(void)getFileForJson:(id)json{
    
    HPropertyTool *tool = [HPropertyTool new];
    
    // 获取首页的字符串
    if ([json isKindOfClass:[NSDictionary class]] ) {
        tool.dict_all[@"index"] = [NSMutableDictionary dictionaryWithDictionary:json];
        [tool getAllDictForDict:json];
        // 如果是数组
    }else if ([json isKindOfClass:[NSArray class]]){
        NSMutableDictionary *dict_m = [tool mergeDictFromArr:json];
        if (dict_m) {
            tool.dict_all[@"index"] = dict_m;
            [tool getAllDictForDict:dict_m];
        }
    }
    
    __block NSInteger count = 0;
    
    // 遍历所有字典，写进文件
    [tool.dict_all enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propertyString = [tool getPropertyString:obj];
        [propertyString writeToFile:[NSString stringWithFormat:@"/Users/hare27/Desktop/propertyFile/%@.text",key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        count ++;
    }];
    
    NSLog(@"成功生成%ld个文件",count);
}

-(void)getAllDictForDict:(NSDictionary *)dict{
    
    // 如果传进来的不是字典
    if ([self isDictForJson:dict] == NO) {return;}
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 如果改元素是字典
        if ([self isDictForJson:obj]) {
            // 添加到self.dict_all
            [self addDictToAll:obj andKey:key];
            
            [self getAllDictForDict:obj];
            
        // 如果改元素是数组
        }else if([self isArrForJson:obj]){
            NSMutableDictionary *dict_m = [self mergeDictFromArr:obj];
            if (dict_m) {
                
                // 添加到self.dict_all
                [self addDictToAll:dict_m andKey:key];
                
                [self getAllDictForDict:dict_m];
            }
        }
    }];
}

/** 添加一个字典到self.dict_all*/
-(void)addDictToAll:(NSMutableDictionary *)dict_m andKey:(NSString *)key{
    // 先取，取的到就合并
    if (self.dict_all[key]) {
        
        [self mergeDict:dict_m toTargetDict:self.dict_all[key]];
        
    // 如果取不到就添加
    }else{
        self.dict_all[key] = dict_m;
    }
}

/** 合并两个字典*/
-(void)mergeDict:(NSDictionary *)dict toTargetDict:(NSMutableDictionary *)target{
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        target[key] = obj;
    }];
}

/** 合并数组中的字典*/
-(NSMutableDictionary *)mergeDictFromArr:(NSArray *)arr{
    // 获取里面的字典，并合并成一个
    NSMutableDictionary *dict_m = [NSMutableDictionary dictionary];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isDictForJson:obj]) {
            // 合并
            [self mergeDict:obj toTargetDict:dict_m];
        }
    }];
    
    return dict_m.allKeys ? dict_m : nil;
}

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
    }
    return NO;
}

/** 讲字典转换成用于创建文件的字符串，并打印出来*/
+(void)logPropertyForDict:(NSDictionary *)dict{
    NSLog(@"%@",[[self new] getPropertyString:dict]);
    
}

/** 讲字典转换成用于创建.h文件的字符串*/
-(NSString *)getPropertyString:(NSDictionary *)dict{
    // 打印所有属性类型名
    //    [propertyM getClassNameForJson:dict];
    //    NSLog(@"%@",propertyM.classNameSet);
    
    //    __NSCFDictionary,
    //    __NSCFBoolean,
    //    __NSArray0,
    //    __NSArrayM,
    //    __NSCFNumber,
    //    __NSCFString
    
    NSMutableString *propertyString = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *type;
        NSString *className;
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            type = @"strong";
            className = @"NSDictionary";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            type = @"assign";
            className = @"BOOL";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArray0")]){
            type = @"strong";
            className = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayM")]){
            type = @"strong";
            className = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"assign";
            className = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]){
            type = @"copy";
            className = @"NSString";
        }else{
            NSLog(@"出现了未知类型%@",[obj class]);
            NSAssert1(0, @"出现了未知类型%@",[obj class]);
        }
        
        if ([type isEqualToString:@"assign"]) {
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ %@\n",type,className,key];
        }else{
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ *%@\n",type,className,key];
        }
        
    }];
    
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