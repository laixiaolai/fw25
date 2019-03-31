//
//  dateModel.m
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "dataModel.h"
#import "NSObject+myobj.h"
#import "Util.h"
#import "AFURLSessionManager.h"
#import <QMapKit/QMapKit.h>
#import <objc/message.h>
#import "Mwxpay.h"
#import "FMDB.h"
#import <ImSDK/TIMManager.h>
#import "IMAMsg.h"
#import "AVIMAble.h"
#import <StoreKit/StoreKit.h>
#import "TPAACAudioConverter.h"

@implementation dataModel

@end

@interface SAutoEx()<NSCoding,SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, copy) void (^block) (SResBase *resb);

@end

static FMDatabaseQueue * g_db_queue = nil;

@implementation SAutoEx

- (id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        [self fetchIt:obj];
    }
    return self;
}

- (void)fetchIt:(NSDictionary*)obj
{
    if( obj == nil ) return;
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if( properties )
    {
        free( properties );
    }
    
    if( nameMapProp.count == 0 ) return;
    
    NSArray* allnames = [nameMapProp allKeys];
    for ( NSString* oneName in allnames )
    {
        if( ![oneName hasPrefix:@"m"] ) continue;
        //mId....like this
        NSString* jsonkey = [oneName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:[[oneName substringWithRange:NSMakeRange(1, 1)] lowercaseString] ];
        //mId ==> mid;
        jsonkey = [jsonkey substringFromIndex:1];
        //mid ==> id;
        id itobj = [obj objectForKeyMy:jsonkey];
        
        if( itobj == nil ) continue;
        
        [self setValue:itobj forKey:oneName];
    }
}

-(NSArray*)getClassAllPropNameForCoder
{
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        if( [propName hasPrefix:@"mm"] ) continue;//这种字段不需要保存
        
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if(properties)
    {
        free( properties );
    }
    return [nameMapProp allKeys];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray* allprop = [self getClassAllPropNameForCoder];
    for ( NSString* one in allprop )
    {
        [aCoder encodeObject: [self valueForKey:one]  forKey:one];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    NSArray* allprop = [self getClassAllPropNameForCoder];
    for ( NSString* one in allprop )
    {
        id k = [aDecoder decodeObjectForKey: one];
        if( k )
            [self setValue:k forKey:one];
    }
    return self;
}

+ (BOOL)saveData:(id)data forkey:(NSString*)key
{
    if( data == nil || key == nil) return NO;
    
    NSString*ss = [NSString stringWithFormat:@"%@_%@",key,[IMAPlatform sharedInstance].host.imUserId];
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    NSData* dat = [NSKeyedArchiver archivedDataWithRootObject:data];
    [st setObject:dat forKey:ss];
    return [st synchronize];
}

+ (id)loadDataWithKey:(NSString*)key
{
    if( key == nil ) return nil;
    NSString*ss = [NSString stringWithFormat:@"%@_%@",key,[IMAPlatform sharedInstance].host.imUserId ];
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    NSData* dat = [st objectForKey:ss];
    if( dat == nil ) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:dat];
}

+ (void)initialize
{
    if( g_db_queue == nil )
    {
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"zbdata.db"];
        g_db_queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
}

//addListData 添加all的数据到存储
+ (void)addListData:(NSArray*)all idname:(NSString*)idname forKey:(NSString*)key block:(void(^)(SResBase* resb))block
{
    [g_db_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString* t_name = [NSString stringWithFormat:@"t_%@",key];
         BOOL create =  [db executeUpdate: [NSString stringWithFormat:@"create table if not exists %@( userid text , id interger , data blob ) " ,t_name]];
         if( !create )
         {
             NSLog(@"open db failed");
             *rollback = YES;
             block( [SResBase infoWithString: @"存储数据失败"]) ;
             return ;
         }
         NSString* userid = [IMAPlatform sharedInstance].host.imUserId ;
         
         NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ ( userid, id,data ) VALUES ( ? , ? ,?)", t_name];
         
         for (int k = 0 ; k < all.count;k++)
         {
             BOOL b;
             int itid = k;
             NSData* dat;
             
             itid = [[all[k] valueForKey:idname] intValue];
             dat = [NSKeyedArchiver archivedDataWithRootObject:all[k]];
             
             b = [db executeUpdate:sql,userid,@(itid),dat];
             if( !b )
             {
                 NSLog(@"insert err:%@ at index:%d user:%@ key:%@",dat,k,userid,t_name);
                 *rollback = YES;
                 block([SResBase infoWithString: @"存储数据失败"]) ;
                 return ;
             }
         }
         
         block( [SResBase infoWithOKString:@"存储数据成功"] );
     }];
}

