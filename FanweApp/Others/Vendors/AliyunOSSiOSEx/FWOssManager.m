//
//  FWOssManager.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/31.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWOssManager.h"

NSString * const bucketName = @"sdk-demo";
NSString * const STSServer = @"http://oss-cn-shanghai.aliyuncs.com/app-server/sts.php";

@implementation FWOssManager

- (id)initWithDelegate:(id<OssUploadImageDelegate>)delegate
{
    if (self = [super init])
    {
        _fanweApp = [GlobalVariables sharedInstance];
        _httpsManager = [NetHttpsManager manager];
        self.OssDelegate = delegate;
        [self getinfomation];
    }
    return self;
}


#pragma mark 请求接口获得上传图片需要的各种参数
- (void)getinfomation
{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"app" forKey:@"ctl"];
    [mDict setObject:@"aliyun_sts" forKey:@"act"];
    FWWeakify(self)
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
    FWStrongify(self)
        [self loadOssDic:responseJson];
    } FailureBlock:^(NSError *error){
        
    }];
}

#pragma mark  请求oss接口请求返回数据的处理
- (void)loadOssDic:(NSDictionary *)responseJson
{
    _oss_domain = [responseJson objectForKey:@"oss_domain"];
    _endPoint = [responseJson objectForKey:@"endpoint"];
    _imageEndPoint = [responseJson objectForKey:@"imgendpoint"];
    _callbackAddress = [responseJson objectForKey:@"callbackUrl"];
    _dir = [responseJson objectForKey:@"dir"];
    _AccessKeyId = [responseJson objectForKey:@"AccessKeyId"];
    _AccessKeySecret = [responseJson objectForKey:@"AccessKeySecret"];
    _SecurityToken = [responseJson objectForKey:@"SecurityToken"];
    _Expiration = [responseJson objectForKey:@"Expiration"];
    _bucket = [responseJson objectForKey:@"bucket"];

    if ([self isSetRightParameter])
    {
       [self ossInit];
    }
}

#pragma mark oss上传的参数是不是配置好
- (BOOL)isSetRightParameter
{
    if (_endPoint.length < 1 || _dir.length < 1 || _bucket.length < 1 || _AccessKeyId.length < 1 || _AccessKeySecret.length < 1  || _SecurityToken.length < 1 || _bucket.length < 1)
    {
        return NO;
    }else
    {
        return YES;
    }
}

#pragma mark  获取FederationToken
- (OSSFederationToken *) getFederationToken
{
    NSURL * url = [NSURL URLWithString:STSServer];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [tcs setError:error];
                                                        return;
                                                    }
                                                    [tcs setResult:data];
                                                }];
    [sessionTask resume];
    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        return nil;
    } else {
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = _AccessKeyId;
        token.tSecretKey = _AccessKeySecret;
        token.tToken = _SecurityToken;
        token.expirationTimeInGMTFormat = _Expiration;
        return token;
    }
}

#pragma mark 初始化获取OSSClient
- (void)ossInit
{
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    _client = [[OSSClient alloc] initWithEndpoint:_endPoint credentialProvider:credential];
}

#pragma mark 设置server callback地址
- (void)setCallbackAddress:(NSString *)address
{
    _callbackAddress = address;
}

#pragma mark 上传图片
- (void)asyncPutImage:(NSString *)objectKey
        localFilePath:(NSString *)filePath
{
    if (objectKey == nil || [objectKey length] == 0)
    {
        return;
    }
    _putRequest = [OSSPutObjectRequest new];
    _putRequest.bucketName = _bucket;
    _putRequest.objectKey = objectKey;
    _putRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    _putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    if (_callbackAddress != nil) {
        _putRequest.callbackParam = @{
                                     @"callbackUrl": _callbackAddress,
                                     // callbackBody可自定义传入的信息
                                     @"callbackBody": @"filename=${object}"
                                     };
    }
    OSSTask * task = [_client putObject:_putRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult * result = task.result;
        // 查看server callback是否成功
        if (!task.error) {
            NSLog(@"Put image success!");
            NSLog(@"result==%@",result);
            NSLog(@"server callback:%@", result.serverReturnJsonString);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statutCount = 0;
                if (self.OssDelegate)
                {
                    if (self.OssDelegate) {
                        if ([self.OssDelegate respondsToSelector:@selector(uploadImageWithUrlStr:withUploadStateCount:)])
                        {
                            [self.OssDelegate uploadImageWithUrlStr:result.serverReturnJsonString withUploadStateCount:self.statutCount];
                        }
                    }
                }
            });
        } else {
            NSLog(@"Put image failed, %@", task.error);
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statutCount = 1;
                    if (self.OssDelegate)
                    {
                        if (self.OssDelegate) {
                            if ([self.OssDelegate respondsToSelector:@selector(uploadImageWithUrlStr:withUploadStateCount:)])
                            {
                                [self.OssDelegate uploadImageWithUrlStr:result.serverReturnJsonString withUploadStateCount:self.statutCount];
                            }
                        }
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statutCount = 2;
                    if (self.OssDelegate)
                    {
                        if (self.OssDelegate) {
                            if ([self.OssDelegate respondsToSelector:@selector(uploadImageWithUrlStr:withUploadStateCount:)])
                            {
                                [self.OssDelegate uploadImageWithUrlStr:result.serverReturnJsonString withUploadStateCount:self.statutCount];
                            }
                        }
                    }
                });
            }
        }
        _putRequest = nil;
        return nil;
    }];
}

