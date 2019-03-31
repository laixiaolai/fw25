//
//  FWBaseTableViewController.m
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseTableViewController.h"

@interface FWBaseTableViewController ()

@property (nonatomic, copy) BackBlock backBlock;

@end

@implementation FWBaseTableViewController

- (void)dealloc
{
    NSLog(@"dealloc %@", [self description]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hideMyHud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 1、初始化变量
    [self initFWVariables];
    // 2、UI创建
    [self initFWUI];
    // 3、加载数据
    [self initFWData];
}

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (GlobalVariables *)fanweApp
{
    if (!_fanweApp)
    {
        _fanweApp = [GlobalVariables sharedInstance];
    }
    return _fanweApp;
}

- (NSMutableArray *)mainDataMArray
{
    if (!_mainDataMArray)
    {
        _mainDataMArray = [NSMutableArray array];
    }
    return _mainDataMArray;
}

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    self.backBlock = backBlock;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

#pragma mark - 返回上一级
- (void)onReturnBtnPress
{
    if (self.backBlock)
    {
        self.backBlock();
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 供子类重写
#pragma mark 初始化变量
- (void)initFWVariables
{
    
}

#pragma mark UI创建
- (void)initFWUI
{
    
}

#pragma mark 加载数据
- (void)initFWData
{
    
}


#pragma mark - HUD
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
    [self.proHud showAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
