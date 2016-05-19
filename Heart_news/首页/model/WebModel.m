//
//  WebModel.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/15.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "WebModel.h"
#import <AFNetworking.h>
#import "NSObject+Json.h"

@interface WebModel (){
//    NSMutableDictionary *archiveDic;
}

@end

@implementation WebModel

static WebModel *once;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[WebModel alloc]init];
    });
    
    return once;
}

+ (NSURLSessionDataTask *)globalTimelinePostsWithID:(NSString*)ID Block:(void (^)(WebModel *webmodel, NSError *error))block {
    
    
    NSString *str = [NSString stringWithFormat:@"http://www.varpm.com:3002/v1/article/getDetail/%@",ID];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tag.archiver"]];
    
    
    __block NSMutableDictionary *archiveDic;
    
#pragma mark:::::must be mutableCopy
    archiveDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]mutableCopy];
    NSString *etag = (archiveDic[ID]?archiveDic[ID]:nil);
    //    设置request的etag用于和服务器相比较，这个值可以考虑存储在本地
    if(etag.length > 0)
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
        NSLog(@"status == %@",@(httpresponse.statusCode));
        if(httpresponse.statusCode == 304){//可以使用缓存
            NSCachedURLResponse *cacheResponse = [[NSURLCache sharedURLCache]cachedResponseForRequest:request];
            data = [NSData dataWithData:cacheResponse.data];
            //            在缓存中取出数据
        }
        //        简单解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic=%@",dic);
        [[self shareInstance]serializationDataWith:dic[@"data"]];

//                更新etag数据
        if(httpresponse.statusCode == 200)
        {
            NSString *etagstr = [httpresponse.allHeaderFields[@"Etag"]mutableCopy];
//            NSDictionary *temp = [NSDictionary dictionaryWithDictionary:httpresponse.allHeaderFields];
            if(!archiveDic){
                archiveDic = @{ID:etagstr};
            }else{
                archiveDic[ID] = etagstr;
            }
//            archiveDic = @{@"1":@"2"};
            [[NSURLCache sharedURLCache] storeCachedResponse:[[NSCachedURLResponse alloc]initWithResponse:response data:data] forRequest:request];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tag.archiver"]];
            [NSKeyedArchiver archiveRootObject:archiveDic toFile:filePath];
        }
        
        if (block) {
            block([self shareInstance], nil);
        }
    }];
    
    
    [task resume];
    return task;
//    
//    return [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"http://www.varpm.com:3002/v1/article/getDetail/%@",ID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        ;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        NSDictionary *dic = (NSDictionary *)responseObject[@"data"];
//        [[self shareInstance]serializationDataWith:dic];
//        if (block) {
//            block([self shareInstance], nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        ;
//    }];
}

//- (NSString *)etag{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tag.archiver"]];
//    archiveDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    return archiveDic[_ID];
//}

+ (NSString *)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tag.archiver"]];
    
    return filePath;
}


@end
