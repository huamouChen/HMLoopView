//
//  HMWeakTimer.h
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMWeakTimer : NSObject
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
@end
