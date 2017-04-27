//
//  EsmitView.m
//  EsmitCal
//
//  Created by Amit Saini on 4/13/17.
//  Copyright © 2017 Amit Saini. All rights reserved.
//

#import "EsmitView.h"
#import "EsmitHeaderView.h"
#import "ViewController.h"
#define headerColor  ([UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f])
#define CellBGColor  ([UIColor colorWithRed:226.0/255.0f green:226.0/255.0f blue:227.0/255.0f alpha:1.0f])
#define CelltodayDateColorBG  ([UIColor colorWithRed:0.0f/255.0f green:40.0f/255.0f blue:191.0f/255.0f alpha:1.0f])
#define CellSelectedColor  ([UIColor colorWithRed:250.0f/255.0f green:0.0f/255.0f blue:16.0f/255.0f alpha:1.0f])
#define CellSelectedLableColor  ([UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f])


@interface EsmitView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation EsmitView
{
    CGRect frames;
    
    //Calculating object
    int numberOfDaysInMonth;
    int numberOfDaysInPreviousMonth;
    int nextMonthCount;
    int previousMonthCount;
    int CurrentYear;
    int CurrentMonth;
    
    UILabel *lblHeader;
    NSMutableArray *arrDates,*arrCheckToday,*arrEvents,*arrFetchEvent,*arrEventCount,*arrSelectedIndex;

    NSString *strCurrentDay,*strDay,*strCheckForDate,*strSelectedDate,*strDidSelect;

}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
   frame.size.width = screenRect.size.width;
    frame.size.height = 410;
    self = [super initWithFrame:frame];
    frames=frame;
    if (self) {
        
        [self commonInitializer];
    }
    return self;
}

-(void)commonInitializer{
    
    arrDates=[NSMutableArray new];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    frames.origin.y=0;
    frames.size.width=self.view.frame.size.width;
    frames.size.height=410;
    _CVCal=[[UICollectionView alloc] initWithFrame:frames collectionViewLayout:layout];
    _CVCal.scrollEnabled=NO;
    
    [_CVCal registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_CVCal setBackgroundColor:[UIColor whiteColor]];
    [layout setMinimumLineSpacing:1];

    _CVCal.dataSource=self;
    _CVCal.delegate=self;
    [self addSubview:_CVCal];
    
    [_CVCal registerClass:[EsmitHeaderView class]
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    
    //Add swipe gesture
    UISwipeGestureRecognizer *RightgestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [RightgestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_CVCal addGestureRecognizer:RightgestureRecognizer];
    
    UISwipeGestureRecognizer *LeftgestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [LeftgestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_CVCal addGestureRecognizer:LeftgestureRecognizer];
    
    [self initailzeArray];
}

#pragma mark - Initialize array
-(void)initailzeArray{
    //initialize array here
    arrDates=[[NSMutableArray alloc]init];
    
    arrCheckToday=[[NSMutableArray alloc]init];
    
    arrEvents=[[NSMutableArray alloc]init];
    
    arrFetchEvent=[[NSMutableArray alloc]init];
    
    arrEventCount=[[NSMutableArray alloc]init];
    
    arrSelectedIndex=[[NSMutableArray alloc]init];
    
    //Get Current Day String
    NSDateFormatter *formatterString = [[NSDateFormatter alloc] init];
    [formatterString setDateFormat:@"MMMM yyyy"];
    strDay = [formatterString stringFromDate:[NSDate date]];
    
    //Get Current Year
    NSDateFormatter *formatterYear = [[NSDateFormatter alloc] init];
    [formatterYear setDateFormat:@"yyyy"];
    CurrentYear = [[formatterYear stringFromDate:[NSDate date]] intValue];
    
    //Get Current Month
    NSDateFormatter *formatterMonth = [[NSDateFormatter alloc] init];
    [formatterMonth setDateFormat:@"MM"];
    previousMonthCount = [[formatterMonth stringFromDate:[NSDate date]] intValue];

    nextMonthCount=previousMonthCount;
    
    previousMonthCount=previousMonthCount-1;
    
    //get number of days in current  month
    numberOfDaysInMonth=[self GetDaysInCurrentMonth];
    
    //get number of days in previous month
    numberOfDaysInPreviousMonth=[self GetDaysInPreviousMonth];
    
    //get first weekday of month stack
    strCurrentDay=[self GetFirstWeekdayofMonth];
    
    //get calendar
    [self GetweekDay:strCurrentDay getPrevious:numberOfDaysInPreviousMonth getCurrentMonth:numberOfDaysInMonth];
}

#pragma mark - Get Days in current month
-(int)GetDaysInCurrentMonth{
    
    //Get days in current month
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    int val=[[NSString stringWithFormat:@"%lu",(unsigned long)range.length] intValue];
    
    return val;
}

#pragma mark - Get Days in Previous Month
-(int)GetDaysInPreviousMonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    // Set your year and month here
    [components setYear:CurrentYear];
    [components setMonth:previousMonthCount];
    
    NSDate *date = [calendar dateFromComponents:components];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    int val2= [[NSString stringWithFormat:@"%lu",(unsigned long)range.length] intValue];
    
    return val2;
}

