//
//  CircleHandleAnnotation.m
//  MovingCircleMapView
//
//  Created by Carlo Bation on 11/26/14.
//  Copyright (c) 2014 CL. All rights reserved.
//

#import "CircleHandleAnnotation.h"

@implementation CircleHandleAnnotation
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate withRadius:(CLLocationDistance)radius {
    
    self = [super init];
    
    if (self) {
        
        CLLocationDegrees longitude = newCoordinate.longitude;
        CLLocationDegrees latitude = newCoordinate.latitude;
        
        double EARTHRADIUS = 6378137;
        
        double dLon = radius/(EARTHRADIUS*cos(M_PI*latitude/180));
        
        
        CLLocationDegrees newLongitude = longitude + dLon * 180/M_PI;
        
        coordinate = CLLocationCoordinate2DMake(newCoordinate.latitude, newLongitude);
        
    }
    
    return self;
}
- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return nil;
}


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    coordinate = newCoordinate;
}
@end
