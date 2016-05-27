//
//  HXTScrollImageView.h
//  HXTScrollImage
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXTScrollImageView;

@protocol HXTScrollImageViewDelegate <NSObject>
@optional
- (void)HXTScrollImageView:(HXTScrollImageView *)scrollImageView didTapImageIndex:(NSInteger)index;
@end

@interface HXTScrollImageView : UIView

@property (weak,nonatomic) id<HXTScrollImageViewDelegate> delegate;
+ (instancetype)viewWithImgNameArr:(NSArray *)nameArr frame:(CGRect)frame;

@end