#pragma mark - Get Days in Next Month
-(int)GetDaysInMonth{
    
    //get days in previous month
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    // Set your year and month here
    [components setYear:CurrentYear];
    [components setMonth:nextMonthCount];
    
    NSDate *date = [calendar dateFromComponents:components];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    int val2= [[NSString stringWithFormat:@"%lu",(unsigned long)range.length] intValue];
    
    return val2;
}

#pragma mark - get first weekday of month stack
-(NSString*)GetFirstWeekdayofNextMonth{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    // Set your year and month here
    [comps setYear:CurrentYear];
    [comps setMonth:nextMonthCount];
    
    NSDate *date = [calendar dateFromComponents:comps];
    
    //get weekday in string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *strWeekDay=[dateFormatter stringFromDate:date];
    
    //Get Current Day String
    NSDateFormatter *formatterString = [[NSDateFormatter alloc] init];
    [formatterString setDateFormat:@"MMMM yyyy"];
    strDay = [formatterString stringFromDate:date];
    lblHeader.text=strDay;
    
    return strWeekDay;
}

////get first weekday of month stack
#pragma mark - get first weekday of month stack
-(NSString*)GetFirstWeekdayofMonth{
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:today];
    
    components.day = 1;
    
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    //get weekday in string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *strWeekDay=[dateFormatter stringFromDate:firstDayOfMonth];
    
    return strWeekDay;
}