+ (void)getListData:(int)page forKey:(NSString*)key block:(void(^)(SResBase* resb ,NSArray* all))block
{
    [g_db_queue inDatabase:^(FMDatabase *db) {
        
        NSString* userid = [IMAPlatform sharedInstance].host.imUserId ;
        
        NSString* t_name    =   [NSString stringWithFormat:@"t_%@",key];
        NSString* sql       =   [NSString stringWithFormat:@"select * from %@ where userid = %@ order by id asc limit 20 offset %d",t_name,userid,page*20];
        
        FMResultSet *rsl = [db executeQuery:sql];
        NSMutableArray* t = NSMutableArray.new;
        while ( [rsl next] )
        {
            NSData* dat = [rsl dataForColumn:@"data"];
            if( dat != nil && ![dat isKindOfClass:[NSNull class]] )
            {
                id obj = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
                [t addObject:obj];
            }
        }
        block( [SResBase infoWithOKString:@"获取数据成功"], t );
    }];
}

+ (void)removeListData:(NSArray*)all idname:(NSString*)idname forKey:(NSString*)key block:(void(^)(SResBase* resb))block
{
    [g_db_queue inTransaction:^(FMDatabase *db ,BOOL *rollback) {
        
        NSString* userid = [IMAPlatform sharedInstance].host.imUserId;
        NSString* t_name    =   [NSString stringWithFormat:@"t_%@",key];
        for ( id oneobj in all ) {
            
            int mid = [[oneobj valueForKey:idname] intValue];
            NSString* sql       =   [NSString stringWithFormat:@"delete from %@ where userid = %@ and id=%d ",t_name,userid,mid];
            BOOL b = [db executeUpdate:sql];
            if( !b )
            {
                NSLog(@"remove list dataerr");
                *rollback = YES;
                block( [SResBase infoWithString:@"删除数据失败"] );
                return;
            }
        }
        
        block( [SResBase infoWithOKString:@"获取数据成功"] );
        
    }];
}

+ (void)clearDataForKey:(NSString*)key block:(void(^)(SResBase* resb))block
{
    [g_db_queue inDatabase:^(FMDatabase *db) {
        
        NSString* t_name    =   [NSString stringWithFormat:@"t_%@",key];
        NSString* sql       =   [NSString stringWithFormat:@"drop table %@ ",t_name];
        
        BOOL b = [db executeUpdate:sql];
        if( block )
        {
            if( b )
            {
                block( [SResBase infoWithOKString:@"删除表成功"]);
            }
            else
            {
                block( [SResBase infoWithString:@"删除表失败"]);
            }
        }
    }];
}

+ (id)findObjForKey:(NSString*)key idvalue:(int)idvalue
{
    MYNSCondition* itlock = [[MYNSCondition alloc] init];//搞个事件来同步下
    
    __block id findlocobj = nil;
    
    [g_db_queue inDatabase:^(FMDatabase *db) {
        
        NSString* userid = [IMAPlatform sharedInstance].host.imUserId;
        
        NSString* t_name    =   [NSString stringWithFormat:@"t_%@",key];
        NSString* sql       =   [NSString stringWithFormat:@"select * from %@ where userid = %@ and id = %d limit 0,1",t_name,userid,idvalue];
        
        FMResultSet *rsl = [db executeQuery:sql];
        while ( [rsl next] ) {
            NSData* dat = [rsl dataForColumn:@"data"];
            if( dat != nil && ![dat isKindOfClass:[NSNull class]] )
            {
                findlocobj = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
            }
        }
        
        [itlock lock];
        [itlock signal];
        [itlock unlock];
        
    }];
    
    [itlock lock];
    [itlock wait];
    [itlock unlock];
    
    return findlocobj;
}

