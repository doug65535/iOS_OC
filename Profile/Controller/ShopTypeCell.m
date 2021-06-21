//
//  ShopTypeCell.m
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ShopTypeCell.h"



@interface ShopTypeCell() {
    UIView *_line1;
    UIView *_line2;
}
@end

@implementation ShopTypeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置字体
        self.textLabel.font = [UIFont systemFontOfSize:16];
//        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        // 标签不需要背景
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        // 选中一行时不需要背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置背景
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_main.png"]];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 添加分隔线
        CGFloat width = kWidth;
        CGFloat height = 1;
        UIView *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, kShopTypeCellHeight-3*height, width, height)];
        line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                                 green:198/255.0
                                                  blue:198/255.0
                                                 alpha:1.0];
        
        UIView *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, kShopTypeCellHeight-2*height, width, height)];
        line2.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:line1];
        [self.contentView addSubview:line2];
        _line1 = line1;
        _line2 = line2;
        
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kShopTypeCellHeight)];
        _coverView.alpha = 0;
        _coverView.backgroundColor = [UIColor blackColor];
        [self addSubview:_coverView];
    }
    return self;
}

#pragma mark 设置数据
//- (void)setShopType:(ShopType *)type isLast:(BOOL)isLast {
//    // 设置图片
//    self.imageView.image = [UIImage imageNamed:type.imageName];
//    // 设置类型名称
//    self.textLabel.text = type.name;
//    // 设置详细内容
//    NSMutableString *detail = [NSMutableString string];
//    [type.subClass enumerateObjectsUsingBlock:^(Shop *shop, NSUInteger idx, BOOL *stop) {
//        [detail appendFormat:@"%@/", shop.name];
//        
//        if (idx == 3) {
//            *stop = YES;
//        }
//    }];
//    // 删除最后一个/
//    [detail deleteCharactersInRange:[detail rangeOfString:@"/" options:NSBackwardsSearch]];
//    self.detailTextLabel.text = detail;
//    
//    [self showBottomLine:!isLast];
//}

- (void)showBottomLine:(BOOL)show {
//    _line2.hidden = !show;
//    _line1.hidden = !show;
}
@end
