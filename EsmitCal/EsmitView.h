//
//  EsmitView.h
//  EsmitCal
//
//  Created by Amit Saini on 4/13/17.
//  Copyright © 2017 Amit Saini. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EsmitCalDelegates
@required

-(void)didSelectDate:(NSString *)str;
@end
@interface EsmitView : UIView

@property (nonatomic, strong) UICollectionView *CVCal;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<EsmitCalDelegates> delegate;


@end