//这个对象是否存储 有存储到 这key下面的
- (id)haveThisObjInLocalForKey:(NSString*)key idname:(NSString*)idname
{
    MYNSCondition* itlock = [[MYNSCondition alloc] init];//搞个事件来同步下
    
    __block id findlocobj = nil;
    
    [g_db_queue inDatabase:^(FMDatabase *db) {
        
        NSString* userid = [IMAPlatform sharedInstance].host.imUserId;
        
        NSString* t_name    =   [NSString stringWithFormat:@"t_%@",key];
        NSString* sql       =   [NSString stringWithFormat:@"select * from %@ where userid = %@ and id = %d limit 0,1",t_name,userid,[[self valueForKey:idname] intValue]];
        
        //查询数据
        FMResultSet *rsl = [db executeQuery:sql];
        
        //遍历结果集
        while ( [rsl next] ) {
            NSData* dat = [rsl dataForColumn:@"data"];
            
            if( dat != nil && ![dat isKindOfClass:[NSNull class]] )
            {
                findlocobj = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
            }
        }
        
        [itlock lock];
        [itlock signal];
        [itlock unlock];
        
    }];
    
    [itlock lock];
    [itlock wait];
    [itlock unlock];
    
    return findlocobj;
}

@end
@interface SResBase()


@end

SResBase* g_forShareClient = nil;

@implementation SResBase

+ (SResBase*)shareClient
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        g_forShareClient = SResBase.new;
        
    });
    return g_forShareClient;
}

- (id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self )
    {
        if( obj == nil )
        {
            self.msuccess = NO;
            self.mmsg = @"无效的数据";
        }
        else
            [self fetchIt:obj];
    }
    return self;
}

- (void)fetchIt:(NSDictionary *)obj
{
    _mcode = [[obj objectForKeyMy:@"status"] intValue];
    _msuccess = _mcode == 1;
    self.mmsg = [obj objectForKeyMy:@"error"];
    if( self.mmsg == nil )
    {
        if( _msuccess )
            self.mmsg = @"操作成功";
        else
            self.mmsg = @"操作失败";
    }
    
    self.mdata = obj;
}

+(SResBase*)infoWithString:(NSString*)str
{
    SResBase* retobj = SResBase.new;
    retobj.mcode = 0;
    retobj.msuccess = NO;
    retobj.mmsg = str;
    return retobj;
}

+(SResBase*)infoWithOKString:(NSString*)msg
{
    SResBase* retobj = SResBase.new;
    retobj.mcode = 1;
    retobj.msuccess = YES;
    retobj.mmsg = msg;
    return retobj;
}

+ (void)postReq:(NSString*)method ctl:(NSString*)ctl parm:(NSDictionary*)param block:(void(^)(SResBase* resb))block
{
    [[NetHttpsManager manager] postMethod:method ctl:ctl param:param successBlock:^(NSDictionary *jsonData) {
        
        if( block )
            block( [[SResBase alloc]initWithObj:jsonData] );
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"req failed:%@", error);
        block([SResBase infoWithString:@"网络请求失败"]);
        
    }];
}

+ (NSDictionary*)postReqSync:(NSString *)method ctl:(NSString *)ctl parm:(NSDictionary *)param
{
    NSDictionary *tmpDict = [[NetHttpsManager manager] postSynchMehtod:method ctl:ctl param:param];
    return tmpDict;
}

@end


@implementation czModel

+ (void)getCZInfo:(void (^)(SResBase* resb,int yue,int rate, NSArray* czItems, NSArray* payItmes))block
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:VersionNum forKey:@"sdk_version_name"];
    
    [SResBase postReq:@"recharge" ctl:@"pay" parm:parmDict block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            NSArray* c = [resb.mdata objectForKeyMy:@"rule_list"];
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in c )
            {
                [t addObject: [[czModel alloc]initWithObj:one]];
            }
            int k = [[resb.mdata objectForKeyMy:@"show_other"] intValue];
            if( k == 1 )
            {
                czModel * input =   czModel.new;
                
                input.mBI = YES;
                [t addObject:input];
            }
            
            NSArray* p = [resb.mdata objectForKeyMy:@"pay_list"];
            NSMutableArray* tt = NSMutableArray.new;
            for ( NSDictionary* one in p ) {
                [tt addObject: [[payMethodModel alloc]initWithObj:one]];
            }
            //余额
            int yue = [[resb.mdata objectForKeyMy:@"diamonds"] intValue];
            //充值金额与钻石的换算比率
            int rate = [[resb.mdata objectForKeyMy:@"rate"] intValue];
            
            block( resb, yue,rate,t,tt);
        }
        else
        {
            block( resb ,0,0,nil,nil);
        }
    }];
}

