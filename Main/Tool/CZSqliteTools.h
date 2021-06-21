
#import <Foundation/Foundation.h>


@interface CZSqliteTools : NSObject

+ (instancetype)shareSqliteTools;

/**
 *  存储微博数据(包含微博和微博对应的用户)
 *
 *  @param dict 需要存储的微博数据
 *
 *  @return 是否存储成功
 */

//-(void)creat_t_status;
//-(void)creat_comu_status;
//-(void)creat_ad_status;
- (BOOL)insertDict:(NSDictionary *)dict;
/**
 *  获取微博数据
 *
 *  @param request 请求参数
 *
 *  @return 请求到得结果
 */
- (NSArray *)statusesWithParameters;

-(void)deleteDict;

//广告
- (NSArray *)adFromDB;

-(void)deleteADdict;

- (BOOL)insertADDict:(NSDictionary *)dict;
//社区最新
-(void)deleteComuDict;

- (BOOL)insertComuDict:(NSDictionary *)dict;

- (NSArray *)statusesFromComu;
@end
