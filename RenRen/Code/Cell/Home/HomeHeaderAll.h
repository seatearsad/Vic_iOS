//
//  HomeHeaderAll.h
//  KYRR
//
//  Created by kyjun on 15/10/30.
//
//

#import <UIKit/UIKit.h>
#import "HomeSectionDelegate.h"

@interface HomeHeaderAll : UICollectionReusableView
@property(nonatomic,strong ,nullable) UITextField* txtSearch;
@property(nonatomic,strong ,nullable) UIButton *btnSection;
@property(nonatomic,weak) id<HomeSectionDelegate> delegate;


-(void)loadAdvWithTop:(nullable NSArray*)top;
-(void)loadAdvWithBottom:(nullable NSArray*)bottom;
-(void)loadNotice:(nullable NSString*)notice;
-(void)loadBuyNow:(MBuyNow*)buyNow fightGroup:(MFightGroup*)fightGroup;
@end