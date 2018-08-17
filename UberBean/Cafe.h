//
//  Cafe.h
//  UberBean
//
//  Created by Bennett on 2018-08-17.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Cafe : NSObject

@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSString* rating;

@end
