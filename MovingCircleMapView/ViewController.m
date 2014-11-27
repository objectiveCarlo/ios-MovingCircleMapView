//
//  ViewController.m
//  MovingCircleMapView
//
//  Created by Carlo Bation on 11/26/14.
//  Copyright (c) 2014 CL. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CircleCenterAnnotation.h"
#import "CircleHandleAnnotation.h"
#import "CircularAnnotationManager.h"
#import "CircleMapOverlay.h"
@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) CircularAnnotationManager *annotationCollection;

@end

@implementation ViewController	
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotationCollection = [CircularAnnotationManager makeAnnotationsWithCoordinate:CLLocationCoordinate2DMake(14.576367, 121.085118) withRadius:10000];
    
    [self.mapView addOverlay:self.annotationCollection.circleOverlay];
    [self.mapView addAnnotations:[self.annotationCollection getAnnotations]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MKMapViewDelegate methods
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    NSString *possiblePinClass = NSStringFromClass([annotation class]);
    
    MKAnnotationView *pin = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: possiblePinClass];
    if (pin == nil) {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: possiblePinClass];
    } else {
        pin.annotation = annotation;
    }
    
    if ([possiblePinClass isEqualToString:@"CircleHandleAnnotation"]) {
        pin.image = [UIImage imageNamed:@"btn_circular_enlarger"];
    } else {
        pin.image = [UIImage imageNamed:@"ico_default_map_annotation"];;
    }
    
    pin.draggable = YES;
    
    return pin;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    
    renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    
    return renderer;
    
}
- (NSInteger)getNewRadius:(CLLocationCoordinate2D)newCoordinates withCenter:(CLLocationCoordinate2D)center {
    
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinates.latitude longitude:newCoordinates.longitude];
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    
    CLLocationDistance distance = [newLocation distanceFromLocation:centerLocation];
    
    return distance;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    [CircularAnnotationManager mapView:mapView annotationView:annotationView didChangeDragState:newState fromOldState:oldState];
}
@end
