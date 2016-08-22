//
//  NSObject+Json.m
//  demo-for-kvc-json
//
//  Created by 徐纪光 on 16/4/30.
//  Copyright © 2016年 徐纪光. All rights reserved.
//

#import "NSObject+Json.h"
#import <objc/runtime.h>
@implementation NSObject (Json)
-(void) serializationDataWith:(NSDictionary *)dict{
    
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 成员变量名转为属性名（去掉下划线 _ ）
            key = [key substringFromIndex:1];
            // 取出字典的值
            id value = dict[key];
            if([key isEqualToString:@"tags"]){
                [self setValue:value forKey:key];
                continue;
            }
            // 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil而报错
            if (value == nil) continue;
            
            // 获得成员变量的类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            // 如果属性是对象类型
            NSRange range = [type rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                // 那么截取对象的名字（比如@"Dog"，截取为Dog）
                type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                // 排除系统的对象类型
                if (![type hasPrefix:@"NS"]) {
                    // 将对象名转换为对象的类型，将新的对象字典转模型（递归）
                    Class class = NSClassFromString(type);
                    value = [class objectWithDict:value];
                    
                }else if ([type isEqualToString:@"NSArray"]) {
                    
                    // 如果是数组类型，将数组中的每个模型进行字典转模型，先创建一个临时数组存放模型
                    NSMutableArray *mArray = [NSMutableArray array];
                    if([self valueForKey:key]){
                        //                        这个操作是讲将之前的model放进来
                        [mArray addObjectsFromArray:[self valueForKey:key]];
                    }
                    NSArray *array = (NSArray *)value;
                    
                    
                    // 获取到每个模型的类型
                    id class ;
                    if ([self respondsToSelector:@selector(arrayObjectClass)]) {
                        
                        NSString *classStr = [self arrayObjectClass];
                        class = NSClassFromString(classStr);
                    }
                    // 将数组中的所有模型进行字典转模型
                    for (int i = 0; i < array.count; i++) {
                        if([class objectWithDict:value[i]])
                            [mArray addObject:[class objectWithDict:value[i]]];
                    }
                    
                    value = mArray;
                }
            }
            
            // 将字典中的值设置到模型上
            [self setValue:value forKeyPath:key];
        }
        free(ivars);
        c = [c superclass];
    }
    //    Class c = self.class;
    //    while(c && c!=[NSObject class]){
    //        unsigned int count;
    //        Ivar *ivars = class_copyIvarList(c, &count);
    //        for (int i=0; i<count; i++) {
    //            Ivar ivar = ivars[i];
    //            NSString *name = [[NSString stringWithUTF8String:ivar_getName(ivar)]substringFromIndex:1] ;
    //
    //            id value = dic[name];
    //
    //            //多余的属性可以不管
    //            if (!value) {
    //                continue;
    //            }
    //            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    //            type = [type substringWithRange:NSMakeRange(2, type.length-3)];
    ////            第一种情况得到的数据类型是另一个模型所以我们进行进一步解析
    //            if(![type hasPrefix:@"NS"]){
    //                Class class = NSClassFromString(type);
    //                value = [class objectWithDict:value];
    //            }
    //
    ////            处理是数组的情况
    //            else if([type isEqualToString:@"NSArray"]){
    //                NSArray *arr = (NSArray *)value;
    //                NSMutableArray *marr = [[NSMutableArray alloc]init];
    //                id class;
    //                if([self respondsToSelector:@selector(arrayObjectClass)]){
    ////                    获取数组中的数据类型，这一步可以优化。可以考虑模型中出现多个array
    //
    //                    class = NSClassFromString([self arrayObjectClass]);
    //                }
    ////                 将数组中的所有模型进行字典转模型
    //                for (int i = 0; i < arr.count; i++) {
    //                    if ([class objectWithDict:value[i]]) {
    //
    //                        [marr addObject:[class objectWithDict:value[i]]];
    //                    }
    //                }
    //                value = marr;
    //            }
    //
    //
    //            NSLog(@"name:%@       type:%@",name,type);
    //
    ////            object_setIvar(self, ivar, dic[name]);
    //
    //            [self setValue:dic[name] forKey:name];//也可以
    //                        NSLog(@"%@",object_getIvar(self, ivar));
    //        }
    //        free(ivars);
    //        c = [c superclass];
    //    }
}

#pragma Class,实例化方法,
+ (instancetype)objectWithDict:(NSDictionary *)dict{
    NSObject *obj = [[self alloc]init];
    [obj serializationDataWith:dict];
    return obj;
}

@end
