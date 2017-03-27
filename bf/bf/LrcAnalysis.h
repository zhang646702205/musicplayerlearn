//
//  LrcAnalysis.h
//  bf
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcAnalysis : NSObject
// 歌名
@property (nonatomic,copy) NSString *title;
// 艺术家
@property (nonatomic,copy) NSString *artist;
// 作者
@property (nonatomic,copy) NSString *author;
// 唱片
@property (nonatomic,copy) NSString *record;
// 存储歌词信息数组
@property (nonatomic,copy) NSMutableArray *LrcLlist;
- (LrcAnalysis *)initSongLrcFile:(NSString *)lrcName;
- (NSString *)getLrcByTime:(float)Time;

@end
