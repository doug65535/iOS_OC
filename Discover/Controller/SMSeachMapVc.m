//
//  SMSeachMapVc.m
    
//
//  Created by lucifer on 15/8/31.
  
//

#import "SMSeachMapVc.h"
#import "ALView+PureLayout.h"
#import "SMMapRestultVc.h"

@interface SMSeachMapVc ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 遮盖 */
@property (nonatomic, weak) IBOutlet UIButton *cover;

@property(nonatomic,strong)SMMapRestultVc *makerResultVc;
@property (weak, nonatomic) IBOutlet UIButton *clearHistory;
- (IBAction)clearHistroy:(UIButton *)sender;

@end

@implementation SMSeachMapVc


- (SMMapRestultVc *)makerResultVc
{
    if (!_makerResultVc) {
        SMMapRestultVc *makerResultVc = [[SMMapRestultVc alloc] init];
        [self addChildViewController:makerResultVc];
        [self.view addSubview:makerResultVc.view];

        [makerResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [makerResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        self.makerResultVc = makerResultVc;
        
    }
    return _makerResultVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *searchField = [self.searchBar.subviews[0].subviews lastObject];
    searchField.font = [UIFont systemFontOfSize:12];
    // 设置导航栏
    self.title = @"搜索地图";
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    [self.cover addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
    
    
    SMAccount *acount = [SMAccount accountFromSandbox];
    if (!acount.historyArr.count) {
        self.clearHistory.hidden = YES;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"搜索历史记录";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    SMAccount *acount = [SMAccount accountFromSandbox];
    cell.textLabel.text = acount.historyArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"正在努力搜索中"];
     SMAccount *acount = [SMAccount accountFromSandbox];
    self.makerResultVc.searchText  = acount.historyArr[indexPath.row];
    [_searchBar endEditing:YES];
    //     4.移除蒙版
    self.cover.hidden = YES;
    self.makerResultVc.view.hidden = YES;
//    self.tableView.hidden = YES;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMAccount *acount = [SMAccount accountFromSandbox];
    return acount.historyArr.count;
}


-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)resign
{
    
    [self.searchBar resignFirstResponder];
    // 1.让搜索框背景变为灰色
    _searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    // 2.隐藏cancel按钮
    [_searchBar setShowsCancelButton:NO animated:YES];
    
    // 3.导航条出现（通过动画向下出现）
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //     4.移除蒙版
    self.cover.hidden = YES;
    //     5.清空搜索框文字
    _searchBar.text = nil;
    //     6.隐藏搜索结果控制器
    self.makerResultVc.view.hidden = YES;
}
//- (void)setupNav
//{
//    // 1.main_find_press
//    // 2.搜索框
//
//    UIView *titleView = [[UIView alloc] init];
//    titleView.width = 250;
//    titleView.height = 35;
//    self.navigationItem.titleView = titleView;
//
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    searchBar.frame = titleView.bounds;
////    searchBar.backgroundImage = [UIImage imageNamed:@"main_find_press"];
//    searchBar.delegate = self;
//    [titleView addSubview:searchBar];
//    self.searchBar = searchBar;
//}


#pragma mark - <UISearchBarDelegate>
/**
 *  当搜索框已经进入编辑状态（键盘已经弹出）
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 2.出现cancel按钮
//    [searchBar setShowsCancelButton:YES animated:YES];
    // 3.导航条消失（通过动画向上消失）
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 4.添加蒙版
    self.cover.hidden = NO;
    
    
}

/**
 *  当搜索框已经退出编辑状态（键盘已经退下）
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏cancel按钮
//    [searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条出现（通过动画向下出现）
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 4.移除蒙版
    //    self.cover.hidden = YES;
    // 5.清空搜索框文字
    //    searchBar.text = nil;
    // 6.隐藏搜索结果控制器
    //    self.makerResultVc.view.hidden = YES;
}

/**
 *  点击取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    //     4.移除蒙版
    self.cover.hidden = YES;
    //     5.清空搜索框文字
//    searchBar.text = nil;
    //     6.隐藏搜索结果控制器
//    self.makerResultVc.view.hidden = YES;
}

/**
 *  搜索框的文字改变
 *
 *  @param searchText 搜索框当前的文字（搜索条件）
 */
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    self.makerResultVc.view.hidden = (searchText.length == 0);
////    self.makerResultVc.searchText = searchText;
//
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.searchBar.text  isEqual: @""] ) {
        return;
    }
    [SVProgressHUD showWithStatus:@"正在努力搜索中"];
    self.makerResultVc.searchText  = self.searchBar.text;
    [searchBar endEditing:YES];
    //     4.移除蒙版
    self.cover.hidden = YES;
    self.makerResultVc.view.hidden = YES;
    
    self.clearHistory.hidden = YES;
//    储存搜索历史
//    NSMutableArray *histroyArr = [[NSMutableArray alloc]init];
//    [histroyArr addObject:self.searchBar.text];
//    [[NSUserDefaults standardUserDefaults]setObject:histroyArr forKey:@"SEARCH_HISTORY"];
        SMAccount *acount = [SMAccount accountFromSandbox];
    
        [acount.historyArr addObject:searchBar.text];
    
        [acount save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [SVProgressHUD dismiss];
}


- (IBAction)clearHistroy:(UIButton *)sender {
    
    SMAccount *acount = [SMAccount accountFromSandbox];
    [acount.historyArr removeAllObjects];
    [acount save];
    [self.tableView reloadData];
}
@end
