//
//  CalendarViewController.m
//  Calendar
//
//  Created by JohnFelix on 1/1/13.
//  Copyright (c) 2013 JohnFelix. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()
@property(nonatomic) NSInteger firstDay;
-(BOOL) isLeapYear:(NSInteger ) year;
-(NSInteger) firstDayIndexOfMonth:(NSInteger) month AndYear:( NSInteger) year;
-(NSArray *)monthAndYear:(NSDate *)date;
@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numberOfDays = [NSArray arrayWithObjects:@"", @"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
    _weekDayNames = [NSArray arrayWithObjects:@"", @"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    _months = [NSArray arrayWithObjects:@"", @"Jan",
                                        @"Feb",
                                        @"Mar",
                                        @"Apr",
                                        @"May",
                                        @"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DayView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"dayview"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MonthYearView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"monthyearview"];
    
    NSArray *monthYear = [self monthAndYear:[NSDate date]];
    _currentMonth = [_months indexOfObject:[monthYear objectAtIndex:0]];
    _currentYear = [[monthYear objectAtIndex:1] integerValue];
    _currentDay = [_weekDayNames indexOfObject:[monthYear objectAtIndex:2]];
    
    _firstDay = [self firstDayIndexOfMonth:_currentMonth AndYear:_currentYear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) moveToNextMonth
{
    if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear = _currentYear + 1;
    } else{
        _currentMonth = _currentMonth + 1;
    }
    [_monthYear setText:[NSString stringWithFormat:@"%@ %d", [_months objectAtIndex:_currentMonth], _currentYear]];
    _firstDay = [self firstDayIndexOfMonth:_currentMonth AndYear:_currentYear];

    [_collectionView reloadData];
}

-(void)moveToPreviousMonth
{
    if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear = _currentYear - 1;
    } else{
        _currentMonth = _currentMonth - 1;
    }
    [_monthYear setText:[NSString stringWithFormat:@"%@ %d", [_months objectAtIndex:_currentMonth], _currentYear]];
    _firstDay = [self firstDayIndexOfMonth:_currentMonth AndYear:_currentYear];

    [_collectionView reloadData];
}

-(void) dayOnClick:(UIButton *) sender{
    NSString *currentDate = [NSString stringWithFormat:@"%@ %@, %d", [_months objectAtIndex: _currentMonth], [sender titleForState:UIControlStateNormal], _currentYear];
    
    if ([_delegate respondsToSelector:@selector(getDate:)]) {
        [_delegate performSelector:@selector(getDate:) withObject:currentDate];
    }
    
    NSLog(@"currentDate: %@",currentDate);
    
}

#pragma mark - Private Methods
-(BOOL) isLeapYear:(NSInteger ) year
{
    if(year % 400 ==0 || ( year % 100 != 0 && year%4 == 0))
        return true;
    
    return false;
}
-(NSArray *)monthAndYear:(NSDate *)date
{
    if(!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle ];
    
    NSDateFormatter *weekDayFormatter = [[NSDateFormatter alloc] init];
    [weekDayFormatter setDateStyle:NSDateFormatterFullStyle];
    
    NSString *weekDayFormattedDate = [weekDayFormatter stringFromDate:date];
    NSString *weekDay = [[weekDayFormattedDate componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    NSArray *splittedDate = [formattedDate componentsSeparatedByString:@","];
    NSNumber *year= [splittedDate objectAtIndex:1];
    NSString *monthDate = [splittedDate objectAtIndex:0];
    
    NSString *month = [[monthDate componentsSeparatedByString:@" "] objectAtIndex:0];
    return [NSArray arrayWithObjects: month, year, weekDay, nil];
}

-(NSInteger) firstDayIndexOfMonth:(NSInteger) month AndYear:( NSInteger) year
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:month];
    [components setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *firstDayDate = [gregorian dateFromComponents:components];
    
    
    NSArray *firstDayMonthYearName = [self monthAndYear:firstDayDate];
    
    NSInteger firstDay = [_weekDayNames indexOfObject:[firstDayMonthYearName objectAtIndex:2]];
    return firstDay;
}
#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 35;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     UICollectionViewCell *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"monthyearview" forIndexPath:indexPath];
    
    _monthYear = (UILabel *)[supplementaryView viewWithTag:20];
    _previousMonth = (UIButton *)[supplementaryView viewWithTag:10];
    _nextMonth = (UIButton *)[supplementaryView viewWithTag:30];
    [_previousMonth addTarget:self action:@selector(moveToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [_nextMonth addTarget:self action:@selector(moveToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [_monthYear setText:[NSString stringWithFormat:@"%@ %d", [_months objectAtIndex:_currentMonth], _currentYear]];
    
    
    return supplementaryView;
}

#pragma mark - UICollectionViewDelegate Methods
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayview" forIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:10];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dayview.png"]];
    
    if (indexPath.row+1 < _firstDay) {
        [button setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    } else if(indexPath.row+1 > [[_numberOfDays objectAtIndex:_currentMonth] integerValue]+_firstDay-
              1 ){
        [button setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];        
    }else{
        [button setTitle:[NSString stringWithFormat:@"%d",indexPath.row+2-_firstDay] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dayOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


@end