@end

@implementation payMethodModel

- (void)payIt:(czModel*)mode block:(void(^)(SResBase* resb))block
{
    NSDictionary* param;
    if( mode.mBI )
    {
        param = @{@"pay_id":@(self.mId),@"money":@(mode.mMoney)};
    }
    else
    {
        param = @{@"pay_id":@(self.mId),@"rule_id":@(mode.mId)};
    }
    
    [SResBase postReq:@"pay" ctl:@"pay" parm:param block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            NSString* paycode = [[[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"sdk_code"] objectForKeyMy:@"pay_sdk_type"];
            if( [paycode isEqualToString:@"alipay"] )
            {
                NSString* payinfo = [[[[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"sdk_code"] objectForKeyMy:@"config"] objectForKeyMy:@"order_spec"];
                
                NSString* sign = [[[[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"sdk_code"] objectForKeyMy:@"config"] objectForKeyMy:@"sign"];
                
                
                NSString* sign_type = [[[[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"sdk_code"] objectForKeyMy:@"config"] objectForKeyMy:@"sign_type"];
                
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                         payinfo, sign, sign_type];
                
                [self alipay:orderString block:block];
            }
            else if ([paycode isEqualToString:@"wxpay"])
            {
                NSDictionary* diccfg = [[[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"config"] objectForKeyMy:@"ios"];
                [self wxpay:diccfg block:block];
            }
            else if ([paycode isEqualToString:@"iappay"])
            {
                self.httpManager = [NetHttpsManager manager];
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                NSDictionary* diccfg = [[resb.mdata objectForKeyMy:@"pay"] objectForKeyMy:@"sdk_code"];
                NSDictionary *config = diccfg[@"config"];
                self.pro_id = config[@"product_id"];
                if ([SKPaymentQueue canMakePayments]) {
                    [self getProductInfowithprotectId:self.pro_id block:block];
                } else {
                    [FanweMessage alert:@"您已禁止应用内付费购买商品"];
                }
            }
            else
            {
                block( [SResBase infoWithString:@"服务器返回不支持的支付方式"]);
            }
        }
        else
        {
            block( resb );
        }
    }];
}

#pragma mark -- 苹果内购服务
/**
 苹果内购服务
 
 @param proId ProductId事先在itunesConnect中添加好的，已存在的付费项目,否则查询会失败。
 @param block 回调
 */
- (void)getProductInfowithprotectId:(NSString *)proId  block:(void(^)(SResBase* resb))block
{
    //    [[FWHUDHelper sharedInstance] syncLoading:@"正在请求Itunes Store请等待"];
    self.block = block;
    NSMutableArray *proArr = [NSMutableArray new];
    [proArr addObject:proId];
    NSSet * set = [NSSet setWithArray:proArr];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    NSLog(@"%@",set);
    NSLog(@"请求开始请等待...");
}

#pragma mark - 以上查询的回调函数－－－－－－－
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    NSLog(@"%@",myProduct);
    if (myProduct.count == 0)
    {
        SResBase* retobj = nil;
        retobj.msuccess = YES;
        retobj = [[SResBase alloc]init];
        retobj.msuccess = YES;
        retobj.mmsg = @"无法获取产品信息，购买失败";
        retobj.mcode = 1;
        self.block(retobj);
        //[FanweMessage alert:@"无法获取产品信息，购买失败。"];
        return;
    }
    else
    {
        NSLog(@"productID:%@", response.invalidProductIdentifiers);
        NSLog(@"产品付费数量:%lu",(unsigned long)[myProduct count]);
        SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark - others SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"已经购买过该产品");
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData *data = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    if ([productIdentifier length] > 0)
    {
        [self shoppingValidation:base64String block: self.block];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

#pragma mark -- 向自己的服务器验证购买凭证01
- (void)shoppingValidation : (NSString *)base64Str  block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:@"pay" forKey:@"ctl"];
    [dict setObject:@"iappay" forKey:@"act"];
    NSString *userid = [IMAPlatform sharedInstance].host.imUserId;
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:base64Str forKey:@"receipt-data"];
    [self.httpManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        
        SResBase* retobj = nil;
        retobj.msuccess = YES;
        retobj = [[SResBase alloc]init];
        retobj.msuccess = YES;
        retobj.mmsg = @"支付成功";
        retobj.mcode = 1;
        block(retobj);
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"购买失败");
    }
    else
    {
        SResBase* retobj = nil;
        retobj.msuccess = YES;
        retobj = [[SResBase alloc]init];
        retobj.msuccess = YES;
        retobj.mmsg = @"您已取消交易";
        self.block(retobj);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)wxpay:(NSDictionary*)wxpaycfg block:(void(^)(SResBase* resb))block
{
    [SResBase shareClient].mg_pay_block = ^(SResBase* resb){
        
        block( resb );
        
        [SResBase shareClient].mg_pay_block = nil;
        
    };
    
    //微信支付
    NSDictionary *configDic = wxpaycfg;
    Mwxpay * wxmodel =[Mwxpay mj_objectWithKeyValues: configDic];
    PayReq* req = [[PayReq alloc] init];
    req.openID = wxmodel.appid;
    req.partnerId = wxmodel.partnerid;
    req.prepayId = wxmodel.prepayid;
    req.nonceStr = wxmodel.noncestr;
    req.timeStamp = [wxmodel.timestamp intValue];
    req.package = wxmodel.package;
    req.sign = wxmodel.sign;
    if( ![WXApi sendReq:req] )
    {
        [SResBase shareClient].mg_pay_block = nil;
    }
}

