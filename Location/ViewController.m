//
//  ViewController.m
//  Location
//
//  Created by MAEDA HAJIME on 2015/06/14.
//  Copyright (c) 2014年 MAEDA HAJIME. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate> {
    
    // LocationManagerオブジェクト
    CLLocationManager *_mgr;
}

// コンパス ivCompass
@property (weak, nonatomic) IBOutlet UIImageView *ivCompass;

//
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbLatLong;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 準備処理
    [self doReady];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 準備処理
- (void)doReady {
    
    // LocationManagerオブジェクト
    _mgr = [[CLLocationManager alloc] init];
    
    // 設定（デリゲート）
    _mgr.delegate = self;
    
    ///////////////////////////////////
    // iOS8未満は、このメソッドは無いので
    if ([_mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        // GPSを取得する旨の認証をリクエストする
        // 「このアプリ使っていない時も取得するけどいいでしょ？」
        [_mgr requestAlwaysAuthorization];
    }
    ///////////////////////////////////

    // 設定（精度：最高精度（iOS4-））望まれている精度
    _mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // iOS4以降がベスト
    // 設定（移動の閾値(m)：指定なし）
    _mgr.desiredAccuracy = kCLDistanceFilterNone;
    
    // 情報更新の開始（位置）
    [_mgr startUpdatingLocation];
    
    // 情報更新の開始（方角）
    [_mgr startUpdatingHeading];

}

#pragma mark - CLLocationManagerDelegate Method

// 位置情報の更新時（iOS6-）
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    // 位置情報の取得
    CLLocation *loc = [locations lastObject];
    CLLocationDegrees lat = loc.coordinate.latitude;  // 緯度
    CLLocationDegrees lng = loc.coordinate.longitude; // 経度
    
    // lbLatLong
    NSLog(@"緯度：%f 経度：%f" ,lat,lng);
    
    ((UILabel *) self.lbLatLong[0]).text =
        [NSString stringWithFormat:@"緯度：%.2f", lat];
    ((UILabel *) self.lbLatLong[1]).text =        [NSString stringWithFormat:@"経度：%.2f", lng];
}

// 位置情報の更新時（iOS5-）
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    // 位置情報の取得
    CLLocationDegrees lat = newLocation.coordinate.latitude;
    CLLocationDegrees lng = newLocation.coordinate.longitude;
    
    ((UILabel *) self.lbLatLong[0]).text =
        [NSString stringWithFormat:@"緯度：%.2f", lat];
    ((UILabel *) self.lbLatLong[1]).text =
        [NSString stringWithFormat:@"経度：%.2f", lng];
}

// 方角情報の更新時
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    
    // コンパス画像の回転
    CGFloat ang = -newHeading.magneticHeading * M_PI / 100;
    self.ivCompass.transform = CGAffineTransformMakeRotation(ang);
    
}

@end
