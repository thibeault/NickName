//
//  TedNSIntegerUtil.m
//  HelloWorld
//
//  Created by Eric Thibeault on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TedNSIntegerUtil.h"

@implementation NSNumber(TedNSIntegerUtil)

-(NSNumber*) random {
    return arc4random() % 100;;
}

@end