#pragma mark - Get Cal
-(void)GetweekDay:(NSString *)weekDay getPrevious:(int)PreviousMonth getCurrentMonth :(int)CurrentMonthCount
{
    
    if ([weekDay isEqualToString:@"Sunday"]) {
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            
            [self GetCurrentDay:i andAddedDays:-1];
        }
        
        if ([arrDates count]%7==0) {
            
            [_CVCal reloadData];
            
            return;
            
        }else{
            
            for (int i=1; i<30; i++) {
                
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                
                if ([arrDates count]% 7==0) {
                    
                    [_CVCal reloadData];

                    return;
                }
            }
        }
    }
    else if ([weekDay isEqualToString:@"Monday"]) {
        
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
            
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            
            [self GetCurrentDay:i andAddedDays:0];
        }
        
        if ([arrDates count]%7==0) {
            
            [_CVCal reloadData];

            return;
            
        }else{
            
            for (int i=1; i<30; i++) {
                
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                
                if ([arrDates count]% 7==0) {
                    
                    [_CVCal reloadData];
                    
                    return;
                }
            }
        }
    }
    else if ([weekDay isEqualToString:@"Tuesday"]) {
        
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]-1; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [self GetCurrentDay:i andAddedDays:1];
        }
        
        if ([arrDates count]%7==0) {
            [_CVCal reloadData];
            return;
        }else{
            for (int i=1; i<30; i++) {
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                if ([arrDates count]% 7==0) {
                    [_CVCal reloadData];
                    return;
                }
            }
        }
    }
    else if ([weekDay isEqualToString:@"Wednesday"]) {
        
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]-2; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [self GetCurrentDay:i andAddedDays:2];
        }
        
        if ([arrDates count]%7==0) {
            [_CVCal reloadData];
            return;
        }else{
            for (int i=1; i<30; i++) {
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                if ([arrDates count]% 7==0) {
                    [_CVCal reloadData];
                    return;
                }
            }
        }
    }
    else if ([weekDay isEqualToString:@"Thursday"]) {
        
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]-3; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [self GetCurrentDay:i andAddedDays:3];
        }
        
        if ([arrDates count]%7==0) {
            [_CVCal reloadData];
            return;
            
        }else{
            for (int i=1; i<30; i++) {
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                if ([arrDates count]% 7==0) {
                    [_CVCal reloadData];
                    return;
                }
            }
        }
    }
    
    else if ([weekDay isEqualToString:@"Friday"]) {
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]-4; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [self GetCurrentDay:i andAddedDays:4];
        }
        
        if ([arrDates count]%7==0) {
            [_CVCal reloadData];
            return;
        }else{
            for (int i=1; i<30; i++) {
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                if ([arrDates count]% 7==0) {
                    [_CVCal reloadData];
                    return;
                }
            }
        }
    }
    else{
        
        for (int i=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]-5; i<=[[NSString stringWithFormat:@"%ld",(long)PreviousMonth] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [arrCheckToday addObject:@"previous"];
            [arrEvents addObject:@"no"];
            [arrEventCount addObject:@"no"];
        }
        
        for (int i=1; i<=[[NSString stringWithFormat:@"%ld",(long)CurrentMonthCount] intValue]; i++) {
            [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
            [self GetCurrentDay:i andAddedDays:5];
        }
        
        if ([arrDates count]%7==0) {
            [_CVCal reloadData];
            return;
        }else{
            for (int i=1; i<30; i++) {
                [arrDates addObject:[NSString stringWithFormat:@"%d",i]];
                [arrCheckToday addObject:@"next"];
                [arrEvents addObject:@"no"];
                [arrEventCount addObject:@"no"];
                if ([arrDates count]% 7==0) {
                    [_CVCal reloadData];
                    return;
                }
            }
        }
    }
}

#pragma mark - Check for today
-(void)GetCurrentDay:(int)index andAddedDays:(int)Days{
    //get weekday in string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d,MMMM yyyy"];
    NSString *strWeekDay=[dateFormatter stringFromDate:[NSDate date]];
    NSString *strToday=[NSString stringWithFormat:@"%@,%@",[arrDates objectAtIndex:index+Days],strDay];
    if ([strWeekDay isEqualToString:strToday]) {
        [arrCheckToday addObject:@"yes"];
    }
    else{
        [arrCheckToday addObject:strToday];
    }
}

