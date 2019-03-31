//
//  HMSegmentedControl.h
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012-2015 Hesham Abd-Elmegid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSegmentedControl;

typedef void (^IndexChangeBlock)(NSInteger index);
typedef NSAttributedString *(^HMTitleFormatterBlock)(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected);

/**
 Segmented类型
 
 - HMSegmentedControlTypeText: 纯文字
 - HMSegmentedControlTypeImages: 纯图片
 - HMSegmentedControlTypeTextImages: 文字、图片组合
 */
typedef NS_ENUM(NSInteger, HMSegmentedControlType)
{
    HMSegmentedControlTypeText,
    HMSegmentedControlTypeImages,
    HMSegmentedControlTypeTextImages
};

/**
 单个控件宽度
 
 - HMSegmentedControlSegmentWidthStyleFixed: 1、当控件总宽度小于等于父视图宽度时，单个控件宽度等于均等分父视图宽度；2、当控件总宽度大于父视图宽度时，取最大宽度控件的宽作为单个控件的宽度
 - HMSegmentedControlSegmentWidthStyleDynamic: 控件的宽度等于文字或者图片的最大宽度
 - HMSegmentedControlSegmentWidthStyleDynamicFixedSuperView: 1、当控件总宽度小于等于父视图宽度时，单个控件宽度等于均等分父视图宽度；2、当控件总宽度大于父视图宽度时，控件的宽度等于文字或者图片的最大宽度。注意：当前只对Segmented类型为HMSegmentedControlTypeText的进行了适配
 */
typedef NS_ENUM(NSInteger, HMSegmentedControlSegmentWidthStyle)
{
    HMSegmentedControlSegmentWidthStyleFixed,
    HMSegmentedControlSegmentWidthStyleDynamic,
    HMSegmentedControlSegmentWidthStyleDynamicFixedSuperView,
};

/**
 当Segmented类型为HMSegmentedControlTypeTextImages时，图片相对于文字的位置
 
 - HMSegmentedControlImagePositionBehindText: 图片在文字的背后
 - HMSegmentedControlImagePositionLeftOfText: 图片在文字的左边
 - HMSegmentedControlImagePositionRightOfText: 图片在文字的右边
 - HMSegmentedControlImagePositionAboveText: 图片在文字的上边
 - HMSegmentedControlImagePositionBelowText: 图片在文字的下边
 */
typedef NS_ENUM(NSInteger, HMSegmentedControlImagePosition)
{
    HMSegmentedControlImagePositionBehindText,
    HMSegmentedControlImagePositionLeftOfText,
    HMSegmentedControlImagePositionRightOfText,
    HMSegmentedControlImagePositionAboveText,
    HMSegmentedControlImagePositionBelowText
};

/**
 下标类型以及宽度是否充满当前控件
 
 - HMSegmentedControlSelectionStyleTextWidthStripe: 下标为下划线类型，并且宽度等于文字的宽度
 - HMSegmentedControlSelectionStyleFullWidthStripe: 下标为下划线类型，并且宽度等于当前控件的宽度
 - HMSegmentedControlSelectionStyleBox: 没有下标，一个矩形框
 - HMSegmentedControlSelectionStyleArrow: 向下箭头
 */
typedef NS_ENUM(NSInteger, HMSegmentedControlSelectionStyle)
{
    HMSegmentedControlSelectionStyleTextWidthStripe,
    HMSegmentedControlSelectionStyleFullWidthStripe,
    HMSegmentedControlSelectionStyleBox,
    HMSegmentedControlSelectionStyleArrow
};

/**
 下标位置
 
 - HMSegmentedControlSelectionIndicatorLocationUp: 位于控件上方
 - HMSegmentedControlSelectionIndicatorLocationDown: 位于控件下方
 - HMSegmentedControlSelectionIndicatorLocationNone: 无下标
 */
typedef NS_ENUM(NSInteger, HMSegmentedControlSelectionIndicatorLocation)
{
    HMSegmentedControlSelectionIndicatorLocationUp,
    HMSegmentedControlSelectionIndicatorLocationDown,
    HMSegmentedControlSelectionIndicatorLocationNone // No selection indicator
};

/**
 边框类型
 
 - HMSegmentedControlBorderTypeNone: 无边框
 - HMSegmentedControlBorderTypeTop: 上面有边框
 - HMSegmentedControlBorderTypeLeft: 左边有边框
 - HMSegmentedControlBorderTypeBottom: 下面有边框
 - HMSegmentedControlBorderTypeRight: 右边有边框
 */
typedef NS_OPTIONS(NSInteger, HMSegmentedControlBorderType)
{
    HMSegmentedControlBorderTypeNone = 0,
    HMSegmentedControlBorderTypeTop = (1 << 0),
    HMSegmentedControlBorderTypeLeft = (1 << 1),
    HMSegmentedControlBorderTypeBottom = (1 << 2),
    HMSegmentedControlBorderTypeRight = (1 << 3)
};

enum
{
    HMSegmentedControlNoSegment = -1   // Segment index for no selected segment
};


@interface HMSegmentedControl : UIControl

/**
 标题
 */
@property (nonatomic, strong) NSArray<NSString *>   *sectionTitles;

