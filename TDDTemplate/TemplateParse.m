//
//  TemplateParse.m
//  TDDTemplate
//
//  Created by James Stewart on 2/24/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "TemplateParse.h"
#import "Template.h"  //FIX!!!!
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

- (NSArray *)parse {
    NSArray *segmentRanges = [self variableSegmentRanges];
    NSArray *stringSegments = [self segmentsFromSegmentRanges:segmentRanges];
    return stringSegments;
}

- (NSArray *)parseIntoSegments {
    NSMutableArray *segments = [NSMutableArray array];
    NSArray *stringSegments = [self parse];
    for (NSString* strSeg in stringSegments) {
        if ([Template isVariable:strSeg]) {            
            [segments addObject:[VariableSegment segmentWithValue:[Template cleanString:strSeg]]];
        } else {
            [segments addObject:[PlainTextSegment segmentWithValue:strSeg]];
        }
    }
    return segments;
}

- (NSArray *)variableSegmentRanges {
    return [self.regex matchesInString:self.string options:0 range:NSMakeRange(0, [self.string length])];
}

- (NSArray *)segmentsFromSegmentRanges:(NSArray *)segmentRanges {
    if ([segmentRanges count] == 0) {
        return  @[self.string];  // fix this....
    }
    
    assert([segmentRanges[0] isKindOfClass:[NSTextCheckingResult class]]);
    NSMutableArray *segmentArray = [NSMutableArray array];
    
    for (NSUInteger matchIndex = 0; matchIndex < [segmentRanges count]; ++matchIndex) {
        NSString *tempString = [self textPrecedingMatchIndex:matchIndex segmentRanges:segmentRanges];
        if ([tempString length]) {
            [segmentArray addObject:tempString];
        }
        tempString = [self variableAtMatchIndex:matchIndex segmentRanges:segmentRanges];
        if ([tempString length]) {
            [segmentArray addObject:tempString];
        }
    }
    NSTextCheckingResult *lastMatchResult = segmentRanges[ [segmentRanges count] - 1 ];
    NSString *tempString = [self textAfterLastMatch:lastMatchResult];
    if ([tempString length]) {
    [segmentArray addObject:tempString];
    }
    return segmentArray;
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

@end
