//
//  CustomHeaderViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CustomHeaderViewController.h"
#import "SMPofileMapCreatVc.h"


#import "CustomHeader.h"

#import "SMMapPartIn.h"
#import "SMMapFover.h"

void *CusomHeaderInsetObserver = &CusomHeaderInsetObserver;

@interface CustomHeaderViewController ()

@end

@implementation CustomHeaderViewController

-(instancetype)init
{
    
    if (self.userModel) {
        SMPofileMapCreatVc *table = [[SMPofileMapCreatVc alloc] initWithNibName:@"SMPofileMapCreatVc" bundle:nil];
        table.userModel = self.userModel;
        self = [super initWithControllers:table,nil];
        if (self) {
            // your code
//            self.segmentMiniTopInset = 64;
        }
        return self;
    }else{
        
    SMPofileMapCreatVc *table = [[SMPofileMapCreatVc alloc] initWithNibName:@"SMPofileMapCreatVc" bundle:nil];
    SMMapPartIn *table1 = [[SMMapPartIn alloc]initWithNibName:@"SMMapPartIn" bundle:nil];
    
    SMMapFover *table2= [[SMMapFover alloc]initWithNibName:@"SMMapFover" bundle:nil];

    self = [super initWithControllers:table,table1,table2,nil];
    if (self) {
        // your code
//        self.segmentMiniTopInset = 64;
    }
    
    return self;
}
}



#pragma mark - override

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    CustomHeader *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:nil options:nil] lastObject];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地图";

    [self addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:CusomHeaderInsetObserver];
    

}


//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    self.title = @"地图";
//    if (context == CusomHeaderInsetObserver) {
//        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        
//        if (inset <= self.segmentMiniTopInset) {
//            self.title = @"地图";
////            self.headerView.imageView.image = self.blurImage;
//        }else{
//            self.title = @"地图";
////            self.pager.headerView.imageView.image = self.defaultImage;
//        }
//}
//}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentToInset"];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end