/**
 图片
 */
@property (nonatomic, strong) NSArray<UIImage *>    *sectionImages;

/**
 选中图片
 */
@property (nonatomic, strong) NSArray<UIImage *>    *sectionSelectedImages;

/**
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/**
 Used to apply custom text styling to titles when set.
 
 When this block is set, no additional styling is applied to the `NSAttributedString` object returned from this block.
 */
@property (nonatomic, copy) HMTitleFormatterBlock titleFormatter;

/**
 Text attributes to apply to item title text.
 */
@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;

/*
 Text attributes to apply to selected item title text.
 
 Attributes not set in this dictionary are inherited from `titleTextAttributes`.
 */
@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SELECTOR;

/**
 Segmented control background color.
 
 Default is `[UIColor whiteColor]`
 */
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 Color for the selection indicator stripe
 
 Default is `R:52, G:181, B:229`
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;

/**
 Color for the selection indicator box
 
 Default is selectionIndicatorColor
 */
@property (nonatomic, strong) UIColor *selectionIndicatorBoxColor UI_APPEARANCE_SELECTOR;

/**
 Color for the vertical divider between segments.
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *verticalDividerColor UI_APPEARANCE_SELECTOR;

/**
 Opacity for the seletion indicator box.
 
 Default is `0.2f`
 */
@property (nonatomic) CGFloat selectionIndicatorBoxOpacity;

/**
 Width the vertical divider between segments that is added when `verticalDividerEnabled` is set to YES.
 
 Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat verticalDividerWidth;

/**
 Specifies the style of the control
 
 Default is `HMSegmentedControlTypeText`
 */
@property (nonatomic, assign) HMSegmentedControlType type;

/**
 Specifies the style of the selection indicator.
 
 Default is `HMSegmentedControlSelectionStyleTextWidthStripe`
 */
@property (nonatomic, assign) HMSegmentedControlSelectionStyle selectionStyle;

/**
 Specifies the style of the segment's width.
 
 Default is `HMSegmentedControlSegmentWidthStyleFixed`
 */
@property (nonatomic, assign) HMSegmentedControlSegmentWidthStyle segmentWidthStyle;

/**
 Specifies the location of the selection indicator.
 
 Default is `HMSegmentedControlSelectionIndicatorLocationUp`
 */
@property (nonatomic, assign) HMSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

/*
 Specifies the border type.
 
 Default is `HMSegmentedControlBorderTypeNone`
 */
@property (nonatomic, assign) HMSegmentedControlBorderType borderType;

/**
 Specifies the image position relative to the text. Only applicable for HMSegmentedControlTypeTextImages
 
 Default is `HMSegmentedControlImagePositionBehindText`
 */
@property (nonatomic) HMSegmentedControlImagePosition imagePosition;

/**
 Specifies the image position relative to the text. Only applicable for HMSegmentedControlTypeTextImages
 
 Default is `HMSegmentedControlImagePositionBehindText`
 */
@property (nonatomic) CGSize imageSize;

/**
 Specifies the distance between the text and the image. Only applicable for HMSegmentedControlTypeTextImages
 
 Default is `0,0`
 */
@property (nonatomic) CGFloat textImageSpacing;

/**
 Specifies the border color.
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 Specifies the border width.
 
 Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 Default is YES. Set to NO to deny scrolling by dragging the scrollView by the user.
 */
@property(nonatomic, getter = isUserDraggable) BOOL userDraggable;

/**
 Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled) BOOL touchEnabled;

/**
 Default is NO. Set to YES to show a vertical divider between the segments.
 */
@property(nonatomic, getter = isVerticalDividerEnabled) BOOL verticalDividerEnabled;

/**
 当控件总宽度小于父视图宽度时，是否需要占满父视图的宽度，默认为“否”。注意：当前只对HMSegmentedControlTypeTextImages有效
 */
@property (nonatomic, assign) BOOL shouldStretchSegmentsToSuperViewSize;

/**
 Index of the currently selected segment.
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 Height of the selection indicator. Only effective when `HMSegmentedControlSelectionStyle` is either `HMSegmentedControlSelectionStyleTextWidthStripe` or `HMSegmentedControlSelectionStyleFullWidthStripe`.
 
 Default is 5.0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;

/**
 Edge insets for the selection indicator.
 NOTE: This does not affect the bounding box of HMSegmentedControlSelectionStyleBox
 
 When HMSegmentedControlSelectionIndicatorLocationUp is selected, bottom edge insets are not used
 
 When HMSegmentedControlSelectionIndicatorLocationDown is selected, top edge insets are not used
 
 Defaults are top: 0.0f
 left: 0.0f
 bottom: 0.0f
 right: 0.0f
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;

/**
 Inset left and right edges of segments.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

@property (nonatomic, readwrite) UIEdgeInsets enlargeEdgeInset;

/**
 Default is YES. Set to NO to disable animation during user selection.
 */
@property (nonatomic) BOOL shouldAnimateUserSelection;

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles;
- (id)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages;
- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages titlesForSections:(NSArray<NSString *> *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;
- (void)setTitleFormatter:(HMTitleFormatterBlock)titleFormatter;

@end
