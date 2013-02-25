//
//  TemplateParse.m
//  TDDTemplate
//
//  Created by James Stewart on 2/24/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "TemplateParse.h"
#import "VariableSegment.h"
#import "PlainTextSegment.h"

@interface TemplateParse ()
@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation TemplateParse
- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = [string copy];
        _regex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{.+?\\}"
                                                           options:0
                                                             error:nil];
    }
    return self;
}

- (NSArray *)parseIntoSegments {
    NSArray *segmentRanges = [self variableSegmentRanges];
    NSArray *segments = [self segmentsFromSegmentRanges:segmentRanges];
    return segments;
}

- (NSArray *)variableSegmentRanges {
    return [self.regex matchesInString:self.string options:0 range:NSMakeRange(0, [self.string length])];
}

- (NSArray *)segmentsFromSegmentRanges:(NSArray *)segmentRanges {
    if ([segmentRanges count] == 0) {
        return  @[[PlainTextSegment segmentWithValue:@""]]; 
    }
    
    assert([segmentRanges[0] isKindOfClass:[NSTextCheckingResult class]]);
    NSMutableArray *segmentArray = [NSMutableArray array];
    
    [self addMatchesAndPrecedingText:segmentArray segmentRanges:segmentRanges];
    NSTextCheckingResult *lastMatchResult = segmentRanges[ [segmentRanges count] - 1 ];
    NSString *tempString = [self textAfterLastMatch:lastMatchResult];
    if ([tempString length]) {
        [segmentArray addObject:[PlainTextSegment segmentWithValue:tempString]];
    }
    return segmentArray;
}

- (void)addMatchesAndPrecedingText:(NSMutableArray *)segmentArray segmentRanges:(NSArray *)segmentRanges {
    for (NSUInteger matchIndex = 0; matchIndex < [segmentRanges count]; ++matchIndex) {
        NSString *tempString = [self textPrecedingMatchIndex:matchIndex segmentRanges:segmentRanges];
        if ([tempString length]) {
            [segmentArray addObject:[PlainTextSegment segmentWithValue:tempString]];
        }
        tempString = [self variableAtMatchIndex:matchIndex segmentRanges:segmentRanges];
        if ([tempString length]) {
            [segmentArray addObject:[VariableSegment segmentWithValue:[self cleanString:tempString]]];
        }
    }
}

- (NSString*)textPrecedingMatchIndex:(NSUInteger)matchIndex segmentRanges:(NSArray*)segmentRanges {
    NSRange range;
    NSTextCheckingResult *matchingResult = segmentRanges[matchIndex];
    if (matchIndex == 0) {
        range = NSMakeRange(0, matchingResult.range.location);
    } else {
        NSTextCheckingResult *prevMatchResult = segmentRanges[matchIndex - 1];
        NSUInteger location = prevMatchResult.range.location + prevMatchResult.range.length;
        NSUInteger length = matchingResult.range.location - location;
        range = NSMakeRange(location, length);
    }
    return [self.string substringWithRange:range];
}

- (NSString *)variableAtMatchIndex:(NSUInteger)matchIndex segmentRanges:(NSArray*)segmentRanges {
    NSRange range = ((NSTextCheckingResult*)segmentRanges[matchIndex]).range;
    return [self.string substringWithRange:range];
}

- (NSString *)textAfterLastMatch:(NSTextCheckingResult*)textCheckingResult {
    NSRange lastVariableRange = textCheckingResult.range;
    NSRange range;
    NSUInteger lengthOfStringToEndOfMatch = lastVariableRange.location + lastVariableRange.length;
    if ([self.string length] <= lengthOfStringToEndOfMatch) {
        range = NSMakeRange(0, 0);
    } else {
        NSUInteger length = [self.string length] - lengthOfStringToEndOfMatch;
        range = NSMakeRange(lengthOfStringToEndOfMatch, length);
    }
    return [self.string substringWithRange:range];
}

- (BOOL)isVariable:(NSString *)segment {
    return ([segment length] > 0 &&
            [[segment substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"$"] &&
            [[segment substringWithRange:NSMakeRange([segment length] - 1, 1)] isEqualToString:@"}"]);
}

- (NSString *)cleanString:(NSString*)string {
    NSUInteger loc = 2;
    NSUInteger length = [string length] - loc - 1;
    return [string substringWithRange:NSMakeRange(loc, length)];
}

@end