- (void)alipay:(NSString*)payinfo  block:(void(^)(SResBase* resb))block
{
    
}

@end

NSMutableArray* g_historysearch = nil;

@implementation musiceModel
{
    id          _context;
    BOOL        _downloading;//0 普通,1下载中..
    NSProgress* _progress;
}

#define DIR_MUSIC   @"music"
#define T_MUSIC_NAME @"music_list"

- (void)dealloc
{
    if( _downloading )
    {
        NSLog(@"music cancel ...");
        [_progress cancel];
    }
    else
    {
        
    }
}

/**
 完整的音乐文件地址
 
 @return 返回值
 */
- (NSString *)getFullFilePath
{
    NSString *str = [NSString stringWithFormat:@"/Documents/%@/%@",DIR_MUSIC,self.mFilePath];
    if (str && ![str isEqualToString:@""]) {
        return [NSHomeDirectory() stringByAppendingString:str];
    }
    return NSHomeDirectory();
}

- (NSString*)getTimeLongStr
{
    if( _mTime_len == 0 ) return @"";
    return [NSString stringWithFormat:@"%02d:%02d", _mTime_len/60,_mTime_len%60];
}

// 从我的歌曲列表里面删除这个
- (void)delThis:(void(^)(SResBase* resb))block
{
    [SResBase postReq:@"del_music" ctl:@"music" parm:@{@"audio_id":_mAudio_id} block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            if( _downloading )
            {//如果正在下载就停止
                self.mmDelegate = nil;
                _context = nil;
                [_progress cancel];
            }
            [self removeMuiscFile:block];
        }
        else
            block( resb );
    }];
}

// 清除本地歌曲缓存,不会删除列表,情理缓存的时候使用
+ (BOOL)clearLocalSave
{
    //删除数据库
    [SAutoEx clearDataForKey:T_MUSIC_NAME block:nil];
    
    //删除本地文件
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:DIR_MUSIC isDirectory:YES];
    
    return [[NSFileManager defaultManager]removeItemAtURL:documentsDirectoryURL error:nil];
}

//返回本地文件的总大小,,in byte
+ (int)getLocatDataSize
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:DIR_MUSIC isDirectory:YES];
    if (![manager fileExistsAtPath:[documentsDirectoryURL path]]) return 0;
    
    NSArray* all = [manager contentsOfDirectoryAtPath:[documentsDirectoryURL path] error:nil];
    
    int filesize = 0;
    for ( NSString* one in all )
    {
        filesize += [[[manager attributesOfItemAtPath:[[documentsDirectoryURL URLByAppendingPathComponent:one] path] error:nil] objectForKey:NSFileSize] intValue];
    }
    return filesize;
}

