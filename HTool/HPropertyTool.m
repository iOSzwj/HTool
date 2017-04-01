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

// 用于保存一个模型类的.h和.m字符串
@interface PropertyFile : NSObject

@property(nonatomic,copy)NSString *hString;
@property(nonatomic,copy)NSString *mString;

@end

@implementation PropertyFile
@end




@interface HPropertyTool()

/** 用于保存所有字典的字典*/
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableDictionary *> *dict_all;

/** 保存json里面元素类型的集合*/
@property(nonatomic,strong)NSMutableSet *classNameSet;

/** 保存系统关键字的字典*/
@property(nonatomic,strong)NSDictionary *systemKey;

/** 使用使用MJExtension*/
@property(nonatomic,assign)BOOL useMJ;

@end


@implementation HPropertyTool

#pragma mark - 主方法

/** 讲字典转换成用于创建文件的字符串，并打印出来*/
+(void)logPropertyForJson:(id)json useMJ:(BOOL)useMJ{
    
    HPropertyTool *tool = [self toolWithUseMJ:useMJ];
    
    // 获取json中的所有dict
    [tool getAllDictForJson:json];
    
    [tool.dict_all enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableDictionary * _Nonnull dict, BOOL * _Nonnull stop) {
        PropertyFile *pf = [tool getPropertyString:dict  className:key.uppercaseFirstChar];
        NSLog(@"%@\n%@",pf.hString,pf.mString);
    }];
    
}

/** 生成json的.h文件*/
+(void)getFileForJson:(id)json useMJ:(BOOL)useMJ{
    
    [self getFileForJson:json useMJ:useMJ toFile:kLocationPath];
    
}
+(void)getFileForJson:(id)json useMJ:(BOOL)useMJ toFile:(NSString *)filePath{
    
    HPropertyTool *tool = [self toolWithUseMJ:useMJ];
    
    // 获取json中的所有dict
    [tool getAllDictForJson:json];
    
    // 保存到本地
    [tool saveDict:tool.dict_all ToPath:filePath];
    // 再将json保存到本地
    if ([json writeToFile:[filePath stringByAppendingPathComponent:@"json.plist"] atomically:YES]) {
        NSLog(@"%s json文件写入成功",__func__);
    }
    
}

#pragma mark - 初始化/工厂

+ (instancetype)toolWithUseMJ:(BOOL)useMJ{
    return [[self alloc]initWithUseMJ:useMJ];
}

- (instancetype)initWithUseMJ:(BOOL)useMJ
{
    self = [super init];
    if (self) {
        self.useMJ = useMJ;
    }
    return self;
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
        PropertyFile *pf = [self getPropertyString:obj className:key];
        BOOL isSucc = YES;
        [pf.hString writeToFile:[NSString stringWithFormat:@"%@/%@.h",path,key] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@的.h文件写入失败:%@ %@",key,error,error.userInfo);
            isSucc = NO;
        }
        
        [pf.mString writeToFile:[NSString stringWithFormat:@"%@/%@.m",path,key] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@的.m文件写入失败:%@ %@",key,error,error.userInfo);
            isSucc = NO;
        }
        if (isSucc) {
            count++;
        }
    }];
    
    NSLog(@"成功生成%ld个文件",count);
}


/** 讲字典转换成用于创建.h文件的字符串*/
-(PropertyFile *)getPropertyString:(NSDictionary *)dict className:(NSString *)className{
    
    // 保存模型文件字符串的模型类
    PropertyFile *pf = [PropertyFile new];
    
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
    
    // 保存数组的属性名和需要重命名的属性名数组
    NSMutableDictionary *renameDic = nil;
    NSMutableDictionary *arrNames = nil;
    
    if (self.useMJ) {
        renameDic = [NSMutableDictionary dictionary];
        arrNames = [NSMutableDictionary dictionary];
    }
    
    // 生成.h文件的字符串
    NSMutableString *propertyString = [NSMutableString stringWithFormat:@"\n@interface %@ : NSObject\n",className.uppercaseFirstChar];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *type = nil;
        NSString *propertyClass = nil;
        
        if ([self isDictForJson:obj]) {
            type = @"strong";
            propertyClass = key.uppercaseFirstChar;
        }else if ([self isArrForJson:obj]){
            
            if (self.useMJ) {
                arrNames[key] = key.uppercaseFirstChar;
            }
            
            type = @"strong";
            propertyClass = [@"NSArray" stringByAppendingFormat:@"<%@*>",key.uppercaseFirstChar];
            key=[key stringByAppendingString:@"s"];
            
            
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"assign";
            propertyClass = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]){
            type = @"copy";
            propertyClass = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            type = @"assign";
            propertyClass = @"BOOL";
        }else if ([obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]){
            type = @"copy";
            propertyClass = @"NSString";
        }else{
            NSLog(@"出现了未知类型%@",[obj class]);
            NSAssert1(0, @"出现了未知类型%@",[obj class]);
        }
        
        // 保存出现过的关键字到字典
        if (self.systemKey[key]) {
            renameDic[key] = self.systemKey[key];
            key = self.systemKey[key];
        }
        
        if ([type isEqualToString:@"assign"]) {
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ %@;\n",type,propertyClass,key];
        }else{
            [propertyString appendFormat:@"\n@property (nonatomic ,%@) %@ *%@;\n",type,propertyClass,key];
        }
        
    }];
    
    [propertyString appendString:@"\n@end\n"];
    pf.hString = [propertyString copy];
    
    
    // 生成.m文件的字符串
    if (self.useMJ) {
        
        NSMutableString *mString = [NSMutableString stringWithFormat:@"\n@implementation %@",className.uppercaseFirstChar];
        
        // 属性有重命名的
        if (renameDic.allKeys.count) {
            
            [mString appendString:@"\n\n+ (NSDictionary *)replacedKeyFromPropertyName{"];
            [mString appendString:@"\n\n\treturn @{"];
            
            [renameDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [mString appendFormat:@"@\"%@\":@\"%@\",",key,obj];
            }];
            
            // 去掉最后一个‘,’号
            [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
            [mString appendString:@"};"];
            [mString appendString:@"\n\n}\n"];
        }
        
        // 设置数组中的元素类型
        if (arrNames.allKeys.count) {
            
            [mString appendString:@"\n\n+ (NSDictionary *)objectClassInArray{"];
            [mString appendString:@"\n\n\treturn @{"];
            
            [arrNames enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [mString appendFormat:@"@\"%@\":[%@ class],",key,obj];
            }];
            
            // 去掉最后一个‘,’号
            [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
            [mString appendString:@"};"];
            [mString appendString:@"\n\n}\n"];
            
        }
        
        [mString appendString:@"\n@end"];
        pf.mString = [mString copy];
        
    }else{
        pf.mString = [NSString stringWithFormat:@"\n@implementation %@\n@end",className.uppercaseFirstChar];
        
    }
    
    return pf;
    
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

-(NSDictionary *)systemKey{
    
    if (_systemKey == nil) {
        _systemKey = @{
                       @"id":@"ID",
                       @"description":@"desc",
                       };
    }
    return _systemKey;
}

@end



