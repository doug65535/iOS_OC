//
//  SMAccount.h
    
//
//  Created by lucifer on 15/7/14.
  
//

#import <Foundation/Foundation.h>
#import "SMAuths.h"



@interface SMAccount : NSObject
//
//@property (nonatomic,strong)SMUser *user;
@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *user_id;


@property (nonatomic,copy) NSString *login;

@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *tagline;
//@property (nonatomic,copy) NSArray  *auths;

@property (nonatomic,strong)NSArray *groups;



//@property(nonatomic,copy)NSString *user_id;
//@property(nonatomic,copy)NSString *login;
//@property(nonatomic,copy)NSString *email;
//@property(nonatomic,copy)NSString *token;
//@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *tel;
//@property(nonatomic,copy)NSString *tagline;
@property(nonatomic,copy)NSString *temp_access_token;
@property(nonatomic,copy)NSString *messages_count;
@property(nonatomic,copy)NSString *replies_count;
@property(nonatomic,copy)NSString *followers_count;
@property(nonatomic,copy)NSString *followings_count;
@property(nonatomic,copy)NSString *groups_count;

@property(nonatomic,strong)NSMutableArray *auths;

/**
 *  保存授权模型
 *
 *  @return 是否保存成功
 */
- (BOOL)save;
/**
 *  从沙河中价值授权模型
 *
 *  @return 授权模型
 */
+ (instancetype)accountFromSandbox;

@property(nonatomic,strong)NSMutableArray *historyArr;



@end
