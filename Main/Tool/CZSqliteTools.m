

#import "CZSqliteTools.h"
#import "FMDB.h"
#import "SMStatus.h"
#import "SMPicArrFire.h"

@implementation CZSqliteTools

+ (instancetype)shareSqliteTools
{
    static CZSqliteTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[CZSqliteTools alloc] init];
    });
    return tools;
}

static FMDatabase *_db;
+ (void)initialize
{
    // 1.获取数据库文件的地址
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"status.sqlite"];
    
                            
    // 创建数据库
  
     _db = [FMDatabase databaseWithPath:sqlitePath];
    if ([_db open]) {
//        SMLog(@"打开数据库成功");
        // 创建表
      BOOL success =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
        if (success) {
            SMLog(@"创建表成功");
        }else
        {
            SMLog(@"创建表失败");
        }
        
        // 创建表ad
        
        BOOL success1 =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS ad_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
        if (success1) {
//            SMLog(@"创建表成功");
        }else
        {
            SMLog(@"创建表失败");
        }
        
        // 创建表comu
        
        BOOL success2 =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS comu_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
        if (success2) {
//            SMLog(@"创建表成功");
        }else
        {
            SMLog(@"创建表失败");
        }

    }
}

//-(void)creat_t_status
//{
//    // 1.获取数据库文件的地址
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"status.sqlite"];
//    
//    
//    // 创建数据库
//    
//    _db = [FMDatabase databaseWithPath:sqlitePath];
//    if ([_db open]) {
//        SMLog(@"打开数据库成功");
//        // 创建表
//        BOOL success =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
//        if (success) {
//            SMLog(@"创建表成功");
//        }else
//        {
//            SMLog(@"创建表失败");
//        }
//
//}
//}
//
//-(void)creat_ad_status
//{
//    // 1.获取数据库文件的地址
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"status.sqlite"];
//    
//    
//    // 创建数据库
//    
//    _db = [FMDatabase databaseWithPath:sqlitePath];
//    if ([_db open]) {
//        // 创建表ad
//        
//        BOOL success1 =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS ad_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
//        if (success1) {
//            SMLog(@"创建表成功");
//        }else
//        {
//            SMLog(@"创建表失败");
//        }
//
//    }
//}
//
//-(void)creat_comu_status
//{
//    // 1.获取数据库文件的地址
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"status.sqlite"];
//    
//    
//    // 创建数据库
//    
//    _db = [FMDatabase databaseWithPath:sqlitePath];
//    if ([_db open]) {
//        // 创建表ad
//        
//        BOOL success2 =  [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS comu_status(id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, dict BLOB);"];
//        if (success2) {
//            SMLog(@"创建表成功");
//        }else
//        {
//            SMLog(@"创建表失败");
//        }
//
//        
//    }
//}


- (NSArray *)statusesWithParameters
{
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM t_status" ];
    
    // 2.从结果集中取出数据转换为模型存储到数组中
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        // 1.取出存储的二进制微博数据
        NSData *data = [set dataForColumn:@"dict"];
        // 2.将取出的二进制转换为字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        // 3.将字典转换为模型
        SMStatus *status = [SMStatus objectWithKeyValues:dict];
        [models addObject:status];
    }
    
    // 3.返回数组
    return models;
}
-(void)deleteDict
{
    [_db executeUpdate:@"DELETE FROM t_status"];
}
- (BOOL)insertDict:(NSDictionary *)dict
{
    // 1.将字典转换为二进制
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    // 2.取出当前微博对应的微博ID
//    NSString *idstr = dict[@"id"];
    // 3.取出当前登录用户的令牌
//    NSString *accessToken = [SMAccount accountFromSandbox].token;
    
    BOOL success = [_db executeUpdate:@"INSERT INTO t_status(dict) VALUES(?)", data];
    if (success) {
        return YES;
    }
    return NO;
}






-(void)deleteADdict
{
        [_db executeUpdate:@"DELETE FROM ad_status"];
}



- (BOOL)insertADDict:(NSDictionary *)dict
{
    // 1.将字典转换为二进制
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    // 2.取出当前微博对应的微博ID
//    NSString *idstr = dict[@"id"];
    // 3.取出当前登录用户的令牌
//    NSString *accessToken = [SMAccount accountFromSandbox].token;

      BOOL success = [_db executeUpdate:@"INSERT INTO ad_status(dict) VALUES(?)", data];
    
    
    
    if (success) {
        return YES;
    }
    return NO;
}



- (NSArray *)adFromDB
{
    FMResultSet *set = nil;

    
    set = [_db executeQuery:@"SELECT * FROM ad_status"];
    
    // 2.从结果集中取出数据转换为模型存储到数组中
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        // 1.取出存储的二进制微博数据
        NSData *data = [set dataForColumn:@"dict"];
        // 2.将取出的二进制转换为字典
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        // 3.将字典转换为模型
        SMPicArrFire *status = [SMPicArrFire objectWithKeyValues:dict];
        [models addObject:status];
    }
    
    // 3.返回数组
    return models;

}

-(void)deleteComuDict
{
    [_db executeUpdate:@"DELETE FROM comu_status"];
}
- (BOOL)insertComuDict:(NSDictionary *)dict
{
    // 1.将字典转换为二进制
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    // 2.取出当前微博对应的微博ID
    //    NSString *idstr = dict[@"id"];
    // 3.取出当前登录用户的令牌
    //    NSString *accessToken = [SMAccount accountFromSandbox].token;
    
    
    
    BOOL success = [_db executeUpdate:@"INSERT INTO comu_status(dict) VALUES(?)", data];
    if (success) {
        return YES;
    }
    return NO;
}


- (NSArray *)statusesFromComu
{
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"status.sqlite"];
//    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqlitePath];
//       NSMutableArray *models = [NSMutableArray array];
//    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        FMResultSet *set = nil;
//        
//        set = [_db executeQuery:@"SELECT * FROM comu_status" ];
//        
//        // 2.从结果集中取出数据转换为模型存储到数组中
//     
//        while ([set next]) {
//            // 1.取出存储的二进制微博数据
//            NSData *data = [set dataForColumn:@"dict"];
//            // 2.将取出的二进制转换为字典
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
//            // 3.将字典转换为模型
//            SMStatus *status = [SMStatus objectWithKeyValues:dict];
//            [models addObject:status];
//        }
//
//    }];
//    
    
    FMResultSet *set = nil;
    
    set = [_db executeQuery:@"SELECT * FROM comu_status" ];

    // 2.从结果集中取出数据转换为模型存储到数组中
    NSMutableArray *models = [NSMutableArray array];
    while ([set next]) {
        // 1.取出存储的二进制微博数据
        NSData *data = [set dataForColumn:@"dict"];
        // 2.将取出的二进制转换为字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        // 3.将字典转换为模型
        SMStatus *status = [SMStatus objectWithKeyValues:dict];
        [models addObject:status];
    }
    
    // 3.返回数组
    return models;
}


@end
