//
//  HomeViewController.m
//  TestApplication
//
//  Created by SYNC Technologies on 21/03/15.
//  Copyright (c) 2015 SYNC Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrCallDetail;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    db = [[dataHandler alloc] init];
    [super viewDidLoad];
    
    [self setUpView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - custome methods

// setting up basic view

- (void) setUpView{
    self.navigationController.navigationBarHidden = YES;
    
    self.arrCallDetail = [NSMutableArray array];
    NSArray *arrCall = [db selectDataFromtblCallDetail];
    
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"callTime"  ascending:NO];
//   NSArray *stories=[self.arrCallDetail sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
//    NSArray *recent = [stories copy];
    
    for (NSMutableDictionary *dict in arrCall) {
        NSString *strTime = [dict valueForKey:@"callTime"];
        NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
        [dtFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
        NSDate *dtTemp = [dtFormat dateFromString:strTime];
        
        [dict setObject:dtTemp forKey:@"date"];
        
        [self.arrCallDetail addObject:dict];
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
    [self.arrCallDetail sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
}

#pragma mark - UITableView datasource and delegate methods

#define kTagBtnCall             1
#define kTaglblNumber           2
#define kTaglblTime             3
#define kTagimgSim              4
#define kTaglblBtnDetail        5

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrCallDetail count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIButton *btnCall = (UIButton *)[cell viewWithTag:kTagBtnCall];
    UILabel *lblNumber = (UILabel *)[cell viewWithTag:kTaglblNumber];
    UILabel *lblTime = (UILabel *)[cell viewWithTag:kTaglblTime];
    UIImageView *imgSim = (UIImageView *)[cell viewWithTag:kTagimgSim];
    UIButton *btnDetail = (UIButton *)[cell viewWithTag:kTaglblBtnDetail];
    
    
    NSDictionary *dictDetail = [self.arrCallDetail objectAtIndex:indexPath.row];
    
    if ([[dictDetail valueForKey:@"callType"] isEqualToString:@"Dialled"]) {
        [btnCall setBackgroundImage:[UIImage imageNamed:@"dialed_calls"] forState:UIControlStateNormal];
    }else if ([[dictDetail valueForKey:@"callType"] isEqualToString:@"Missed"]){
        [btnCall setBackgroundImage:[UIImage imageNamed:@"missed_calls"] forState:UIControlStateNormal];
    }else if ([[dictDetail valueForKey:@"callType"] isEqualToString:@"Received"]){
        [btnCall setBackgroundImage:[UIImage imageNamed:@"received_calls"] forState:UIControlStateNormal];
    }
    
    if ([[dictDetail valueForKey:@"simNum"] isEqualToString:@"1"]) {
        [imgSim setImage:[UIImage imageNamed:@"sim1"]];
    }else if ([[dictDetail valueForKey:@"simNum"] isEqualToString:@"2"]){
        [imgSim setImage:[UIImage imageNamed:@"sim2"]];
    }
    

    
    NSDate *currentDt = [NSDate date];
    
    NSTimeInterval interval = [currentDt timeIntervalSinceDate:[dictDetail valueForKey:@"date"]];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    NSString *timeDiff = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
    //NSLog(@"diff:%@",timeDiff);
    
    lblNumber.text = [dictDetail valueForKey:@"contactNum"];
    lblTime.text = [NSString stringWithFormat:@"%d hours ago", hours];
    
    btnCall.tag = indexPath.row;
    [btnCall addTarget:self action:@selector(btnCallClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail addTarget:self action:@selector(goToDetailPage) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) goToDetailPage{
    DetailViewController *objDetail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:objDetail animated:YES];
}

- (void) btnCallClicked:(UIButton *) btn{
    
    NSString *strCall = [NSString stringWithFormat:@"tel:%@",[[self.arrCallDetail objectAtIndex:btn.tag] valueForKey:@"contactNum"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strCall]];
    
    
}
@end
