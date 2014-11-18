//
//  MyViewController.m
//  eating
//
//  Created by iMac2011 on 14/11/12.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "MeViewController.h"
#import "UIView+Extension.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    
}

- (void)loading:(id)sender {
    
    
}

#pragma mark -
#pragma mark section row 的高度



#pragma mark -
#pragma mark tableView 协议

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 250;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[[NSBundle mainBundle] loadNibNamed:@"testHeader" owner:nil options:nil] firstObject];
    return headerView;
    }



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        switch (indexPath.section) {
            case 0:
                
                if (indexPath.row == 0)
                    
                {
                    cell.textLabel.text = @"我的美食";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"2" ofType:@".png"];
                    UIImage * image = [UIImage imageWithContentsOfFile:bundle];
                    
                    cell.imageView.image = image;
                    
                } else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"我的收藏";
                    NSString *bundle5 = [[NSBundle mainBundle] pathForResource:@"12" ofType:@".png"];
                    UIImage * image = [UIImage imageWithContentsOfFile:bundle5];
                    
                    cell.imageView.image = image;
                }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
    
}




@end
