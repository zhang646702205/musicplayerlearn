//
//  LrcAnalysis.m
//  bf
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import "LrcAnalysis.h"
#import "lrc.h"
@implementation LrcAnalysis

- (LrcAnalysis *)initSongLrcFile:(NSMutableString*)lrcName
{
    if (self = [super init]) {
        _LrcLlist = [[NSMutableArray alloc]init];
        [self analysisLrc:lrcName];
    }
    return  self;
}

- (void)analysisLrc:(NSString *)file
{
    NSString *lrcfile = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArray = [lrcfile componentsSeparatedByString:@"\n"];
    for (NSString *str in lrcArray) {
        if (str.length == 0) {
            continue;
        }
        
        unichar ch = [str characterAtIndex:1];
        if ([str isEqualToString:@""]) {
            continue;
        }
        if (ch >= '0' && ch <= '9') {
            [self LrcString:str];
        }else{
            [self InfoString:str];
        }
    }
    [self sortByTime];

//    for (NSInteger i = 0; i<_LrcLlist.count; i++) {
//        NSLog(@"%f",[_LrcLlist[i] time]);
//    }
}

- (void)LrcString:(NSString *)str {
    NSArray *lrcAry = [str componentsSeparatedByString:@"]"];
    //NSLog(@"%d",lrcAry.count);
    if (lrcAry.count == 1) {
        return;
    }
    NSString *lrcinfo = lrcAry[lrcAry.count - 1];
    //NSLog(@"%@",lrcinfo);
    for (NSInteger i = 0; i<lrcAry.count-1 ; i++) {
        //NSString *str = lrcAry[i];
        float min = [[lrcAry[i] substringWithRange:NSMakeRange(1, 2)]floatValue];
        float sec = [[lrcAry[i] substringFromIndex:4]floatValue];
        float time = min * 60 + sec;
        
        lrc *lrcItem = [[lrc alloc]initWithTime:time andLrc:lrcinfo];
        [_LrcLlist addObject:lrcItem];
    }
    }

- (void)InfoString:(NSString *)str {
    NSArray *infoAry = [str componentsSeparatedByString:@":"];
    NSUInteger len = [infoAry[1] length]- 1;
    NSString *info = [infoAry[1] substringToIndex:len];
    
    if ([infoAry[0] isEqualToString:@"[ti"]) {
        _title = info;
    }else if ([infoAry[0] isEqualToString:@"[ar"]){
        _artist = info;
    }else if ([infoAry[0] isEqualToString:@"[al"]){
        _record = info;
    }else if ([infoAry[0] isEqualToString:@"[by"]){
        _author = info;
    }
}
- (NSString *)getLrcByTime:(float)Time
{
    if (_LrcLlist.count == 0) {
        return @"没有找到歌词";
    }
    NSInteger index = _LrcLlist.count - 1;
    for (NSInteger i = 0; i<_LrcLlist.count; i++) {
        if ([_LrcLlist[i] time ] > Time) {
            index = i - (i != 0);
            break;
        }
    }
    //NSLog( @"%f",[_LrcLlist[index] time ]);
    return [_LrcLlist[index] lrcInfo];
}
- (void)sortByTime{
    
    [_LrcLlist sortUsingSelector:@selector(isBiggerThanOther:)];
}
@end
