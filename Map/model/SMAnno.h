//
//  SMAnno.h
    
//
//  Created by lucifer on 15/8/3.
  
//

#import <Foundation/Foundation.h>

#import "SMIcon.h"

@interface SMAnno : NSObject
/**
 *  marker的id
 */
@property (nonatomic,copy)NSString *Lid;
/**
 *  marker的标题
 */
@property (nonatomic,copy)NSString *title;

/**
 *  marker的x坐标
 */
@property (nonatomic,assign)CGFloat x;

/**
 *  marker的y坐标
 */
@property (nonatomic,assign)CGFloat y;

/**
 *  marker点图片
 */
@property (nonatomic,strong)SMIcon *icon;



/**
 *  marker点得zan数
 */
@property(nonatomic,copy)NSString *zans;
/**
 *  marker点查看数
 */
@property(nonatomic,copy)NSString *rating;

/**
 *  marker点详情页图片组
 */
@property (nonatomic,strong) NSArray *img;

/**
 *  marker点详情页数据组
 */
@property(nonatomic,strong)NSArray *attributes;

/**
 *  创建者ID（需要转换）
 */
@property(nonatomic,copy)NSString *creator_id;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *creator;

// line的坐标"116.581061,39.776023"
@property(nonatomic,copy)NSString *bdxy;



@property(nonatomic,copy)NSString *subTitle;
@end
