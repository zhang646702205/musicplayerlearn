//
//  GMViewController.h
//  bf
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMViewController : UIViewController<UITableViewDataSource,AVAudioPlayerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *lrc;
@property (weak, nonatomic) IBOutlet UILabel *songDetail;
@property (weak, nonatomic) IBOutlet UISlider *TimeValue;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *songInfo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)buttonClick:(UIButton *)sender;
- (IBAction)progress:(UISlider *)sender;



@end
