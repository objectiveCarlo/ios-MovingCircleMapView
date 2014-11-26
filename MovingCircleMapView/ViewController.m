//
//  ViewController.m
//  MovingCircleMapView
//
//  Created by Carlo Bation on 11/26/14.
//  Copyright (c) 2014 CL. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "CircleHandleAnnotation.h"
@interface ViewController ()<MKMapViewDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D previousCenter;
@property (assign, nonatomic) CLLocationDistance previousRadius;
@end

@implementation ViewController	
- (void)viewDidLoad {
    [super viewDidLoad];
    _previousRadius = 10000;
    _previousCenter = CLLocationCoordinate2DMake(14.576367, 121.085118);
    [self createHandlersWithCenter:_previousCenter withRadius:_previousRadius];
}
- (void)createHandlersWithCenter:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self addNewCircleWithCenter:coordinate withRadius:radius inMap:self.mapView flushOldOverlays:YES];
    
    Annotation *myPin = [[Annotation alloc] initWithCoordinate:coordinate];
    [self.mapView addAnnotation:myPin];
    
    
    CircleHandleAnnotation *ciclePin = [[CircleHandleAnnotation alloc] initWithCoordinate:coordinate withRadius:radius];
    [self.mapView addAnnotation:ciclePin];
}

- (void)addNewCircleWithCenter:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius inMap:(MKMapView *)mapView flushOldOverlays:(BOOL)flushOldOverlays{
    
    NSArray *overlays = mapView.overlays;
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapView addOverlay:circle];
    
    if (flushOldOverlays) {
        [self.mapView removeOverlays:overlays];
    }
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
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: possiblePinClass]; // If you use ARC, take out 'autorelease'
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
    if (newState == MKAnnotationViewDragStateEnding) {
        
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
       
        if ([annotationView.annotation isKindOfClass:[CircleHandleAnnotation class]]) {
            
            CLLocationDistance newRadius = [self getNewRadius:droppedAt withCenter:_previousCenter];
            
            _previousRadius = newRadius;
            
            [self addNewCircleWithCenter:_previousCenter withRadius:_previousRadius inMap:self.mapView flushOldOverlays:YES];
            
            
            
        } else {
            
            _previousCenter = droppedAt;
            
            [self createHandlersWithCenter:_previousCenter withRadius:_previousRadius];
        }
        
        [annotationView setDragState:MKAnnotationViewDragStateNone];
        
    }
}
@end
