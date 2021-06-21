//
//  SMCreatMap.m
    
//
//  Created by lucifer on 15/8/11.
  
//

#import "SMCreatMap.h"
#import "NSDate+NJ.h"

@implementation SMCreatMap
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Lid" : @"id",@"mapDescription":@"description"};
}

-(NSString *)created_at
{
    // 1.将服务器返回的字符串转换为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 指定服务器返回时间的格式
    // Mon Feb 02 18:15:20 +0800 2015
    //    formatter.dateFormat = @"EEE MMM  dd HH:mm:ss Z yyyy";
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdDate = [formatter dateFromString:_created_at];
    
    // 2.判断服务器返回的时间, 根据时间返回对应的字符串
    if ([createdDate isThisYear]) {
        // 今年
        if ([createdDate isToday]) {
            
            // 是今天
            // 取出服务器返回时间的时分秒
            NSDateComponents *comps = [createdDate deltaWithNow];
            if (comps.hour >= 1) {
                // 其它小时
                return [NSString stringWithFormat:@"%tu小时前", comps.hour];
            }else if (comps.minute > 1)
            {
                // 1小时以内
                return [NSString stringWithFormat:@"%tu分钟以前", comps.minute];
            }else
            {
                //刚刚
                return @"刚刚";
            }
            
        }else if ([createdDate isYesterday])
        {
            // 昨天
            formatter.dateFormat = @"昨天 HH时:mm分";
            return [formatter stringFromDate:createdDate];
        }else
        {
            // 其它天
            formatter.dateFormat = @"MM月dd日  HH时:mm分";
            return [formatter stringFromDate:createdDate];
        }
    }else
    {
        // 非今年
        formatter.dateFormat = @"yy年MM月dd日 HH时:mm分";
        return [formatter stringFromDate:createdDate];
    }

}

@end
