//
//  VariableSegment.m
//  TDDTemplate
//
//  Created by James Stewart on 2/24/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "VariableSegment.h"

@interface VariableSegment ()
@property (nonatomic, copy) NSString *value;

@end


@implementation VariableSegment

+ (instancetype)segmentWithValue:(NSString *)value {
    return [[VariableSegment alloc] initWithValue:value];
}

- (instancetype)initWithValue:(NSString*)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (BOOL) isEqual:(id)object {
    if (! [object isKindOfClass:[self class]]) {
        return NO;
    }
    
    VariableSegment *varObj = (VariableSegment *)object;
    return [self.value isEqualToString:varObj.value];
}

- (NSUInteger)hash {
    return [self.value hash];
}
@end
