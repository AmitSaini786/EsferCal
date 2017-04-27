//
//  ViewController.m
//  EsmitCal
//
//  Created by Amit Saini on 4/13/17.
//  Copyright © 2017 Amit Saini. All rights reserved.
//

#import "ViewController.h"
#import "EsmitView.h"

@interface ViewController ()<EsmitCalDelegates>
{
    EsmitView *cal;
    IBOutlet UILabel *lblDate;
}

@end

@implementation ViewController

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    
    cal = [[EsmitView alloc]initWithFrame:CGRectMake(0,60, 200, 200)];
    [self.view addSubview:cal];
    cal.delegate=self;
    [super viewDidLoad];
}

#pragma mark - EsferCal Delegates
-(void)didSelectDate:(NSString *)stringDate{
    NSLog(@"Your Selected date is= %@",stringDate);
    lblDate.text=stringDate;
}

#pragma mark - Handling Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
