//
//  TestViewController.m
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#import "TestViewController.h"
#import "MMLocationManager.h"
#import "AFJSONRequestOperation.h"

@interface TestViewController ()

@property(nonatomic,strong)UILabel *textLabel;

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 30 : 10, 320, 60)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"测试位置";
    [self.view addSubview:_textLabel];
    
    UIButton *latBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    latBtn.frame = CGRectMake(100,IS_IOS7 ? 100 : 80, 120, 30);
    [latBtn setTitle:@"获取坐标" forState:UIControlStateNormal];
    [latBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latBtn addTarget:self action:@selector(getLat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latBtn];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cityBtn.frame = CGRectMake(100,IS_IOS7 ? 150 : 130, 120, 30);
    [cityBtn setTitle:@"获取城市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addressBtn.frame = CGRectMake(100,IS_IOS7 ? 200 : 180, 120, 30);
    [addressBtn setTitle:@"获取地址" forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(getAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressBtn];
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.frame = CGRectMake(100,IS_IOS7 ? 250 : 230, 120, 30);
    [allBtn setTitle:@"获取所有信息" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    UIButton *weatherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    weatherBtn.frame = CGRectMake(100,IS_IOS7 ? 300 : 280, 120, 30);
    [weatherBtn setTitle:@"获取当前城市天气" forState:UIControlStateNormal];
    [weatherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weatherBtn addTarget:self action:@selector(getWeather) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weatherBtn];
}

- (void)getLat
{
    __block __weak TestViewController *wself = self;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
    }];
}

- (void)getCity
{
    __block __weak TestViewController *wself = self;
    [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
        [wself setLabelText:cityString];
    }];
}

- (void)getAddress
{
    __block __weak TestViewController *wself = self;
    [[MMLocationManager shareLocation] getAddress:^(NSString *addressString) {
        [wself setLabelText:addressString];
    }];
}

- (void)getAllInfo
{
    __block NSString *string;
    __block __weak TestViewController *wself = self;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
    } withAddress:^(NSString *addressString) {
        string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
        [wself setLabelText:string];
    }];
}

- (void)getWeather
{
    __block __weak TestViewController *wself = self;
    [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
        [wself getWeatherWithCity:cityString];
    }];
}

//获取天气APIhttp://openweathermap.org/
- (void)getWeatherWithCity:(NSString *)city
{
    __block __weak TestViewController *wself = self;
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@",city];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [wself setWeatherText:JSON withCity:city];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}

- (void)setWeatherText:(id)JSON withCity:(NSString *)city
{
    NSDictionary *dic = JSON;
    NSArray *weather = [dic objectForKey:@"weather"];
    NSString *weatherMain = [[weather firstObject] objectForKey:@"main"];
    float temp = [[[dic objectForKey:@"main"] objectForKey:@"temp"] floatValue] / 10.0;
    NSString *tempString = [NSString stringWithFormat:@"%.1f",temp];
    [self setLabelText:[NSString stringWithFormat:@"%@ %@ %@℃",city,weatherMain,tempString]];
}

-(void)setLabelText:(NSString *)text
{
    _textLabel.text = text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
