//
//  lrc.m
//  bf
//
//  Created by qianfeng on 15-2-27.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import "lrc.h"

@implementation lrc

- (lrc *)initWithTime:(float)time andLrc:(NSString *)lrcinfo
{
    if ( self = [super init]) {
        _time = time;
        _lrcInfo = lrcinfo;
    }
    return  self;
}
- (BOOL)isBiggerThanOther:(lrc *)lrcItem{
    return  self.time > lrcItem.time;
}
@end
