//
//  DockMenuView.m
//  abcd
//
//  Created by leonshi on 6/20/14.
//  Copyright (c) 2014 leonshi. All rights reserved.
//

#import "DockMenuView.h"

@implementation DockMenuView
@synthesize mDockMenuItemDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mDockMenuItemArray  = [[NSMutableArray alloc]init];
    }
    return self;
}
//记住 当用SB 时候要加上此条
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        mDockMenuItemArray  = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) setMenuItemData:(NSMutableArray*) array
{
    if ([mDockMenuItemArray count]>0) {
        [mDockMenuItemArray removeAllObjects];
    }
    [mDockMenuItemArray addObjectsFromArray:array];
    
    [self addMenuItemViews];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor grayColor]CGColor];
}

-(void) addMenuItemViews
{
    int count = (int)[mDockMenuItemArray count];
    int itemWidth = kWidth/count;
    int itemHeight = self.frame.size.height;
    for (int i=0; i<count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, itemHeight)];
        [btn setTitle:[mDockMenuItemArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitle:[mDockMenuItemArray objectAtIndex:i] forState:UIControlStateHighlighted];
        [btn setTag:K_MENUITEM_DEFAULT+i];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(onMenuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i < count -1) {
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width, 0, 0.5, itemHeight)];
            [line setBackgroundColor:[UIColor grayColor]];
            [self addSubview:line];
            
        }
    }
}

-(void) onMenuItemClick:(id)sender
{

    [self changeMenuItemState:(int)((UIButton*)sender).tag];
    if (mDockMenuItemDelegate != nil) {
        [mDockMenuItemDelegate onDockMenuItemClick:sender];
    }
}

-(void) changeMenuItemState:(int) tag
{
    NSArray *viewArray =[[NSArray alloc]initWithArray:[self subviews]];
    int viewCount = (int)[viewArray count];
    for (int i=0; i<viewCount; i++) {
        if ([[viewArray objectAtIndex:i] isKindOfClass:[UIButton class]]) {
            UIButton *subView = (UIButton*) [viewArray objectAtIndex:i];
            if (subView.tag == tag) {
                [subView setTitleColor:[UIColor colorWithRed:1 green:136/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
            }
            else
            {
                [subView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            
        }
    }
    
}
@end
