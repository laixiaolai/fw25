//
//  STBMKViewC.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBMKViewC.h"

@interface STBMKViewC ()

@end

@implementation STBMKViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma **************************** Getter 区域 ***************************
#pragma mark -- stBMKView
-(STBMKView *)stBMKView{
    if (!_stBMKView) {
        _stBMKView = (STBMKView *)[STBMKView showSTBaseViewOnSuperView:self.view
                                                       loadNibNamedStr:@"STBMKView"
                                                          andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                           andComplete:^(BOOL finished,
                                                                         STBaseView *stBaseView) {
                                                               
                                                           }];
        [_stBMKView setDelegate:self];
        [_stBMKView setBaseDelegate:self];
        _stBMKView.tableView.mj_footer.hidden = YES;
    }
    return _stBMKView;
}

#pragma **************************** Delegate 协议方法 区域 ***************************
#pragma mark ---------------<STTableViewBaseViewDelegate>
-(void)showTableViewDidSelectIndexpath:(NSIndexPath *)indexPath
                    andSTTableBaseView:(STTableBaseView *)stTableBaseView{
    
    if (indexPath.section == 0) {
        return;
    }
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    if (indexPath.section == 1) {
        if(indexPath.row == 0){
            stBMKCenter.provinceStr     = @"不显示";
            stBMKCenter.cityNameStr     = @"不显示";
            stBMKCenter.detailAdressStr = @"不显示";
            stBMKCenter.latitudeValue   = 0;
            stBMKCenter.longitudeValue  = 0;
            
        }else{
        }
    }
    if (indexPath.section == 2) {
        STBMKView *stBMKView = (STBMKView *)stTableBaseView;
        BMKPoiInfo *info = stBMKView.dataSoureMArray[indexPath.row];
        stBMKCenter.districtStr     = info.name;
        stBMKCenter.detailAdressStr = info.address;
        stBMKCenter.latitudeValue   = info.pt.latitude;
        stBMKCenter.longitudeValue  = info.pt.longitude;
    }
    
    
    if (_delegate &&[_delegate respondsToSelector:@selector(showUpdateLoactionInfoOfIndexPath)]) {
        [self.navigationController popViewControllerAnimated:YES];
        [_delegate showUpdateLoactionInfoOfIndexPath];
    }
}

-(void)setDelegate:(id<STBMKViewCDelegate>)delegate{
    _delegate = delegate;
}
@end
