//
//  ToolsView.m
//  FanweApp
//
//  Created by yy on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ToolsView.h"

@implementation ToolsView
{
    NSMutableArray  *_dataArray;
}

static NSString *const cellId = @"cellId";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _fanweApp = [GlobalVariables sharedInstance];
        
        if (!_toolsSelArray)
        {
            _toolsSelArray  = [[NSMutableArray alloc]initWithObjects:@"lr_plugin_music_sel",
                               @"lr_plugin_beauty_sel",
                               @"lr_plugin_micro_sel",
                               @"lr_plugin_camera_sel",
                               @"lr_plugin_flash_sel",
                               @"lr_plugin_mirror_sel", nil];
            
            _toolsNameArray = [[NSMutableArray alloc]initWithObjects:@"音乐",
                               @"美颜",
                               @"麦克风",
                               @"切换摄像",
                               @"闪光灯",
                               @"镜像", nil];
            
            _toolsUnselArray = [[NSMutableArray alloc]initWithObjects:@"lr_plugin_music_unsel",
                                @"lr_plugin_beauty_unsel",
                                @"lr_plugin_micro_unsel",
                                @"lr_plugin_camera_unsel",
                                @"lr_plugin_flash_unsel",
                                @"lr_plugin_mirror_unsel", nil];
            
            _cellArray = [[NSMutableArray alloc]init];
            _dataArray = [[NSMutableArray alloc]init];
        }
        
        [self setupModel];
        [self createToolCollection];
    }
    
    return self;
}

- (void)setupModel
{
    dispatch_queue_t queue = dispatch_queue_create("toolsQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0; i < _toolsNameArray.count; i++)
        {
            PluginToolsModel *model = [[PluginToolsModel alloc]init];
            //2.麦克风
            if (i == 2)
            {
                model.isSelected = YES;
            }
            else
            {
                model.isSelected = NO;
            }
            [_dataArray addObject:model];
        }
    });
}

- (void)createToolCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(69, 125);
    layout.sectionInset = UIEdgeInsetsMake(27, 4, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _toolsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, self.size.width -20, self.size.height) collectionViewLayout:layout];
    _toolsCollectionView.backgroundColor = [UIColor clearColor];
    _toolsCollectionView.delegate = self;
    _toolsCollectionView.dataSource = self;
    _toolsCollectionView.showsHorizontalScrollIndicator = NO;   //关闭滚动线
    _toolsCollectionView.allowsMultipleSelection = YES;         //允许多选
    _toolsCollectionView.alwaysBounceHorizontal = YES;          //总是允许横向滚动
    [_toolsCollectionView registerClass:[ToolsCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:_toolsCollectionView];
}

#pragma mark    --------------------------collectionView代理方法--------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //如果是后置摄像头，则没有镜像
    if (_isRearCamera)
    {
        if ([_toolsNameArray containsObject:@"镜像"])
        {
            [_toolsNameArray removeObject:@"镜像"];
        }
    }
    else
    {
        if (![_toolsNameArray containsObject:@"镜像"])
        {
            [_toolsNameArray insertObject:@"镜像" atIndex:5];
        }
    }
    return _toolsNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    ToolsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.toolLabel.text = _toolsNameArray[indexPath.row];
    if (model.isSelected)
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
    }
    else
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
    [_cellArray addObject:cell];
    
    return cell;
}

#pragma mark 选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self collectionView:_toolsCollectionView didHighlightItemAtIndexPath:indexPath];
    
    if (!SUS_WINDOW.isPushStreamIng)
    {
        [self closePlugin];
        [[FWHUDHelper sharedInstance] tipMessage:@"直播开启中，请稍候!"];
        [_toolsCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    else
    {
        [self judgmentTools:YES indexPath:indexPath cell:cell];
    }
}

#pragma mark    取消选中单元格
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self judgmentTools:NO indexPath:indexPath cell:cell];
}

- (void)judgmentTools:(BOOL)selected indexPath:(NSIndexPath *)indexPath cell:(ToolsCollectionViewCell *)cell
{
    PluginToolsModel *model;
    PluginToolsModel *mirrorModel;  //镜像model
    PluginToolsModel *lightModel;   //闪光灯model
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    //0.音乐      1.美颜    3.切换摄像
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)
    {
        if (indexPath.row == 3)
        {
            _isRearCamera = !_isRearCamera;
            if (_isRearCamera)
            {
                //后置摄像头没有镜像
                if ([_toolsNameArray containsObject:@"镜像"])
                {
                    if (indexPath.row + 2 < _dataArray.count)
                    {
                        mirrorModel = _dataArray[indexPath.row + 2];
                        mirrorModel.isSelected = NO;
                        [self selectOrDeselect:indexPath.row + 2 isSelected:NO];
                    }
                }
            }
            else
            {
                _isClick = NO;
                
                //取消闪光灯高亮图片
                if (indexPath.row + 1 < _dataArray.count)
                {
                    lightModel = _dataArray[indexPath.row + 1];
                    lightModel.isSelected = NO;
                    [self closeLight:indexPath];
                }
                
                //如果开了镜像,切换回前置继续开镜像
                if (_isOpenMirror)
                {
                    if (indexPath.row + 2 < _dataArray.count)
                    {
                        mirrorModel = _dataArray[indexPath.row + 2];
                        mirrorModel.isSelected = YES;
                        [self selectOrDeselect:indexPath.row + 2 isSelected:YES];
                    }
                }
            }
        }
        [self selectOrDeselect:indexPath.row isSelected:_isRearCamera];
    }
    //2.麦克风
    else if (indexPath.row == 2)
    {
        model.isSelected = !model.isSelected;
        [self selectOrDeselect:indexPath.row isSelected:model.isSelected];
    }
    //4.闪光灯
    else if (indexPath.row == 4)
    {
        //如果是后置摄像头
        if (_isRearCamera)
        {
            _isClick = !_isClick;
        }
        else
        {
            _isClick = NO;
        }
        model.isSelected = _isClick;
        [self selectOrDeselect:indexPath.row isSelected:_isClick];
    }
    //5.镜像
    else if (indexPath.row == 5)
    {
        _isOpenMirror = !_isOpenMirror;
        model.isSelected = !model.isSelected;
        [self selectOrDeselect:indexPath.row isSelected:model.isSelected];
    }
    
    [_cellArray removeAllObjects];
    [_toolsCollectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsCollectionView cellForItemAtIndexPath:indexPath];
    
    if (model.isSelected)
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
    else
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsCollectionView cellForItemAtIndexPath:indexPath];
    if (model.isSelected)
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
    }
    else
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
}

#pragma mark    取消闪光灯高亮图片
- (void)closeLight:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = [_cellArray objectAtIndex:indexPath.row +1];
    cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row +1]]];
}

#pragma mark    关闭插件中心
- (void)closePlugin
{
    if (_toPCVdelegate && [_toPCVdelegate respondsToSelector:@selector(closeSelfView:)])
    {
        [_toPCVdelegate closeSelfView:self];
    }
}

- (void)selectOrDeselect:(NSInteger)row isSelected:(BOOL)isSelected
{
    [self closePlugin];
    if (_toSDKdelegate && [_toSDKdelegate respondsToSelector:@selector(selectToolsItemWith:selectIndex:isSelected:)])
    {
        [_toSDKdelegate selectToolsItemWith:self selectIndex:row isSelected:isSelected];
    }
}

@end
