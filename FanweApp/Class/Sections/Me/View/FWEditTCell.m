//
//  FWEditTCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWEditTCell.h"
#import "UserModel.h"

@implementation FWEditTCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.leftLabel.textColor = kAppGrayColor1;
    self.rightLabel.textColor = kAppGrayColor3;
    
    self.headImgView.layer.cornerRadius = 17*kAppRowHScale;
    self.headImgView.layer.masksToBounds = YES;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 45*kAppRowHScale -1, kScreenW-10, 1)];
    self.lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:self.lineView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameArray = [[NSMutableArray alloc]initWithObjects:@"头像",@"昵称",@"账号",@"性别",@"个性签名",@"认证",@"生日",@"情感状态",@"家乡",@"职业", nil];
}

- (void)creatCellWithStr:(NSString *)rightStr andSection:(int)section
{
     self.leftLabel.text = self.nameArray[section];
    switch (section) {
        case 0:
        {
            self.headImgView.hidden = NO;
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:rightStr] placeholderImage:kDefaultPreloadHeadImg];
            self.lineView.hidden = YES;
        }
            break;
        case 1:
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor1;
            self.nextImgView.hidden = NO;
        }
            break;
        case 2:
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor1;
        }
            break;
        case 3:
        {
            self.sexImgView.hidden = NO;
            if ([rightStr isEqualToString:@"1"])
            {
                _sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }else if ([rightStr isEqualToString:@"2"])
            {
                _sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }else
            {
                _sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
  
        }
            break;
            case 4:
        {
            self.lineView.hidden = YES;
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor2;
            self.nextImgView.hidden = NO;

        }
            break;
        case 6:case 7:case 8:case 9:
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor2;
            self.nextImgView.hidden = NO;
        }
            break;
        case 5:
        {
           //认证暂不处理
        }
            break;
            
        default:
            break;
    }
}
@end