#pragma mark --------------------------------  oss 上传
#pragma mark --- 上传照片 或视频 的二进制数据
-(void)showUploadOfOssServiceOfDataMarray:(NSMutableArray<NSData *>*)dataArray
                   andSTDynamicSelectType:(STDynamicSelectType)stDynamicSelectType
                              andComplete:(void(^)(BOOL finished,
                                                   NSMutableArray <NSString *>*urlStrMArray))block{
#pragma mark --- 预处理
    
    //数据
    if (!dataArray.count||!dataArray) {
        if (block) {
            block(NO,nil);
        }
        return;
    }
    //设置数组 存放返回的url
    NSMutableArray *urlStrMArray = @[].mutableCopy;
    //开启 多线程  for 循环创立
    dispatch_queue_t st_queue = dispatch_queue_create("upLoadImgArray", DISPATCH_QUEUE_SERIAL);
    for (int i= 0;i <dataArray.count; i++) {
        //预处理 objectKeyStr
        NSString *objectKeyStr = [self getObjectKeyString];
        if (objectKeyStr == nil || [objectKeyStr length] == 0) {
            if (block) {
                block(NO,nil);
            }
            return;
        }
        //开启分线程
        dispatch_async(st_queue, ^{
            _putRequest = [OSSPutObjectRequest new];
            _putRequest.bucketName = _bucket;
            if (stDynamicSelectType == STDynamicSelectVideo ) {
                _putRequest.objectKey = [objectKeyStr stringByReplacingOccurrencesOfString:@"png" withString:@"mp4"];
            }else{
                _putRequest.objectKey = objectKeyStr;
            }
            // putRequest.objectKey = objectKeyStr;
            _putRequest.uploadingData = dataArray[i];
            _putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            };
            
            if (_callbackAddress != nil) {
                _putRequest.callbackParam = @{
                                             @"callbackUrl": _callbackAddress,
                                             // callbackBody可自定义传入的信息
                                             @"callbackBody": @"filename=${object}"
                                             };
            }
            //上传任务
            OSSTask * task = [_client putObject:_putRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                //阻塞 上传
                [task waitUntilFinished];
                // 查看server callback是否成功
                if (!task.error) {
                    NSLog(@"Put image success!");
                    NSLog(@"result==%@",result);
                    NSLog(@"server callback--------:%@", result.serverReturnJsonString);
                    //返回urlStr
                    NSString *tempStr;
                    if (stDynamicSelectType == STDynamicSelectVideo ) {
                        tempStr =  [objectKeyStr stringByReplacingOccurrencesOfString:@"png" withString:@"mp4"];
                    }else{
                        tempStr = objectKeyStr;
                    }
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",self.oss_domain,tempStr];
                    NSLog(@"------urlStr--------%@---------",urlStr);
                    [urlStrMArray addObject:urlStr];
                    if (i+1 ==dataArray.count ) {
                        if (block) {
                            block(YES,urlStrMArray);
                        }
                    }
                } else {
                    NSLog(@"eqewqw2222");
                }
                _putRequest = nil;
                return nil;
            }];
            [task waitUntilFinished];
        });
    }
}


- (NSString *)getObjectKeyString
{
    NSDate *currentDate = [NSDate date];//获取当前时间日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *nameString = [NSString stringWithFormat:@"%@%d.png",dateString,arc4random()%10000/1000];
    _objectKey = [NSString stringWithFormat:@"%@%@",self.dir,nameString];
    return _objectKey;
}



@end
