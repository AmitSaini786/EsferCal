# EsferCal  
EsferCal is a sleek, easily to use and customize,simply drag and drop files to your project and use.  
![simulator screen shot apr 27 2017 12 15 53 pm](https://cloud.githubusercontent.com/assets/4947148/25478612/7df620f2-2b5f-11e7-8d9a-c7761204e350.png)
# How to integrate EsferCal.  
Drag and drop EsmitView.h EsmitView.m, EsmitHeaderView.h and EsmitHeaderView.m file into your project.  
#import "EsmitView.h" in your view controller.  
# Interacting with EsferCal.  

-(void)yourMethod {  
  EsmitView *cal = [[EsmitView alloc]initWithFrame:CGRectMake(0,60, 200, 200)];  
    [self.view addSubview:cal];  
    cal.delegate=self;  
}  
When a user attempts to select a date (via a tap), the calendar will call its delegate didSelectDate: method (if your delegate implements it), passing in the date the user selected.   

-(void)didSelectDate:(NSString *)stringDate{  
    NSLog(@"Your Selected date is= %@",stringDate);  
} 

# Customizing
The calendar was written to be easily styled so that you can make it feel seamless in your app. You can customize the fonts, text colors, and background colors of nearly every element.