#pragma mark - Collection View Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrDates count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    for (UILabel *lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UILabel class]])
        {
            [lbl removeFromSuperview];
        }
    }
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    lblDate.textAlignment=NSTextAlignmentCenter;
    lblDate.text=[arrDates objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lblDate];
    
    //get weekday in string
    if ([[arrCheckToday objectAtIndex:indexPath.row]isEqualToString:@"yes"]) {
        lblDate.backgroundColor=CelltodayDateColorBG;
        lblDate.textColor=[UIColor whiteColor];
        //lblDate.font=[UIFont boldSystemFontOfSize:16];
        lblDate.numberOfLines = 1;
        lblDate.minimumScaleFactor = 10;
        lblDate.adjustsFontSizeToFitWidth = YES;
    }
    else{
        cell.backgroundColor=CellBGColor;
        lblDate.textColor=[UIColor blackColor];
    }
    
    //Change selected index background color
    if ([arrSelectedIndex containsObject:indexPath]){
        lblDate.textColor=CellSelectedLableColor;
        lblDate.backgroundColor=CellSelectedColor;
    }
    else{
        cell.backgroundColor=CellBGColor;
    }
    
    //set light color for previous and next dates
    if ([[arrCheckToday objectAtIndex:indexPath.row]isEqualToString:@"next"]||[[arrCheckToday objectAtIndex:indexPath.row]isEqualToString:@"previous"]) {
        lblDate.textColor=[UIColor lightGrayColor];
    }
    //Apply animation for next and previous button
    if ([strDidSelect isEqualToString:@"yes"]) {
        

    }
    else{
        CGRect finalCellFrame = cell.frame;
        //check the scrolling direction to verify from which side of the screen the cell should come.
        CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
        if (translation.x > 0) {
            cell.frame = CGRectMake(finalCellFrame.origin.x - 2000, - 10.0f, 0, 0);
        } else {
            cell.frame = CGRectMake(finalCellFrame.origin.x + 2000, - 10.0f, 0, 0);
        }
        
        [UIView animateWithDuration:0.1f animations:^(void){
            cell.frame = finalCellFrame;
        }];
    }
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //Store array index for set selected index color
    arrSelectedIndex=[NSMutableArray new];
    [arrSelectedIndex addObject:indexPath];
    
    if ([[arrCheckToday objectAtIndex:indexPath.row]isEqualToString:@"next"]) {
        [self NextBtnAction];
        strDidSelect=@"no";
    }
    else if ([[arrCheckToday objectAtIndex:indexPath.row]isEqualToString:@"previous"]){
        [self PreviousBtnAction];
        strDidSelect=@"no";
    }
    
    else{
        [self.delegate didSelectDate:[arrCheckToday objectAtIndex:indexPath.row]];
        strDidSelect=@"yes";
    }
    
    [self.CVCal reloadData];
    [self.CVCal performBatchUpdates:^{}
                                  completion:^(BOOL finished) {
                                      /// collection-view finished reload
                                      strDidSelect=@"no";
                                  }];
   }

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_CVCal.frame.size.width/7-1, _CVCal.frame.size.height/8-5);
}

#pragma mark - Collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 1, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [self.CVCal layoutAttributesForItemAtIndexPath:indexPath];

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        
        EsmitHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        for (UILabel *lbl in headerView.subviews){
            if ([lbl isKindOfClass:[UILabel class]])
            {
                [lbl removeFromSuperview];
            }
        }
        headerView.backgroundColor=headerColor;
        UILabel *lblSun=[[UILabel alloc]initWithFrame:CGRectMake(0, 52, attributes.frame.size.width, 15)];
        lblSun.text=@"Sun";
        lblSun.font=[UIFont systemFontOfSize:12];
        lblSun.textAlignment=NSTextAlignmentCenter;
        [headerView addSubview:lblSun];
        
        UILabel *lblMon=[[UILabel alloc]initWithFrame:CGRectMake(lblSun.frame.origin.x+lblSun.frame.size.width+2, 52, attributes.frame.size.width, 15)];
        lblMon.text=@"Mon";
        lblMon.textAlignment=NSTextAlignmentCenter;
        lblMon.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblMon];
        
        UILabel *lblTue=[[UILabel alloc]initWithFrame:CGRectMake(lblMon.frame.origin.x+lblMon.frame.size.width, 52, attributes.frame.size.width, 15)];
        lblTue.text=@"Tue";
        lblTue.textAlignment=NSTextAlignmentCenter;
        lblTue.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblTue];
        
        UILabel *lblWed=[[UILabel alloc]initWithFrame:CGRectMake(lblTue.frame.origin.x+lblTue.frame.size.width, 52, attributes.frame.size.width, 15)];
        lblWed.text=@"Wed";
        lblWed.textAlignment=NSTextAlignmentCenter;
        lblWed.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblWed];
        
        UILabel *lblThu=[[UILabel alloc]initWithFrame:CGRectMake(lblWed.frame.origin.x+lblWed.frame.size.width+1, 52, attributes.frame.size.width, 15)];
        lblThu.text=@"Thu";
        lblThu.textAlignment=NSTextAlignmentCenter;
        lblThu.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblThu];
        
        UILabel *lblFri=[[UILabel alloc]initWithFrame:CGRectMake(lblThu.frame.origin.x+lblThu.frame.size.width+2, 52, attributes.frame.size.width, 15)];
        lblFri.text=@"Fri";
        lblFri.textAlignment=NSTextAlignmentCenter;
        lblFri.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblFri];
        
        UILabel *lblSat=[[UILabel alloc]initWithFrame:CGRectMake(lblFri.frame.origin.x+lblFri.frame.size.width, 52, attributes.frame.size.width, 15)];
        lblSat.text=@"Sat";
        lblSat.textAlignment=NSTextAlignmentCenter;
        lblSat.font=[UIFont systemFontOfSize:12];
        [headerView addSubview:lblSat];
        
        //Header title
        lblHeader=[[UILabel alloc]initWithFrame:CGRectMake(headerView.frame.size.width/2-170/2, 8, 170, 21)];
        lblHeader.text=@"April 2017";
        lblHeader.textAlignment=NSTextAlignmentCenter;
        lblHeader.font=[UIFont boldSystemFontOfSize:17];
        [headerView addSubview:lblHeader];
        
        lblHeader.text=strDay;
        
        UIImageView *imgNext=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-42, 10, 30, 30)];
        imgNext.image=[UIImage imageNamed:@"next"];
        [headerView addSubview:imgNext];
        
        UIImageView *imgPrevious=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        imgPrevious.image=[UIImage imageNamed:@"previous"];
        [headerView addSubview:imgPrevious];
        
        UIButton *btnNext=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-67, 0, 67, 50)];
        btnNext.titleLabel.font=[UIFont systemFontOfSize:15];
        btnNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btnNext setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(NextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btnNext];
        
        UIButton *btnPrevious=[[UIButton alloc]initWithFrame:CGRectMake(10, 6, 67, 40)];
        btnPrevious.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        btnPrevious.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        btnPrevious.titleLabel.font=[UIFont systemFontOfSize:15];
        btnPrevious.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnPrevious setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnPrevious addTarget:self action:@selector(PreviousBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btnPrevious];
        
        reusableview = headerView;
        return reusableview;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
        return CGSizeMake(0, 70);
}

