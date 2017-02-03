//
//  ViewController.m
//  AFNetworking的文件上传
//
//  Created by t3 on 17/1/24.
//  Copyright © 2017年 feyddy. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "NSString+Hash.h"
#import "CocoaSecurity.h"//其他的加密方式


@interface ViewController ()
@property (nonatomic,strong) Reachability *r;
@end

@implementation ViewController
//在使用afn的时候建议自己封装一个工具类

- (IBAction)upLoadButton:(UIButton *)sender {
    
//    [self upLoadFile1];
    
    
    [self md5];
   
    
}




#pragma mark - MD5加密
- (void)md5 {
    NSString *str = @"Feyddy";
    NSString *md5Str = [str md5String];
    NSLog(@"%@",md5Str);
    //7da061fb1f695a9ac9f36a85769aeed8
    
    
    //改进
    //1、多次加密：[[str md5String]md5String]
    //2、加盐：@"Feyddy+www"
    //3、先加密再乱序
}


#pragma mark - appleAPI实现网络监听(不推荐)

- (void)apiNoti {
     //appleAPI实现网络监听
     //网络环境修改后注册的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetwork) name:kReachabilityChangedNotification object:nil];
     
     //开始
     Reachability *r = [Reachability reachabilityForInternetConnection];
     [r startNotifier];
     self.r = r;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)changeNetwork {
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
        NSLog(@"wifi");
    }else if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable)
    {
        NSLog(@"3G");
    }else
    {
        NSLog(@"没有网络");
    }
}





#pragma mark - afnetworking实现网络监听
- (void)networkMonitoring {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,未知
     AFNetworkReachabilityStatusNotReachable     = 0,未连接互联网
     AFNetworkReachabilityStatusReachableViaWWAN = 1,3G
     AFNetworkReachabilityStatusReachableViaWiFi = 2,无线网
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"未连接互联网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线网");
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
}


#pragma mark - afnetworking的序列化和ContentType
- (void)a {
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置序列化
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];//专门解析XML
    
    //设置返回的ContentType
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    
    //发送请求
    NSDictionary *dict = @{
                           @"username":@"Feyddy",
                           @"pwd":@"asd",
                           @"type":@"XML"
                           };
    
    [manager GET:@"url" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}





#pragma mark - afnetworking的上传文件
- (void)upLoadFile1 {
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.发送请求上传
    NSString *url = @"你的URL";
    NSDictionary *dict = @{
                           @"username":@"feyddy",
                           @"password":@"12345"
                           };
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //获取文件
        UIImage *image = [UIImage imageNamed:@"Feyddy"];
        //
        NSData *imageData = UIImagePNGRepresentation(image);
        
        /**
         *  name: 接口名
         *  fileName: 上传到服务器的文件存储名称
         *  mimeType: 分类名
         *  @param NSData <#NSData description#>
         *
         *  @return <#return value description#>
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"feyddy.png" mimeType:@"image/png"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)upLoadFile2 {
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.发送请求上传
    NSString *url = @"你的URL";
    NSDictionary *dict = @{
                           @"username":@"feyddy",
                           @"password":@"12345"
                           };
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //获取文件
        UIImage *image = [UIImage imageNamed:@"Feyddy"];
        //
        NSData *imageData = UIImagePNGRepresentation(image);
        
        /**
         *  name: 接口名
         *  fileName: 上传到服务器的文件存储名称
         *  mimeType: 分类名
         *  application/octet-stream: 二进制
         *  @param NSData <#NSData description#>
         *
         *  @return <#return value description#>
         */
//        NSURL *url = [NSURL URLWithString:@"/Users/t3/Desktop/Undergraduate.png"];
        NSURL *url = [NSURL fileURLWithPath:@"/Users/t3/Desktop/Undergraduate.png"];
        
        [formData appendPartWithFileURL:url name:@"file" fileName:@"Undergraduate.png" mimeType:@"application/octet-stream" error:nil];
        
        //这个方法在内部有处理fileName和mimeType字段。
//        [formData appendPartWithFileURL:nil name:@"file" error:nil];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



@end
