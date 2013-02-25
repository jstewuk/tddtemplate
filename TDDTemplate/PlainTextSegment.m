//
//  PlainTextSegment.m
//  TDDTemplate
//
//  Created by James Stewart on 2/24/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "PlainTextSegment.h"

@interface PlainTextSegment ()
@property (nonatomic, copy) NSString *value;

@end

@implementation PlainTextSegment

+ (instancetype)segmentWithValue:(NSString *)value {
    return [[PlainTextSegment alloc] initWithValue:value];
}

- (instancetype)initWithValue:(NSString*)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (NSString *)evaluateWithVariables:(NSDictionary *)variables error:(NSError **)error {
    return self.value;
}

- (BOOL) isEqual:(id)object {
    if (! [object isKindOfClass:[self class]]) {
        return NO;
    }
    
    PlainTextSegment *varObj = (PlainTextSegment *)object;
    BOOL result = [self.value isEqualToString:varObj.value];
    return result;
}

- (NSUInteger)hash {
    return [self.value hash];
}
@end
