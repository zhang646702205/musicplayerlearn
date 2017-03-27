//
//  lrc.h
//  bf
//
//  Created by qianfeng on 15-2-27.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lrc : NSObject

@property (nonatomic,assign) CGFloat time;
@property (nonatomic,copy) NSString *lrcInfo;

- (lrc *)initWithTime:(float)time andLrc:(NSString *)lrcinfo;
- (BOOL)isBiggerThanOther:(lrc *)lrcItem;
@end
