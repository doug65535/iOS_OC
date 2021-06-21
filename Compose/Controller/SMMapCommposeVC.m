//
//  SMMapCommposeVC.m
    
//
//  Created by lucifer on 15/8/19.
  
//

#import "SMMapCommposeVC.h"
#import "SMBiaoqianViewController.h"
#import "SMMapPremission.h"
#import "SMMapViewController.h"
#import "ZFTokenField.h"

@interface SMMapCommposeVC ()<SMMapPremissionDelegate,UITextFieldDelegate,UITextViewDelegate,SMBiaoqianViewControllerDelegate,SMMapViewControllerDelegate,ZFTokenFieldDelegate,ZFTokenFieldDataSource>
@property (weak, nonatomic) IBOutlet UIButton *getTags;
- (IBAction)getTags:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet SMInputTextView *mapTitle;

@property (weak, nonatomic) IBOutlet SMInputTextView *mapDetail;

@property (weak, nonatomic) IBOutlet UISwitch *isPushToComm;
- (IBAction)isPushToComm:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *premissonOut;
@property(nonatomic,copy)NSString *EditStr;
@property(nonatomic,copy)NSString *LookStr;

@property(nonatomic,copy)NSString *biaoqianName;
@property (nonatomic,strong)NSMutableArray *tagArr;
@property (nonatomic,copy)NSString *PWDStr;
@property (weak, nonatomic) IBOutlet ZFTokenField *ZFTokenView;

@end

@implementation SMMapCommposeVC


-(NSMutableArray *)tagArr
{
    if (!_tagArr) {
        _tagArr = [[NSMutableArray alloc] init];
    }
    return _tagArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapTitle.delegate = self;
    self.mapTitle.placeholder = @"请输入地图标题";
//    self.mapTitle.placeholder = @"请输入地图标题";
//    
//    self.mapDetail.placeholder =@"请输入地图描述";
    
    self.EditStr = @"owner";
    self.LookStr = @"pub";
    

    self.premissonOut.text = @"仅自己可编辑 所有人可见";
    
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建地图" style:UIBarButtonItemStylePlain target:self action:@selector(putNewMap)];
    
   self.navigationItem.rightBarButtonItem.enabled = (self.mapTitle.text.length > 0);
    
    self.ZFTokenView.dataSource = self;
    self.ZFTokenView.delegate = self;
      [self.ZFTokenView reloadData];
    
    self.mapDetail.placeholder = @"请输入描述";

    
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
    view.frame = CGRectMake(0, 0, size.width + 87, 20);
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



-(void)putNewMap
{
    [SVProgressHUD showWithStatus:@"正在创建地图……"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    NSString *strUrl = @"http://www.dituhui.com/api/v2/maps";
    
    NSMutableDictionary *pramers = [[NSMutableDictionary alloc]init];
    pramers[@"title"] = self.mapTitle.text;
    if (self.mapDetail.text) {
        pramers[@"description"] = self.mapDetail.text;
    }
    if (self.tagArr) {
           pramers[@"tags"] = [self.tagArr JSONString];
    }
    
    if (self.PWDStr) {
        pramers[@"password"] = self.PWDStr;
    }
    
    pramers[@"group"] = self.EditStr;
    pramers[@"permission"] = self.LookStr;
    

    pramers[@"need_sync_to_club"] =[NSNumber numberWithBool:self.isPushToComm.on];
    
    
    [manager POST:strUrl parameters:pramers success:^(NSURLSessionDataTask *task, id responseObject) {
        SMLog(@"%@",responseObject);
        
        SMCreatMap *mapModel = [SMCreatMap objectWithKeyValues:responseObject[@"map_info"]];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil];
        SMMapViewController *mapVc = [sb instantiateInitialViewController];
        

        mapVc.creatModel = mapModel;

        
        SMNavgationController *nav = [[SMNavgationController alloc]init];
        [nav addChildViewController:mapVc];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        [SVProgressHUD dismiss];
        
        mapVc.delegate = self;
//        [self.navigationController pushViewController:mapVc animated:YES];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];

}

-(void)closeMapAndMapCompose
{

    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)close
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
//    
//    
//    
//    [self.getTags setTitle:self.biaoqianName forState:UIControlStateNormal];
    [self.tagArr addObject:token];
        [self.ZFTokenView reloadData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SMMapPremission *mappremissonVC = segue.destinationViewController;
//    mappremissonVC.mapModel = self.mapModel;
    mappremissonVC.delegate = self;
    mappremissonVC.isComuon = self.isPushToComm.on;
    
}
#pragma -mark 权限代理方法
-(void)didFinishPremisonEditStr:(NSString *)EditStr lookStr:(NSString *)LookStr
{
    self.EditStr = EditStr;
    self.LookStr = LookStr;
    
    if ([EditStr isEqualToString:@"owner"]) {
        self.premissonOut.text = @"仅自己可编辑";
    }
    if ([EditStr isEqualToString:@"public"]) {
        self.premissonOut.text = @"众包";
    }
    
    if ([LookStr isEqualToString:@"pri"]) {
      self.premissonOut.text =   [self.premissonOut.text stringByAppendingString:@"  仅自己可见"];
    }
    
    if ([LookStr isEqualToString:@"pub"]) {
        self.premissonOut.text = [self.premissonOut.text stringByAppendingString:@"  所有人可见"];
    }
    
    if ([LookStr isEqualToString:@"pas"]) {
        self.premissonOut.text = [self.premissonOut.text stringByAppendingString:@"  密码可见"];
    }
   
}


-(void)paswordPass:(NSString *)Pwd
{
    self.PWDStr = Pwd;
}

- (IBAction)endEditing1:(id)sender {
    [sender resignFirstResponder];

}
//点击其他区域关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mapTitle resignFirstResponder];
    [self.mapDetail resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
     self.navigationItem.rightBarButtonItem.enabled = (self.mapTitle.text.length > 0);
}



- (IBAction)isPushToComm:(id)sender {
    
    if (self.isPushToComm.on) {
        
        if (self.PWDStr) {
            [self.isPushToComm setOn:NO];
            [SVProgressHUD showErrorWithStatus:@"暂不支持同步密码可见地图到社区"];
            return;
        }else
            [self.isPushToComm setOn:YES];
    }else
    {
        [self.isPushToComm setOn:NO];
    }
}
@end
