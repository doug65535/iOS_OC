//
//  SMCreatMap.h
    
//
//  Created by lucifer on 15/8/11.
  
//

#import <Foundation/Foundation.h>

#import "SMLabelSettings.h"

@interface SMCreatMap : NSObject

/**
 *  地图类型
 */
@property (nonatomic,copy)NSString *app_name;
/**
 *  地图分类
 */
@property (nonatomic,copy)NSString *category;
/**
 *  地图中心点
 */
@property (nonatomic,copy)NSString *center;
/**
 *  创建时间
 */
@property (nonatomic,copy)NSString *created_at;
/**
 *  编辑权限
 */

//EditStr = @"owner";
//}else{
//    EditStr = @"public";

// group
//}       @"group"
//
//NSString *LookStr = [[NSString alloc]init];
//if (self.LookOwner.on) {
//    LookStr = @"pri";
//}else if (self.LookPub.on){
//    LookStr = @"pub";
//}else {
//    LookStr = @"pas";
@property (nonatomic,copy)NSString *edit_permission;
/**
 *  群组编号
 */
@property (nonatomic,copy)NSString *group_id;
/**
 *  缩放等级
 */
@property (nonatomic,copy)NSString *level;
/**
 *  赞数
 */
@property (nonatomic,copy)NSString *like;
/**
 *  查看权限
 */
@property (nonatomic,copy)NSString *permission;
/**
 *  分享时地图的url
 */
@property (nonatomic,copy)NSString *shareimageURL;
/**
 *  缩略图Url
 */
@property (nonatomic,copy)NSString *snapshotURL;
/**
 *  地图标题
 */
@property (nonatomic,copy)NSString *title;

/**
 *  用户id
 */
@property (nonatomic,copy)NSString *user_id;


// 用户

@property(nonatomic,copy)NSString *user;
/**
 *  地图ID
 */
@property (nonatomic,copy)NSString *Lid;

/**
 *  地图查看次数
 */
@property (nonatomic,copy)NSString *view_count;

/**
 *   控制标签显示的字段 是否初始在maker点上显示文字
 */
@property (nonatomic,strong)SMLabelSettings *labelSettings;

/**
 *  控制标签显示的字段 如果有值，所有maker点都变成一样的此字段里的内容
 */
@property(nonatomic,copy)NSString *title_key;

/**
 *  地图详情上的标签
 */
@property (nonatomic,strong)NSArray *tag;
/**
 *  地图描述
 */
@property(nonatomic,copy)NSString *mapDescription;



@end
