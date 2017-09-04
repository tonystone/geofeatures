/*
*   GFViewController.m
*
*   Copyright 2015 Tony Stone
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*
*   Created by Tony Stone on 04/14/2015.
*/

#import "GFViewController.h"
#import <GeoFeatures/GeoFeatures.h>

@interface GFViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation GFViewController (MKMapViewDelegate)

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"Constructing renderer for overlay with class: %@", [overlay class]);
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setFillColor:[UIColor greenColor]];
        [renderer setLineWidth:1.0f];
        [renderer setAlpha:0.5f];
        return renderer;
    } else {
        return nil;
    }
}

@end

@implementation GFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    [self addGeoJSONOverlay];
}

- (void)zoomToPolygon:(MKPolygon*)polygon {
    [self.mapView setVisibleMapRect:polygon.boundingMapRect
                        edgePadding:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f)
                           animated:YES];
}

- (void)addGeoJSONOverlay
{
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"new-mexico" ofType:@"json"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"Error while reading JSON file: %@", error);
        return;
    }
    
    NSData *jsonData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    error = nil;
    
    id dictionary = [NSJSONSerialization JSONObjectWithData: jsonData options:0 error:&error];
    if ([dictionary isKindOfClass:[NSDictionary class]] && error == nil) {
        GFGeometry *geometry = [GFGeometry geometryWithGeoJSONGeometry:(NSDictionary*)dictionary];
        
        [self.mapView addOverlays:[geometry mkMapOverlays]];
        [self zoomToPolygon:(MKPolygon*)[geometry mkMapOverlays][0]];
        
    } else {
        NSLog(@"Error while parsing GeoJSON: %@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
