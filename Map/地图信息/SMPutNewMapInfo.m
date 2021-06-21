//
//  SMPutNewMapInfo.m
    
//
//  Created by lucifer on 15/8/12.
  
//
#import "ZFTokenField.h"
#import "SMPutNewMapInfo.h"
#import "SMBiaoqianViewController.h"
#import "SMMapPremission.h"

@interface SMPutNewMapInfo ()<SMBiaoqianViewControllerDelegate,UITextFieldDelegate,SMMapPremissionDelegate,ZFTokenFieldDataSource,ZFTokenFieldDelegate>

/**
 *  地图标题
 */
@property (weak, nonatomic) IBOutlet UITextField *mapTitle;

/**
 *  地图描述
 */

@property (weak, nonatomic) IBOutlet SMInputTextView *mapDetailDiscuption;


/**
 *  点击加入标签
 *
 */
- (IBAction)getTags:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet ZFTokenField *ZFTokenView;

/**
 *  地图权限输出板
 */
@property (weak, nonatomic) IBOutlet UILabel *premisionLaber;

@property (nonatomic,strong)NSMutableArray *tagArr;

//记录编辑权限
@property(nonatomic,strong)NSString *EditStr;
//记录查看权限
@property (nonatomic,strong)NSString *LookStr;

@property(nonatomic,copy)NSString *biaoqianName;
@property(nonatomic,copy)NSString *PWDStr;

@end

@implementation SMPutNewMapInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapTitle.text = self.mapModel.title;
    self.mapTitle.placeholder = @"地图标题";
    
    self.mapDetailDiscuption.text = self.mapModel.mapDescription;
    self.mapDetailDiscuption.placeholder =@"地图描述";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新地图详情" style:UIBarButtonItemStylePlain target:self action:@selector(putnew)];
//  初始输出 标签
//    NSString *strFil = [[NSString alloc]init];
//    for (NSString *str in self.mapModel.tag) {
//        
//        strFil = [strFil stringByAppendingString:@" #"];
//        
//        strFil = [strFil stringByAppendingString:str];
//        
//        strFil = [strFil stringByAppendingString:@"#"];
//        
//    }
    
//    
//    self.tagLaber.textColor = [UIColor grayColor];
//    
//    
//    self.tagLaber.text = strFil;
    
    //    初始输出 地图权限
    self.EditStr = self.mapModel.edit_permission;
    self.LookStr = self.mapModel.permission;
    
    if ([_EditStr isEqualToString:@"owner"]) {
        self.premisionLaber.text = @"仅自己可编辑";
    }
    if ([_EditStr isEqualToString:@"public"]) {
        self.premisionLaber.text = @"众包";
    }
    
    if ([_LookStr isEqualToString:@"pri"]) {
        self.premisionLaber.text =   [self.premisionLaber.text stringByAppendingString:@"  仅自己可见"];
    }
    
    if ([_LookStr isEqualToString:@"pub"]) {
        self.premisionLaber.text = [self.premisionLaber.text stringByAppendingString:@"  所有人可见"];
    }
    
    if ([_LookStr isEqualToString:@"pas"]) {
        self.premisionLaber.text = [self.premisionLaber.text stringByAppendingString:@"  密码可见"];
    }

    [self.tagArr addObjectsFromArray:self.mapModel.tag];
    
    self.ZFTokenView.delegate = self;
    self.ZFTokenView.dataSource = self;
    [self.ZFTokenView reloadData];
    
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.ZFTokenView indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tagArr removeObjectAtIndex:index];
        [self.ZFTokenView reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 20;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tagArr.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tagArr[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 20)];
    view.frame = CGRectMake(0, 0, size.width + 97, 20);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}


- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tagArr removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return YES;
}

-(void)tokenFieldDidBeginEditing:(ZFTokenField *)tokenField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


-(void)putnew
{
    [SVProgressHUD showInfoWithStatus:@"正在更新地图"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"id"] = self.mapModel.Lid;
    
    if (self.tagArr == 0) {
        NSString *str = [self.mapModel.tag JSONString];
         parameters[@"tags"] = str;
    }else{
    NSString *str = [self.tagArr JSONString];
         parameters[@"tags"] = str;
    }
   
    
    parameters[@"title"]= self.mapTitle.text;
    parameters[@"description"] = self.mapDetailDiscuption.text;
    
    if (self.EditStr) {
        parameters[@"group"] = self.EditStr;
    }else{
        parameters[@"group"] = self.mapModel.edit_permission;
    }
    if (self.LookStr) {
         parameters[@"permission"] = self.LookStr;
    }else{
        parameters[@"permission"] = self.mapModel.permission;
    }
   
    if (self.PWDStr) {
        parameters[@"password"] = self.PWDStr;
    }
    
   
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@",self.mapModel.Lid];

    [manager PUT:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SMCreatMap *model = [SMCreatMap objectWithKeyValues:responseObject[@"map_info"]];
        
        if ([self.delegate respondsToSelector:@selector(didFinishUpdateMap:)]) {
            [self.delegate didFinishUpdateMap:model];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getTags:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BiaoqianViewController" bundle:nil];
    SMBiaoqianViewController *biaoqianVC = [sb instantiateInitialViewController];
    biaoqianVC.delegate = self;

    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:biaoqianVC];
    
    [self presentViewController:nav animated:YES completion:nil];

}
-(NSString *)biaoqianName
{
    if (!_biaoqianName) {
        _biaoqianName = [[NSString alloc]init];
    }
    return _biaoqianName;
}
-(void)didClickSendBtnWithToken:(NSString *)token
{
    
//    self.biaoqianName =   [self.biaoqianName stringByAppendingString:@" #"];
//    
//    self.biaoqianName = [self.biaoqianName stringByAppendingString:token];
//    
//    self.biaoqianName = [self.biaoqianName stringByAppendingString:@"#"];
    
    [self.tagArr addObject:token];
    [self.ZFTokenView reloadData];
}

-(NSMutableArray *)tagArr
{
    if (!_tagArr) {
        _tagArr = [[NSMutableArray alloc] init];
    }
    return _tagArr;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
//点击其他区域关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mapDetailDiscuption resignFirstResponder];
}
//按下Done键关闭键盘
- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) textField1DoneEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SMMapPremission *mappremissonVC = segue.destinationViewController;
    mappremissonVC.mapModel = self.mapModel;
    mappremissonVC.delegate = self;
}
-(void)didFinishPremisonEditStr:(NSString *)EditStr lookStr:(NSString *)LookStr
{
    self.EditStr = EditStr;
    self.LookStr = LookStr;
    
    if ([EditStr isEqualToString:@"owner"]) {
        self.premisionLaber.text = @"仅自己可编辑";
    }
    if ([EditStr isEqualToString:@"public"]) {
        self.premisionLaber.text = @"众包";
    }
    
    if ([LookStr isEqualToString:@"pri"]) {
        self.premisionLaber.text =   [self.premisionLaber.text stringByAppendingString:@"  仅自己可见"];
    }
    
    if ([LookStr isEqualToString:@"pub"]) {
        self.premisionLaber.text = [self.premisionLaber.text stringByAppendingString:@"  所有人可见"];
    }
    
    if ([LookStr isEqualToString:@"pas"]) {
        self.premisionLaber.text = [self.premisionLaber.text stringByAppendingString:@"  密码可见"];
    }
    
}
-(void)paswordPass:(NSString *)Pwd
{
    self.PWDStr = Pwd;
}
@end