- (void)fetchBeforDownload:(void(^)(SResBase* resb))block
{
    [SResBase postReq:@"downurl"  ctl:@"music" parm:@{@"audio_id":self.mAudio_id} block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            if( self.mAudio_link.length == 0 )
                self.mAudio_link = [[resb.mdata objectForKeyMy:@"audio"] objectForKeyMy:@"audio_link"];
            if( self.mLrc_content.length == 0 )
                self.mLrc_content = [[resb.mdata objectForKeyMy:@"audio"] objectForKeyMy:@"lrc_content"];
        }
        block( resb );
        
    }];
    
}
- (void)startDonwLoad:(id)context
{
    if( _downloading ) return;
    _downloading = YES;
    _context = context;
    self.mmDownloadInfo = @"下载中";
    self.mmFileStatus = 2;
    [self callback];
    
    [self fetchBeforDownload:^(SResBase *resb) {
        
        [self realDownLoadFile];
        
    }];
}

- (void)realDownLoadFile
{
#define test_down 0
    
#if test_down
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        _progress = [NSProgress progressWithTotalUnitCount:100];
        
        [_progress addObserver:self
                    forKeyPath:@"fractionCompleted"
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
        
        for ( int j = 0; j < 100; j++) {
            _progress.completedUnitCount = j;
            [NSThread sleepForTimeInterval:1];
        }
        
        self.mFilePath = @"test";
        [self saveMuiscFile];
        
    });
    
#else
    
    if( self.mAudio_link.length == 0 )
    {
        [self stopDownLoad:@"下载地址错误" bsuccess:NO];
        return;
    }
    
    //默认会话模式
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.completionQueue = dispatch_get_global_queue(0, 0);//回掉不要在主线程执行,方便继续下载歌词
    
    NSURL *URL = [NSURL URLWithString:self.mAudio_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSLog(@"~~~~~~~~~~~~~~音乐下载地址:%@",self.mAudio_link);
    NSLog(@"eqew=============id ========%@",self.mAudio_id)
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度 监听
        if( _progress == nil )
        {
            _progress = downloadProgress;
            
            [_progress addObserver:self
                        forKeyPath:@"fractionCompleted"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        }
        
    }destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        //DIR_MUSIC   @"music"      下载文件存 的路径
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:DIR_MUSIC isDirectory:YES];
        
        NSError* errror = nil;
        
        //目录不存在,并且又创建失败...
        if(![[NSFileManager defaultManager]fileExistsAtPath:[documentsDirectoryURL path]] &&
           ![[NSFileManager defaultManager] createDirectoryAtURL:documentsDirectoryURL withIntermediateDirectories:YES attributes:nil error:&errror]
           )
        {
            
            return nil;
        }
        else
        {
            NSString *musicIDStr;
            if ([self.mAudio_id containsString:@"&"]) {
                musicIDStr = [[self.mAudio_id componentsSeparatedByString:@"&"] firstObject];
            }else{
                musicIDStr = self.mAudio_id ;
            }
            NSString* sss = [NSString stringWithFormat:@"music_%@_%@.mp3",[IMAPlatform sharedInstance].host.imUserId,musicIDStr];
            return [documentsDirectoryURL URLByAppendingPathComponent:sss];
        }
        
    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(filePath)
        {
            // lastPathComponent 获取文件路径
            self.mFilePath = [filePath lastPathComponent];
            //保存
            [self saveMuiscFile];
        }
        else
        {
            [self delThis:^(SResBase *resb)
            {
            }];
            //            [self stopDownLoad:@"下载文件歌曲失败" bsuccess:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                kNotifPost(@"musicDownFileFailure", @{@"musicName":self.mAudio_name});
            });
            self.mFilePath = @"";
        }
        
        [_progress removeObserver:self forKeyPath:@"fractionCompleted"];
        _progress = nil;
    }];
    
    [downloadTask resume];
#endif
    
}

//完整的音乐文件地址
- (NSString*)getFullFilePath:(NSString *)filePathStr
{
    NSString *str = [NSString stringWithFormat:@"/Documents/%@/%@",@"music",filePathStr];
    if (str && ![str isEqualToString:@""])
    {
        return [NSHomeDirectory() stringByAppendingString:str];
    }
    return NSHomeDirectory();
}

