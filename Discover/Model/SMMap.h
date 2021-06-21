//
//  SMMap.h
    
//
//  Created by lucifer on 15/7/9.
  
//

#import <Foundation/Foundation.h>

@interface SMMap : NSObject
/**
 *  地图id
 */
@property (nonatomic,copy) NSString *Lid;


/**
 *  地图名称
 */
@property (nonatomic,copy) NSString *title;

/**
 *  地图图片
 */
@property (nonatomic,copy) NSString *snapshot;

/**
 *  地图编号
 */
@property(nonatomic,copy) NSString *map_id;

/**
 *  地图作者名
 */
@property(nonatomic,copy)NSString *creator;


/**
 *  创作时间
 */
@property(nonatomic,copy)NSString *map_created_at;


/**
 *  地图类型
 */
@property(nonatomic,copy)NSString *app;


@end
