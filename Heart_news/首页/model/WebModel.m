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

@interface WebModel ()<NSURLSessionTaskDelegate>{
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

#warning mei  使用缓存

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

    NSLog(@"%@----%@-----%@",ID,etag,archiveDic);
    //    设置request的etag用于和服务器相比较，这个值可以考虑存储在本地
    if(etag.length > 0)
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[self shareInstance] delegateQueue:nil];
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
        [[self shareInstance]serializationDataWith:dic[@"data"]];

//                更新etag数据
        if(httpresponse.statusCode == 200)
        {
            NSString *etagstr = [httpresponse.allHeaderFields[@"Etag"]mutableCopy];
//            NSDictionary *temp = [NSDictionary dictionaryWithDictionary:httpresponse.allHeaderFields];
#warning 加了一个mutableCopy
            if(!archiveDic){
                archiveDic = [@{ID:etagstr} mutableCopy];
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
//        //        [[NSURLCache sharedURLCache] storeCachedResponse:[[NSCachedURLResponse alloc]initWithResponse:response data:data] forRequest:[[AFHTTPSessionManager manager]];
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

//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler


//-
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSLog(@"111");
}



//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten BytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite; dispatch_async(dispatch_get_main_queue(),^{
////            self.progressIndicator.hidden = NO;
////            self.progressIndicator.progress = currentProgress;
//    });
//}

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
