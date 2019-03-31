//
//  SLiveHeadInfoView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SLiveHeadInfoView.h"
#import "InformationModel.h"
#import "cuserModel.h"
#import "SLiveReportView.h"
#import "dataModel.h"

@implementation SLiveHeadInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userInteractionEnabled = NO;
    self.bigBottomView.userInteractionEnabled = NO;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.bigBottomView.backgroundColor = kBackGroundColor;
    self.bigBottomView.layer.cornerRadius = 5;
    self.bigBottomView.layer.masksToBounds = YES;
    UITapGestureRecognizer *viewTap   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap)];
    viewTap.delegate = self;
    [self addGestureRecognizer:viewTap];
    
    self.bHeadImgView.layer.cornerRadius = 35*kScaleHeight;
    self.bHeadImgView.layer.masksToBounds = YES;
    self.sHeadImgView.layer.cornerRadius = self.sHeadImgView.height/2.0f;
    self.sHeadImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = self.iconImgView.height/2.0f;
    self.iconImgView.layer.masksToBounds = YES;
    [self.followBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [self.privateLetterBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [self.replyBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [self.mainViewBtn2 setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [self.mainViewBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    self.identifitionLabel.textColor = kAppMainColor;
    self.outPutLabel.textColor = kAppMainColor;
    [self.reportBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    
    //控件高度之间的距离
    self.HlineView.backgroundColor = self.VlineView1.backgroundColor = self.VlineView2.backgroundColor = kAppSpaceColor2;
    self.nameBottomViewSpaceH.constant = self.nameBottomViewSpaceH.constant*kScaleHeight;
    self.identifitionViewSpaceH.constant = self.identifitionViewSpaceH.constant*kScaleHeight;
    self.cfBottomViewSpaceH.constant = self.cfBottomViewSpaceH.constant*kScaleHeight;
    self.HLineViewSpaceH.constant = self.HLineViewSpaceH.constant*kScaleHeight;
    self.bHeadImgViewSpaceH.constant = self.bHeadImgViewSpaceH.constant*kScaleHeight;
    self.signLabelSpaceH.constant = self.signLabelSpaceH.constant*kScaleHeight;
    self.HLineViewSpaceH.constant = self.HLineViewSpaceH.constant*kScaleHeight;
    
    
    //控件的高度
    self.identifitionBottomViewHeight.constant = self.identifitionBottomViewHeight.constant*kScaleHeight;
    self.bHeadImgViewHeight.constant = self.bHeadImgViewHeight.constant*kScaleHeight;
    self.nameBottomViewHeight.constant = self.nameBottomViewHeight.constant*kScaleHeight;
    self.accountBottomViewHeight.constant = self.accountBottomViewHeight.constant*kScaleHeight;
    self.signBottomViewHeight.constant = self.signBottomViewHeight.constant*kScaleHeight;
    self.CfBottomViewHight.constant = self.CfBottomViewHight.constant*kScaleHeight;
    self.OtBottomViewHeight.constant = self.OtBottomViewHeight.constant*kScaleHeight;
    
    
}

- (void)updateUIWithModel:(UserModel *)model withRoom:(id<FWShowLiveRoomAble>)room
{
    self.user_id = model.user_id;
    self.myRoom = room;
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"userinfo" forKey:@"act"];
    if ([[room liveHost] imUserId].length)
    {
        [dictM setObject:[[room liveHost] imUserId] forKey:@"podcast_id"];
    }
    if (model.user_id.length)
    {
        [dictM setObject:model.user_id forKey:@"to_user_id"];
    }
    if (StringFromInt([room liveAVRoomId]).length)
    {
        [dictM setObject:StringFromInt([room liveAVRoomId]) forKey:@"room_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             [self JsonDict:responseJson andUserId:model.user_id];
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         self.userInteractionEnabled = YES;
         self.bigBottomView.userInteractionEnabled = YES;
     } FailureBlock:^(NSError *error)
     {
         self.userInteractionEnabled = YES;
         self.bigBottomView.userInteractionEnabled = YES;
     }];
}

//解析数据
-(void)JsonDict:(NSDictionary *)dict andUserId:(NSString *)userId
{
    UserModel *uModel;
    cuserModel *cModel;
    InformationModel *model = [InformationModel mj_objectWithKeyValues:dict];
    if (model.user)
    {
        uModel = model.user;
    }else
    {
        uModel = [[UserModel alloc]init];
    }
    
    if (model.cuser)
    {
        cModel = model.cuser;
    }else
    {
        cModel = [[cuserModel alloc]init];
    }
    self.headImgViewStr = uModel.head_image;
    [self.bHeadImgView sd_setImageWithURL:[NSURL URLWithString:uModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if ([uModel.is_authentication intValue]>0) {
        if (uModel.v_icon && ![uModel.v_icon isEqualToString:@""])
        {
            self.iconImgView.hidden = NO;
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:uModel.v_icon] placeholderImage:kDefaultPreloadHeadImg];
        }else{
            self.iconImgView.hidden = YES;
        }
    }else{
        self.iconImgView.hidden = YES;
    }
    
    if (cModel.head_image)
    {
        self.sHeadImgView.hidden = NO;
        [self.sHeadImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image]];
    }else
    {
        self.sHeadImgView.hidden = YES;
    }
    self.nick_name = uModel.nick_name;
    if (uModel.nick_name.length < 1)
    {
        uModel.nick_name = @"fanwe";
    }
    
    self.is_robot = uModel.is_robot;
    
    NSString *nameString = [NSString stringWithFormat:@"%@",uModel.nick_name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} range:NSMakeRange(0, nameString.length)];
    CGFloat width =[nameString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].width;
    self.nameLabel.attributedText = attr;
    if (width + 65 >(301*kScaleWidth))
    {
        width = 301*kScaleWidth -65;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameBottomViewWidth.constant = width + 55;
    
    if ([model.user.sex isEqualToString:@"1"])
    {
        [self.sexImgView setImage:[UIImage imageNamed:@"com_male_selected"]];
    }else
    {
        [self.sexImgView setImage:[UIImage imageNamed:@"com_female_selected"]];
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user.user_level]];
    
    self.show_admin = model.show_admin;
    self.show_tipoff = model.show_tipoff;
    self.has_admin = model.has_admin;
    self.has_focus = model.has_focus;
    self.is_forbid =model.is_forbid;
    if (uModel.user_id.length < 1)
    {
        uModel.user_id = @"方维";
    }
    
    NSString *rommString;
    if ([uModel.luck_num intValue] > 0)
    {
        rommString = [NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name,uModel.luck_num];
    }else
    {
        rommString = [NSString stringWithFormat:@"%@:%@",self.fanweApp.appModel.account_name,uModel.user_id];
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:rommString];
    [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:NSMakeRange(0, rommString.length)];
    CGFloat width1 =[rommString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
    self.accountLabel.attributedText = attr1;
    
    if (uModel.city.length < 1)
    {
        uModel.city = @"火星";
    }
    
    NSString *addressString = [NSString stringWithFormat:@"%@",uModel.city];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:addressString];
    [attr2 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:NSMakeRange(0, addressString.length)];
    CGFloat width2 =[addressString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
    
    if (width1 + width2 + 25 > 301*kScaleWidth)
    {
        self.placeLabelWidth.constant = 301*kScaleWidth - 25- width1;
        self.accountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.accountBottomViewWidth.constant = 301*kScaleWidth;
    }else
    {
        self.placeLabelWidth.constant      = width2+5;
        self.accountBottomViewWidth.constant = width2+width1+25;
    }
    self.placeLabel.attributedText = attr2;
    
    if (uModel.v_explain.length > 0)
    {
        self.identifitionView.hidden = NO;
        NSString *explainString = [NSString stringWithFormat:@"认证:%@",uModel.v_explain];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:explainString];
        CGFloat width3 =[explainString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
        self.identifitionLabel.attributedText = attr1;
        if (width3 +30 > 301*kScaleWidth)
        {
            self.identifitionBottomViewWidth.constant = 301*kScaleWidth;
            self.identifitionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }else
        {
            self.identifitionBottomViewWidth.constant = width3+30;
        }
    }else
    {
        self.identifitionView.hidden = YES;
        self.identifitionImgView.hidden = YES;
        self.identifitionLabel.hidden = YES;
        self.identifitionBottomViewHeight.constant = 0;
        self.identifitionViewSpaceH.constant = 0;
        self.bigBottomViewHeight.constant =self.bigBottomViewHeight.constant -23*(kScreenH/667.00);
    }
    
    if (uModel.signature.length < 1)
    {
        uModel.signature = @"TA好像忘记写签名了";
    }
    self.siginLabel.font = [UIFont systemFontOfSize:13];
    NSString *likeString = [NSString stringWithFormat:@"%@",uModel.signature];
    NSMutableAttributedString *attr6 = [[NSMutableAttributedString alloc] initWithString:likeString];
    self.siginLabel.attributedText = attr6;
    
    if ([[IMAPlatform sharedInstance].host.imUserId isEqualToString:userId])
    {
        self.bBottomView.hidden  = YES;
        self.mainViewBtn2.hidden = NO;
    }else
    {
        self.bBottomView.hidden  = NO;
        self.mainViewBtn2.hidden = YES;
    }
    //关注
    if (uModel.n_focus_count.length > 0)
    {
        self.concernLabel.text = [NSString stringWithFormat:@"       关注:%@",uModel.n_focus_count];
    }else
    {
        self.concernLabel.text = @"       关注0";
    }
    
    //粉丝
    if (uModel.n_fans_count.length > 0)
    {
        self.followLabel.text = [NSString stringWithFormat:@"       粉丝:%@",uModel.n_fans_count];
    }else
    {
        self.followLabel.text = @"       粉丝0";
    }
    //送出
    if (uModel.n_use_diamonds.length > 0 )
    {
        NSString *outPutStr = [NSString stringWithFormat:@"       送出:%@",uModel.n_use_diamonds];
        NSMutableAttributedString *attr6 = [[NSMutableAttributedString alloc] initWithString:outPutStr];
        self.outPutLabel.attributedText = attr6;
    }else
    {
        self.outPutLabel.text = @"       送出:0";
    }
    
    //映票
    if (uModel.n_ticket.length > 0)
    {
        self.ticketLabel.text = [NSString stringWithFormat:@"       %@:%@", self.fanweApp.appModel.ticket_name,uModel.n_ticket];
        
    }else
    {
        self.ticketLabel.text = [NSString stringWithFormat:@"       %@:0", self.fanweApp.appModel.ticket_name];
    }
    
    //判断是管理还是举报
    if (model.show_tipoff == 1)
    {
        [self.reportBtn setTitle:@"举报" forState:0];
    }
    if (model.show_admin == 1 || model.show_admin == 2)
    {
        [self.reportBtn setTitle:@"管理" forState:0];
    }else if(model.show_tipoff == 0 && model.show_admin == 0)
    {
        [self.reportBtn setTitle:@"" forState:0];
    }
    
    //判断是否已关注
    if (model.has_focus == 0 )
    {
        [self.followBtn setTitle:@"关注" forState:0];
        [self.followBtn setTitleColor:kAppMainColor forState:0];
        self.followBtn.userInteractionEnabled = YES;
    }else
    {
        [self.followBtn setTitle:@"已关注" forState:0];
        [self.followBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        self.followBtn.userInteractionEnabled = NO;
    }
    
    NSLog(@"[[IMAPlatform sharedInstance].host imUserId]===%@,self.user_id===%@,[[_myRoom liveHost] imUserId]===%@",[[IMAPlatform sharedInstance].host imUserId],self.user_id,[[_myRoom liveHost] imUserId]);
    if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:self.user_id])
    {
        self.mainViewBtn2.hidden = NO;
        self.bBottomView.hidden  = YES;
        self.HlineView.hidden    = NO;
    }
    
    if ([[[_myRoom liveHost] imUserId] isEqualToString:[[IMAPlatform sharedInstance].host imUserId]] && [[[_myRoom liveHost] imUserId] isEqualToString:self.user_id] )
    {
        self.mainViewBtn2.hidden = YES;
        self.bBottomView.hidden  = YES;
        self.HlineView.hidden    = YES;
        self.bigBottomViewHeight.constant = self.bigBottomViewHeight.constant - 50*kScaleHeight;
    }
    
}

#pragma mark 0举报 管理 1删除 2主页 3关注 4私信 5回复
- (IBAction)btnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [self reportOrManager];
        }
            break;
        case 1:
        {
            [self myTap];
        }
            break;
        case 2:
        {
            [self goToHomePageVC];
        }
            break;
        case 3:
        {
            [self creatConcern];
        }
            break;
        case 4:
        {
            [self privateletter];
        }
            break;
        case 5:
        {
            [self reply];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 管理和举报
- (void)reportOrManager
{
    if (self.show_tipoff == 1 && self.show_admin == 0)//是否显示举报
    {
        [self removeFromSuperview];
        [self getReportView];
    }
    if (self.show_admin == 1)//管理员
    {
        UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [headImgSheet addButtonWithTitle:@"举报"];
        if (self.is_forbid == 1)
        {
            [headImgSheet addButtonWithTitle:@"解除禁言"];
        }else
        {
            [headImgSheet addButtonWithTitle:@"禁言"];
        }
        [headImgSheet addButtonWithTitle:@"取消"];
        headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
        headImgSheet.delegate = self;
        [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    if (self.show_admin == 2)//主播
    {
        if (self.has_admin == 0)
        {
            UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [headImgSheet addButtonWithTitle:@"设置为管理员"];
            [headImgSheet addButtonWithTitle:@"管理员列表"];
            if (self.is_forbid == 1)
            {
                [headImgSheet addButtonWithTitle:@"解除禁言"];
            }else
            {
                [headImgSheet addButtonWithTitle:@"禁言"];
            }
            [headImgSheet addButtonWithTitle:@"取消"];
            headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
            headImgSheet.delegate = self;
            [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
        }else if (self.has_admin == 1)
        {
            UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [headImgSheet addButtonWithTitle:@"取消管理员"];
            [headImgSheet addButtonWithTitle:@"管理员列表"];
            if (self.is_forbid == 1)
            {
                [headImgSheet addButtonWithTitle:@"解除禁言"];
            }else
            {
                [headImgSheet addButtonWithTitle:@"禁言"];
            }
            [headImgSheet addButtonWithTitle:@"取消"];
            headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
            headImgSheet.delegate = self;
            [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

- (void)showGagSheet
{
    UIActionSheet * gagActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10分钟",@"1小时",@"12小时",@"1天",@"永久",nil];
    gagActionSheet.tag = 500;
    [gagActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    
    if (actionSheet.tag == 500)
    {
        [dictM setObject:@"user" forKey:@"ctl"];
        [dictM setObject:@"forbid_send_msg" forKey:@"act"];
        [dictM setObject:[self.myRoom liveIMChatRoomId] forKey:@"group_id"];
        [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
        if (buttonIndex != actionSheet.numberOfButtons-1)
        {
            if (buttonIndex == 0) {
                [dictM setObject:@"600" forKey:@"second"];
            }
            else if (buttonIndex == 1)
            {
                [dictM setObject:@"3600" forKey:@"second"];
            }
            else if (buttonIndex == 2)
            {
                [dictM setObject:@(3600*12) forKey:@"second"];
            }
            else if (buttonIndex == 3)
            {
                [dictM setObject:@(3600*24) forKey:@"second"];
            }
            else if (buttonIndex == 4)
            {
                [dictM setObject:@(3600*240) forKey:@"second"];
            }
            FWWeakify(self)
            [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     self.is_forbid = [responseJson toInt:@"is_forbid"];
                 }
                 
             } FailureBlock:^(NSError *error)
             {
                 [FanweMessage alert:@"禁言失败"];
             }];
        }
    }
    else
    {
        if (self.show_admin == 1)//管理员
        {
            if (buttonIndex == 0)//举报
            {
                [self getReportView];
            }
            else if (buttonIndex == 1)
            {
                [self clickGagButton];
            }
        }
        else if (self.show_admin == 2)//主播
        {
            if (buttonIndex == 0)//取消/设置管理员
            {
                [dictM setObject:@"user" forKey:@"ctl"];
                [dictM setObject:@"set_admin" forKey:@"act"];
                [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
                [dictM setObject:[NSString stringWithFormat:@"%d",[self.myRoom liveAVRoomId]] forKey:@"room_id"];
                FWWeakify(self)
                [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson){
                    FWStrongify(self)
                    self.has_admin = [responseJson toInt:@"has_admin"];
                    if ([responseJson toInt:@"status"] == 1)
                    {
                        if (self.has_admin == 1)
                        {
                            [FanweMessage alertHUD:@"设置管理员成功"];
                        }
                        else if (self.has_admin == 0)
                        {
                            [FanweMessage alertHUD:@"取消管理员成功"];
                        }
                    }
                    
                } FailureBlock:^(NSError *error)
                 {
                     [FanweMessage alertHUD:@"管理员设置,请重新操作"];
                 }];
            }
            else if (buttonIndex == 1)//管理员列表
            {
                [self goToManagerList];
            }
            else if (buttonIndex == 2)//禁言
            {
                [self clickGagButton];
            }
        }
    }
}

//关注和取消关注
- (void)creatConcern
{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         _has_focus = [responseJson toInt:@"has_focus"];
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
             if (self.has_focus == 1)//已关注
             {
                 [self.followBtn setTitle:@"已关注" forState:0];
                 [mDict setObject:@"0" forKey:@"isShowFollow"];
                 [self.followBtn setTitleColor:[UIColor lightGrayColor] forState:0];
                 self.followBtn.userInteractionEnabled = NO;
             }
             else if (self.has_focus == 0)//关注
             {
                 [mDict setObject:@"1" forKey:@"isShowFollow"];
                 [self.followBtn setTitle:@"关注" forState:0];
                 [self.followBtn setTitleColor:kAppMainColor forState:0];
             }
             [mDict setObject:[responseJson toString:@"follow_msg"] forKey:@"follow_msg"];
             if (self.user_id.length)
             {
                 [mDict setObject:self.user_id forKey:@"userId"];
             }
             [[NSNotificationCenter defaultCenter]postNotificationName:@"liveIsShowFollow" object:mDict];
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 用来解决跟tableview等的手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.bigBottomView])
    {
        return NO;
    }else
    {
        return YES;
    }
}

#pragma mark  点击空白的地方删除view
- (void)myTap
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:nil andNameStr:nil andUserImgUrl:nil andIs_robot:NO andViewType:1];
        }
    }
}

#pragma mark  进入主页
- (void)goToHomePageVC
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:self.user_id andNameStr:nil andUserImgUrl:nil andIs_robot:NO andViewType:2];
        }
    }
}
#pragma mark  管理员列表的获取
- (void)goToManagerList
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:nil andNameStr:nil andUserImgUrl:nil andIs_robot:NO andViewType:3];
        }
    }
}

