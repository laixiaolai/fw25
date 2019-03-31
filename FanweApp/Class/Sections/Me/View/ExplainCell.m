//
//  ExplainCell.m
//  FanweApp
//
//  Created by 王珂 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ExplainCell.h"
@implementation ExplainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ExplainCell";
    ExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = kAppGrayColor1;
    self.explainLabel.textColor = kAppGrayColor2;
    self.explainLabel.preferredMaxLayoutWidth = kScreenW-20;
}

-(void)setModel:(BingdingStateModel *)model
{
    _model = model;
    NSString * explainStr;
    if (model.refund_explain && model.refund_explain.count>0)
    {
        explainStr = [model.refund_explain componentsJoinedByString:@"\r\n"];
    }
    else
    {
        explainStr = @"";
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:explainStr];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [attrStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:15.0f]
                         range:NSMakeRange(0, [explainStr length])];
    //行间距
    paragraph.lineSpacing = 5;
    //段落间距
    paragraph.paragraphSpacing = 5;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 0;
    //调整全部文字的缩进像素
    paragraph.headIndent = 5;
    [attrStr addAttribute:NSParagraphStyleAttributeName
                         value:paragraph
                         range:NSMakeRange(0, [explainStr length])];
    self.explainLabel.attributedText = attrStr;
    [self.explainLabel sizeToFit];
    [self layoutIfNeeded];
    model.explainCellHeight = CGRectGetMaxY(self.explainLabel.frame)+10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
