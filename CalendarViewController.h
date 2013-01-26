//
//  CalendarViewController.h
//  Calendar
//
//  Created by JohnFelix on 1/1/13.
//  Copyright (c) 2013 JohnFelix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *monthYear;
@property(nonatomic, strong) UIButton *nextMonth;
@property(nonatomic, strong) UIButton *previousMonth;

@property(nonatomic) NSArray *months;
@property(nonatomic) NSArray *numberOfDays;
@property(nonatomic) NSArray *weekDayNames;
@property(nonatomic) NSInteger currentMonth;
@property(nonatomic) NSInteger currentYear;
@property(nonatomic) NSInteger currentDay;

@property(nonatomic, strong)id delegate;

-(void) moveToNextMonth;
-(void) moveToPreviousMonth;
-(void) dayOnClick:(UIButton *) sender;
@end