#pragma mark 回复的响应
- (void)reply
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:nil andNameStr:self.nick_name andUserImgUrl:nil andIs_robot:NO andViewType:4];
        }
    }
}

#pragma mark 显示举报View
- (void)getReportView
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:self.user_id andNameStr:nil andUserImgUrl:nil andIs_robot:NO andViewType:5];
        }
    }
    
}

#pragma mark 私信的响应事件
- (void)privateletter
{
    if (self.infoDelegate)
    {
        if ([self.infoDelegate respondsToSelector:@selector(operationHeadView:andUserId:andNameStr:andUserImgUrl:andIs_robot:andViewType:)])
        {
            [self.infoDelegate operationHeadView:self andUserId:self.user_id andNameStr:self.nick_name andUserImgUrl:self.headImgViewStr andIs_robot:self.is_robot andViewType:6];
        }
    }
}

- (void)clickGagButton
{
    if (self.is_forbid == 1)
    {
        //取消禁言
        NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
        [dictM setObject:@"user" forKey:@"ctl"];
        [dictM setObject:@"forbid_send_msg" forKey:@"act"];
        [dictM setObject:[self.myRoom liveIMChatRoomId] forKey:@"group_id"];
        [dictM setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"to_user_id"];
        [dictM setObject:@0 forKey:@"second"];
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             if ([responseJson toInt:@"status"] == 1)
             {
                 self.is_forbid = [responseJson toInt:@"is_forbid"];
             }
         } FailureBlock:^(NSError *error)
         {
             
         }];
    }
    else
    {
        //禁言
        [self showGagSheet];
        
    }
    
}

@end
