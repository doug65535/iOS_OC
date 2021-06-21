//
//  SMStatus.h
    
//
//  Created by lucifer on 15/7/9.
  
//

#import <Foundation/Foundation.h>
#import "SMMap.h"
#import "SMUser.h"
#import "SMPictures.h"
@interface SMStatus : NSObject

@property (nonatomic,copy)NSString *Lid;


@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *address;


@property (nonatomic,strong) SMUser *user;

@property (nonatomic,copy) NSString *snapshot;

@property (nonatomic,strong)SMMap *map;



@property (nonatomic, strong)NSArray *pictures;

@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *last_actived_at;

@property (nonatomic,strong)NSArray *tags;

/**
 *  回复数
 */
@property (nonatomic,copy) NSString *replies_count;
/**
 *  收藏数
 */
@property (nonatomic,copy) NSString *favors_count;

/**
 *  点赞数
 */
@property (nonatomic,copy) NSString *likes_count;
/**
 *  是否收藏
 */
@property (nonatomic,getter=has_favored) BOOL has_favored;
/**
 *  是否点赞
 */
@property (nonatomic,getter=has_liked) BOOL has_liked;



- (CGFloat)cellHeightWithImageHeight:(NSString *)imageHeight andImageWidth:(NSNumber *)imageWidth;



@end



