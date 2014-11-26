//
//  Annotation.h
//  MovingCircleMapView
//
//  Created by Carlo Bation on 11/26/14.
//  Copyright (c) 2014 CL. All rights reserved.
//

#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation> {
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
