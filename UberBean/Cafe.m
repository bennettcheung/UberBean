//
//  Cafe.m
//  UberBean
//
//  Created by Bennett on 2018-08-17.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import "Cafe.h"

@interface Cafe()
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy, nullable) NSString* title;
@property (nonatomic, readwrite, copy, nullable) NSString* subtitle;
@end

@implementation Cafe

- (instancetype)initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coordinate rating:(NSString*)rating imageURL:(NSString*)imageURL
{
    self = [super init];
    if (self) {
        _title = title;
        _rating = rating;
        _subtitle = [self ratingToSubtitle:_rating];
        _coordinate = coordinate;
        
        _imageURL = imageURL;
    }
    return self;
}

-(NSString*)ratingToSubtitle:(NSString*)ratings{
    NSString* concatRating = [ratings substringToIndex:1];
    int rating = [concatRating intValue];
    
    concatRating = @"";
    for (int i=0; i< rating; i++)
    {
        concatRating = [NSString stringWithFormat:@"%@😀", concatRating];
    }
    
    return concatRating;
}

@end
