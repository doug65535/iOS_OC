//
//  SMAnnoDetail.m
    
//
//  Created by lucifer on 15/8/14.
  
//

#import "SMAnnoDetail.h"
#import "SMAttributes.h"
#import "SMImg.h"
@implementation SMAnnoDetail



+ (NSDictionary *)objectClassInArray
{
    return @{@"marker_attributes":[SMAttributes class],@"img":[SMImg class]};
}




+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Lid" : @"id"};
}



@end
