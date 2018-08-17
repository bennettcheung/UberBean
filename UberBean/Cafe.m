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
@end

@implementation Cafe

- (instancetype)initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coordinate rating:(NSString*)rating imageURL:(NSString*)imageURL
{
    self = [super init];
    if (self) {
        _title = title;
        _coordinate = coordinate;
        _rating = rating;
        _imageURL = imageURL;
    }
    return self;
}

@end
