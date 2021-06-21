//
//  ShopItem.m
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ShopItem.h"


#define kIconPercent 0.75
#define kIconMargin 0.05



@implementation ShopItem
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 图标
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 文字
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    
        
    }
    return self;
}

- (void)setShop:(BMKOLSearchRecord *)shop {
    _shop = shop;
    
    // 图标
    [self setImage:[UIImage imageNamed:@"lodingBlue"] forState:UIControlStateNormal];
    
    

    
    BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:shop.cityID];
    
    if (element.status == 1) {
        NSString *str = [NSString stringWithFormat:@"%@(%@)",shop.cityName,@"正在下载"];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1] forState:UIControlStateNormal];

    }else if (element.status == 2 )
    {
        NSString *str = [NSString stringWithFormat:@"%@(%@)",shop.cityName,@"等待下载"];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    }
    else if( element.status == 3)
    {
        NSString *str = [NSString stringWithFormat:@"%@(%@)",shop.cityName,@"已暂停"];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (element.status  == 4)
    {
        NSString *str = [NSString stringWithFormat:@"%@(%@)",shop.cityName,@"已下载"];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
     [self setImage:[UIImage imageNamed:@"lodingGray"] forState:UIControlStateNormal];
    }
    else
    {
  NSString *str = [NSString stringWithFormat:@"%@(%@)",shop.cityName,[self getDataSizeString:shop.size]];
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    // 文字
   
}

//#pragma mark 设置图标的位置
//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    CGFloat height = contentRect.size.height * (kIconPercent - kIconMargin);
//    
//    return CGRectMake(0, contentRect.size.height * kIconMargin, contentRect.size.width, height);
//}
////
////
////#pragma mark 设置文字的位置
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(0, contentRect.size.height * kIconPercent, contentRect.size.width, contentRect.size.height * (1 - kIconPercent));
//}


-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}
@end
