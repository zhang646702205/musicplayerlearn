//
//  GMViewController.m
//  bf
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 GM. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "GMViewController.h"
#import "LrcAnalysis.h"
@interface GMViewController ()

@end

@implementation GMViewController
{
    AVAudioPlayer *_audioPlayer;
    float voice;
    NSTimer *_timerChange;
    NSInteger min;
    NSInteger second;
    NSInteger currentSong;
    NSMutableArray *_songsArray;
    LrcAnalysis *lrcAnalysis;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _songsArray = [[NSMutableArray alloc]init];
    [self prepareData];
    [self creatAudioPlayer];
    [self timeInit];
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) style:<#(UITableViewStyle)#>];
        _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.backgroundColor = [UIColor redColor];
    currentSong = 0;
}

- (void)prepareData{
    NSArray *ary = @[@"像梦一样自由",@"北京北京",@"小苹果",@"春天里",@"蓝莲花"];
    [_songsArray addObjectsFromArray:ary];
}
#pragma mark 播放器
- (void)creatAudioPlayer{
    
    
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[self audioUrl:_songsArray[currentSong]] error:nil];
    NSString *bundle = [[NSBundle mainBundle]pathForResource:_songsArray[currentSong] ofType:@"lrc"];

    NSLog(@"%@",bundle);
    lrcAnalysis = [[LrcAnalysis alloc]initSongLrcFile:bundle];
    
    [_audioPlayer prepareToPlay];
    _audioPlayer.delegate = self;
    voice = _audioPlayer.volume;
    [self songInfoItem];
    //bundle = nil;
}
- (NSURL *)audioUrl:(NSString *)str{
    NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    return url;
}
- (void)songInfoItem{
    NSString *string = [NSString stringWithFormat:@"专辑:%@\n歌手:%@\n作者:%@\n主题:%@",lrcAnalysis.record,lrcAnalysis.artist,lrcAnalysis.author,lrcAnalysis.title];
    _songInfo.text = string;
}
#pragma mark lrc
- (NSString *)getlrcBySliderValue{
    
    return  [lrcAnalysis getLrcByTime:(float)_slider.value*_audioPlayer.duration];
}

#pragma marlk 定时器相关
- (void)timeInit{
    _timerChange = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [_timerChange setFireDate:[NSDate distantFuture ]];
}
- (void)onTimer{

    if (++second %15== 0) {
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%02d.jpg",arc4random()%13 + 1]];
        _imageView.animationDuration = 0.8;
    }
    _slider.value = _audioPlayer.currentTime/_audioPlayer.duration;
    _time.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)_audioPlayer.currentTime/60,(NSInteger)_audioPlayer.currentTime%60];
    _lrc.text = [self getlrcBySliderValue];
    
}
#pragma mark 按钮
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 100) {// 上一曲
        [_audioPlayer stop];
         [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0]].textLabel.textColor = [UIColor blackColor];
        if (--currentSong < 0) {
            currentSong = 4;
        }
//        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        _time.text = @"00:00";
        _slider.value = 0;
        [self creatAudioPlayer];
        [_audioPlayer play];
//         [_tableView reloadData];
        [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0]].textLabel.textColor = [UIColor redColor];
    }else if(sender.tag == 101){// 开始、暂停
        if (sender.selected == NO) {
           [_audioPlayer play];
            [_timerChange setFireDate:[NSDate distantPast]];
        }else{
            [_audioPlayer pause];
            [_timerChange setFireDate:[NSDate distantFuture ]];
        }
        sender.selected = !sender.selected;
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
        }
    }else if(sender.tag == 102){// 下一曲
        [_audioPlayer stop];
//         [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0] animated:YES];
        [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0]].textLabel.textColor = [UIColor blackColor];
        if (++currentSong > 4) {
            currentSong = 0;
        }
        _time.text = @"00:00";
        _slider.value = 0;
        [self creatAudioPlayer];
        [_audioPlayer play];
//        [_tableView reloadData];
//        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0]].textLabel.textColor = [UIColor redColor];

    }else if(sender.tag == 103){ // 停止
       [_audioPlayer stop];
        [_timerChange setFireDate:[NSDate distantFuture ]];
        _slider.value = 0.0;
        _time.text = @"00:00";
        _audioPlayer.currentTime = 0.0f;
        UIButton *button = (UIButton *)[self.view viewWithTag:101];
        button.selected = NO;
    }else if(sender.tag == 104){ // 小音量
        if (_audioPlayer.volume>0 ) {
            _audioPlayer.volume -= 0.1;
            voice = _audioPlayer.volume;
        }else{
            _audioPlayer.volume = 0;
            voice = _audioPlayer.volume;
        }
    }else if(sender.tag == 105){ // 大音量
       if (_audioPlayer.volume<1 ) {
           _audioPlayer.volume += 0.1;
           voice = _audioPlayer.volume;
        }
    }else if(sender.tag == 106){ // 静音
        sender.selected = !sender.selected;
        if (sender.selected) {
            [_audioPlayer setVolume:0.0];
        }else{
            [_audioPlayer setVolume:voice];
            
        }
    }else{ // 循环
        sender.selected = !sender.selected;
        [sender setImage:[UIImage imageNamed:@"循环播放选中"] forState:UIControlStateSelected];
    }
}

- (IBAction)progress:(UISlider *)sender {
    
    _audioPlayer.currentTime = _slider.value*_audioPlayer.duration;
    _time.text = [NSString stringWithFormat:@"%02d:%02d",(int)_audioPlayer.currentTime/60,(int)_audioPlayer.currentTime%60];
   
}
#pragma mark audio 协议中的方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_audioPlayer stop];
    if (++currentSong > 4) {
        currentSong = 0;
    }
    _time.text = @"00:00";
    _slider.value = 0;
    [self creatAudioPlayer];
    [_audioPlayer play];
   

}
#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _songsArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _songsArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
 
    if (indexPath.row == currentSong) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if ([_audioPlayer isPlaying]) {
        if (indexPath.row != currentSong) {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSong inSection:0]].textLabel.textColor = [UIColor blackColor];
             [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor redColor];
            [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
            NSInteger tem = currentSong;
            currentSong = indexPath.row;
            [_audioPlayer stop];
            _time.text = @"00:00";
            _slider.value = 0;
            [self creatAudioPlayer];
            [_audioPlayer play];
            NSIndexPath *dex = [NSIndexPath indexPathForRow:tem inSection:indexPath.section];
            [tableView cellForRowAtIndexPath:dex].textLabel.textColor = [UIColor blackColor];
        }
    }
}

@end
