//
//  Session.m
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

#import "Session.h"

@implementation Session


-(instancetype)initWithItemName:(NSString *)beginTime endTime:(NSString *)endTime details:(NSString *)details location:(NSString *)location sessionName:(NSString *)sessionName
{
    _beginTime = beginTime;
    _endTime = endTime;
    _details = details;
    _sessionName = sessionName;
    _location = location;
    
    
    return self;
}


@end