- (NSInteger)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)removeMuiscFile:(void(^)(SResBase* resb))block
{
    //删除文件
    [[NSFileManager defaultManager]removeItemAtPath:[self getFullFilePath] error:nil];
    
    //删除数据库记录
    [SResBase removeListData:@[self] idname:@"mAudio_id" forKey:T_MUSIC_NAME block:block];
}

- (void)addThisToMyList:(void(^)(SResBase* resb))block
{
    NSDictionary* param = @{
                            @"audio_link":self.mAudio_link?self.mAudio_link:@"",
                            @"lrc_content":self.mLrc_content?self.mLrc_content:@"",
                            @"audio_name":self.mAudio_name?self.mAudio_name:@"",
                            @"artist_name":self.mArtist_name?self.mArtist_name:@"",
                            @"time_len":@(self.mTime_len),
                            @"audio_id":self.mAudio_id    };
    [SResBase postReq:@"add_music" ctl:@"music" parm:param block:block];
}

- (void)saveMuiscFile
{
#if test_down
    
    [self stopDownLoad:@"下载完成" bsuccess:YES];
    
#else
    self.mmFileStatus = 1;//1 已经下载
    [SResBase addListData:@[self] idname:@"mAudio_id" forKey:T_MUSIC_NAME block:^(SResBase *resb) {
        
        if( !resb.msuccess )
        {
            [self stopDownLoad:@"保存歌曲失败" bsuccess:NO];
        }
        else
            [self stopDownLoad:@"下载完成" bsuccess:YES];
        
    }];
#endif
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context
{
    if(  object == _progress )
    {
        _mmPecent = _progress.fractionCompleted * 100;
        [self callback];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)callback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if( self.mmDelegate && [self.mmDelegate respondsToSelector:@selector(musicDownloading:context:needstop:)] )
        {
            BOOL needstop = NO;
            [self.mmDelegate musicDownloading:self context:_context needstop:&needstop];
            if( needstop && _downloading )
            {
                [_progress cancel];
            }
        }
    });
}

- (void)stopDownLoad:(NSString*)str bsuccess:(BOOL)bsuccess
{
    if( bsuccess )
        [self addThisToMyList:nil];//下载完成就添加一次
    self.mmDownloadInfo = str;
    self.mmFileStatus = bsuccess?1:0;
    [self callback];
    _downloading = NO;
}

#define KEY_HIS @"music_search"
#define MAX_KEYS 20
+ (NSArray*)getSearchHistory
{
    if( g_historysearch == nil )
    {
        g_historysearch = NSMutableArray.new;
        NSArray* t = [SAutoEx loadDataWithKey:KEY_HIS];
        if( t )
            [g_historysearch addObjectsFromArray: t];
    }
    return g_historysearch;
}

+ (void)addHistory:(NSString*)key
{
    if( key == nil )    return;
    
    NSMutableArray* ta = (NSMutableArray*) [self getSearchHistory];
    
    NSInteger i = [ta indexOfObject:key];
    if( i != NSNotFound  )
    {//如果有搜索过这个,就提前,表明最近搜索
        [ta removeObjectAtIndex:i];
        [ta insertObject:key atIndex:0];
    }
    else
    {//如果没有,就加入
        if( ta.count > MAX_KEYS )
            [ta removeLastObject];
        [ta insertObject:key atIndex:0];
    }
    
    [SAutoEx saveData:ta forkey:KEY_HIS];
}

+ (void)cleanHistory
{
    [g_historysearch removeAllObjects];
    [SAutoEx saveData:g_historysearch forkey:KEY_HIS];
}

+ (void)deleteHistory:(NSInteger )indexPath
{
    [g_historysearch removeObjectAtIndex:indexPath ];
    [SAutoEx saveData:g_historysearch forkey:KEY_HIS];
}