#pragma mark - Previous Button Action
-(void)PreviousBtnAction{
    arrDates=[[NSMutableArray alloc]init];
    arrCheckToday=[[NSMutableArray alloc]init];
    arrEvents=[[NSMutableArray alloc]init];
    arrEventCount=[[NSMutableArray alloc]init];
    arrSelectedIndex=[[NSMutableArray alloc]init];

    //get number of days in current  month
    nextMonthCount=nextMonthCount-1;
    previousMonthCount=nextMonthCount-1;
    numberOfDaysInMonth=[self GetDaysInMonth];
    numberOfDaysInPreviousMonth=[self GetDaysInPreviousMonth];
    
    //get first weekday of month stack
    strCurrentDay=[self GetFirstWeekdayofNextMonth];
    
    //get calendar
    [self GetweekDay:strCurrentDay getPrevious:numberOfDaysInPreviousMonth getCurrentMonth:numberOfDaysInMonth];
}

#pragma mark - Next Button Action
-(void)NextBtnAction{
    arrDates=[[NSMutableArray alloc]init];
    arrCheckToday=[[NSMutableArray alloc]init];
    arrEvents=[[NSMutableArray alloc]init];
    arrEventCount=[[NSMutableArray alloc]init];
    arrSelectedIndex=[[NSMutableArray alloc]init];
    
    //get number of days in current month
    nextMonthCount=nextMonthCount+1;
    previousMonthCount=previousMonthCount+1;
    numberOfDaysInMonth=[self GetDaysInMonth];
    numberOfDaysInPreviousMonth=[self GetDaysInPreviousMonth];
    
    //get first weekday of month stack
    strCurrentDay=[self GetFirstWeekdayofNextMonth];
    
    //get calendar
    [self GetweekDay:strCurrentDay getPrevious:numberOfDaysInPreviousMonth getCurrentMonth:numberOfDaysInMonth];
}


#pragma mark - Add swipe gesture
-(void)swipeRight:(UISwipeGestureRecognizer *)recognizer{
    [self PreviousBtnAction];
}

#pragma mark - Add swipe gesture
-(void)swipeLeft:(UISwipeGestureRecognizer *)recognizer{
    [self NextBtnAction];
}

@end
