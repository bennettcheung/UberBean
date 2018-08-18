//
//  Cafe.h
//  UberBean
//
//  Created by Bennett on 2018-08-17.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Cafe : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, readonly, copy, nullable) NSString* title;
@property (nonatomic, readonly, copy, nullable) NSString* subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* rating;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithTitle:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate rating:(NSString*)rating imageURL:(NSString*)imageURL;
@end