//获取我的音乐列表
+ (void)getMyMusicList:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block
{
#if test_down
    
    NSMutableArray* t = NSMutableArray.new;
    musiceModel*bbbb = musiceModel.new;
    
    bbbb.mAudio_name = @"什么歌曲";
    bbbb.mArtist_name = @"什么作者";
    bbbb.mTime_len = 75;
    bbbb.mmFileStatus = 1;
    [t addObject:bbbb];
    
    musiceModel*aaaa = musiceModel.new;
    aaaa.mAudio_name = @"什么歌曲2";
    aaaa.mArtist_name = @"什么作者2";
    aaaa.mTime_len = 45;
    aaaa.mmFileStatus = 0;
    
    [t addObject:aaaa];
    
    block( [SResBase infoWithOKString:@"加载成功"] , t);
    
#else
    
    [SResBase postReq:@"user_music" ctl:@"music" parm:@{@"p":@(page)} block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            NSArray* ta = [resb.mdata objectForKeyMy:@"list"];
            for (NSDictionary* one in ta ) {
                [t addObject: [[musiceModel alloc]initWithObj:one]];
            }
            
            [musiceModel fetchFuckDownloadURL:t surehave:NO block:block];
            
        }
        else block(  resb , nil );
        
    }];
    
#endif

}

//搜索歌曲
+ (void)searchMuisc:(NSString*)keywords page:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block
{
    [self addHistory:keywords];
    [SResBase postReq:@"search" ctl:@"music" parm:@{ @"keyword":keywords,@"p":@(page)} block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            NSArray* a = [resb.mdata objectForKeyMy:@"list"];
            NSMutableArray* t = NSMutableArray.new;
            
            for ( NSDictionary* one in a ) {
                
                [t addObject: [[musiceModel alloc]initWithObj:one]];
            }
            
            [musiceModel fetchFuckDownloadURL:t surehave:NO block:block];
        }
        else
        {
            block( resb, nil);
        }
        
    }];
}

//所有返回的列表数据,都经过这个函数,做些处理,,比如下载她的地址,匹配是否本地有,等等,
//surehave 表示是否确定本地有,如果不确定,讲会进行本地搜索匹配
+ (void)fetchFuckDownloadURL:(NSArray*)allmodes surehave:(BOOL)surehave block:(void(^)(SResBase* resb, NSArray* all ))block
{
    dispatch_async( dispatch_get_global_queue(0, 0), ^{
        
        for ( int j = 0 ; j < allmodes.count; j ++ )
        {
            musiceModel* one = allmodes[j];
            
            //如果每次访问网络,非常卡,这个只有下载歌曲的时候再做吧,,,
            if((NO) && (one.mAudio_link.length == 0 || one.mLrc_content.length == 0) )
            {
                //@"downurl"
                NSDictionary* ret = [SResBase postReqSync:@"downurl" ctl:@"music" parm:@{@"audio_id":one.mAudio_id}];
                
                if( ret )
                {
                    SResBase* ttt = [[SResBase alloc]initWithObj:ret];
                    if( ttt .msuccess )
                    {
                        
                        if( one.mAudio_link.length == 0 )
                            one.mAudio_link = [[ttt.mdata objectForKeyMy:@"audio"] objectForKeyMy:@"audio_link"];
                        NSLog(@">>>>>>>>>>>>>>>%@",one.mAudio_link);
                        if( one.mLrc_content.length == 0 )
                            one.mLrc_content = [[ttt.mdata objectForKeyMy:@"audio"] objectForKeyMy:@"lrc_content"];
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            block( ttt , nil );
                            
                        });
                        return ;
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        block( [SResBase infoWithString:@"获取歌曲地址失败"] , nil );
                    });
                    return ;
                }
            }
            
            ///匹配本地是否有
            if( surehave )
                one.mmFileStatus = 1;
            else
            {//查找数据库,是否有这个歌曲
                musiceModel* locobj = [one haveThisObjInLocalForKey:T_MUSIC_NAME idname:@"mAudio_id"];
                if( locobj )
                {
                    one.mmFileStatus = 1;
                    one.mFilePath = locobj.mFilePath;
                    if( one.mLrc_content.length == 0 )
                        one.mLrc_content = locobj.mLrc_content;
                }
                else
                {
                    one.mmFileStatus = 0;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block( [SResBase infoWithOKString:@"获取歌曲成功"] , allmodes);
        });
    });
}

// 获取本地音乐
+ (void)getLocalMusic:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block
{
    [SResBase getListData:page forKey:T_MUSIC_NAME block:^(SResBase *resb, NSArray *all) {
        
        if( resb.msuccess )
        {
            [musiceModel fetchFuckDownloadURL:all surehave:YES block:block];
        }
        else
            block( resb ,all );
        
    }];
}


@end
