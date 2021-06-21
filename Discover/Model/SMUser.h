//
//  SMUser.h
    
//
//  Created by lucifer on 15/7/20.
  
//

#import <Foundation/Foundation.h>

@interface SMUser : NSObject

//@property (nonatomic, copy) NSString *avatar;
//
//@property (nonatomic, assign) NSInteger followers_count;
//
//@property (nonatomic, assign) NSInteger groups_count;
//
//@property (nonatomic, assign) NSInteger favorites_count;
//
//@property (nonatomic, assign) NSInteger replies_count;
//
//@property (nonatomic, copy) NSString *tagline;
//
@property (nonatomic, copy) NSString *user_id;
//
//@property (nonatomic, assign) NSInteger followings_count;
//
@property (nonatomic, copy) NSString *relationship;
//
//@property (nonatomic, assign) NSInteger messages_count;
//
//@property (nonatomic, copy) NSString *login;
//
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *login;
/**
 *  用户头像
 */
@property (nonatomic,copy) NSString *avatar;
/**
 *  个人介绍
 */
@property (nonatomic,copy) NSString *tagline;

//@property (nonatomic,assign)NSInteger *messages_count;
//
//@property (nonatomic,assign)NSInteger *replies_count;
//
//
@property (nonatomic,assign)NSInteger followers_count;
//
//
@property (nonatomic,assign)NSInteger followings_count;


@end
