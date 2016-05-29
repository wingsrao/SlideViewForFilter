//
//  FilterSlideViewController.h
//  Vasse
//
//  Created by 饶首建 on 16/5/19.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import "CustomSlideBar.h"

@interface FilterSlideDataViewController : CustomSlideBar

@property (nonatomic, strong)void (^backBlock)(id backData);

@end
