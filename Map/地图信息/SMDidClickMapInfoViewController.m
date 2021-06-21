//
//  SMDidClickMapInfoViewController.m
    
//
//  Created by lucifer on 15/8/3.
  
//

#import "SMDidClickMapInfoViewController.h"

#import "SMBiaoqianViewController.h"
#import "SMPutNewMapInfo.h"

@interface SMDidClickMapInfoViewController ()<SMPutNewMapInfoDelegate>
@property (strong, nonatomic) IBOutlet UILabel *creator;
@property (strong, nonatomic) IBOutlet UILabel *creat_time;
@property (strong, nonatomic) IBOutlet UILabel *map_id;
@property (strong, nonatomic) IBOutlet UILabel *tag;
@property (strong, nonatomic) IBOutlet UILabel *map_title;


@property (weak, nonatomic) IBOutlet UILabel *detailTitle;


@property (weak, nonatomic) IBOutlet UILabel *editPremission;
@property (weak, nonatomic) IBOutlet UILabel *lookPreMission;

@property (weak, nonatomic) IBOutlet UIButton *liulanBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContentHeight;

@end

@implementation SMDidClickMapInfoViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.viewContentWidth.constant = kWidth;
    self.viewContentHeight.constant = CGRectGetMaxY(self.likeBtn.frame )+64;
   
    self.title = @"地图信息";
    if (self.mapmodel) {
        self.creator.text = self.mapmodel.user;
        self.creat_time.text  = self.mapmodel.created_at;
        
        self.map_id.text = self.mapmodel.Lid;
        
        if (self.mapmodel.mapDescription) {
            self.detailTitle.text = self.mapmodel.mapDescription;
        }else{
            self.detailTitle.text =@"";
        }
        
        if ([self.mapmodel.edit_permission isEqualToString:@"owner"]) {
            self.editPremission.text = @"仅自己可编辑";
        }else if([self.mapmodel.edit_permission isEqualToString:@"public"])
        {
            self.editPremission.text = @"众包地图";
        }else
        {
            self.editPremission.text = @"群组地图";
        }
        
        
        if ([self.mapmodel.permission isEqualToString:@"pri"]) {
            self.lookPreMission.text = @"仅自己可见";
        }else if([self.mapmodel.permission isEqualToString:@"pub"]){
            self.lookPreMission.text = @"所有人可见";
        }else{
            self.lookPreMission.text = @"加密地图";
        }
        
        NSString *str1 = [NSString stringWithFormat:@"%@",self.mapmodel.view_count];
         NSString *str2 = [NSString stringWithFormat:@"%@",self.mapmodel.like];
        [self.liulanBtn setTitle:str1 forState:UIControlStateNormal];
        [self.likeBtn setTitle:str2 forState:UIControlStateNormal];
        
        NSString *str = [[NSString alloc]init];
        if (self.mapmodel.tag.count != 0 ) {
            for (int i  = 0; i< self.mapmodel.tag.count; i++) {
                str = [str stringByAppendingString:@" "];
                str =  [str stringByAppendingString:self.mapmodel.tag[i]];
            }
            self.tag.text = str;
        }else
        {
            self.tag.text = @"无";
        }
        
        
        self.map_title.text = self.mapmodel.title;
        
//  设置 编辑地图按钮 如果地图返回信息是本人 或者 是群组 才可以编辑
        SMAccount *accout = [SMAccount accountFromSandbox];

        if ([accout.user_id isEqualToString:self.mapmodel.user_id] ||
//            [accout.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
//            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_create" higImage:@"nav_create_press" target:self action:@selector(didClickEditMapInfo)];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_create"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickEditMapInfo)];
        }

        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(coloseSelf)];
        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
//        
//        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        
//        [btn addTarget:self action:@selector(coloseSelf) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                           
//                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                           
//                                           target:nil action:nil];
//        
//        negativeSpacer.width = -5;
//        
//        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];
        
        
    }else{
        
//        可能不需要了
        
        self.creator.text = self.model.map.creator;
        
        self.creat_time.text = self.model.map.map_created_at;
        
        self.map_id.text = self.model.map.Lid;
        
        
        NSString *str = [[NSString alloc]init];
        if (self.model.tags.count != 0 ) {
            for (int i  = 0; i< self.model.tags.count; i++) {
                
                str = [str stringByAppendingString:@" "];
                str =  [str stringByAppendingString:self.model.tags[i]];
            }
            self.tag.text = str;
        }else
        {
            self.tag.text = @"无";
        }
        
        
        self.map_title.text = self.model.map.title;
    }
  
}

-(void)viewDidLayoutSubviews
{
    self.scollview.contentSize = CGSizeMake(kWidth,CGRectGetMaxY(self.likeBtn.frame )+64);
}

-(BOOL)isOperator
{
    SMAccount *acount = [SMAccount accountFromSandbox];
    
    for (NSNumber *num in acount.groups) {
        NSString *str = [NSString stringWithFormat:@"%@",num];
        if ([str isEqualToString:self.mapmodel.group_id]) {
            return YES;
            break;
        }
    }
    return NO;
}

-(void)coloseSelf
{
    if ([self.delegate respondsToSelector:@selector(willUpdateMap:)]) {
        [self.delegate willUpdateMap:self.mapmodel];
    }
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)didClickEditMapInfo
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMPutNewMapInfo" bundle:nil];
    SMPutNewMapInfo *putNewVc = [sb instantiateInitialViewController];
    
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:putNewVc];
//    传入信息
    putNewVc.mapModel = self.mapmodel;
    
    putNewVc.delegate = self;
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)didFinishUpdateMap:(SMCreatMap *)model
{
    self.mapmodel = model;
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
