//
//  StoryPartViewController.m
//  AV Storybook
//
//  Created by Errol Cheong on 2017-07-14.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "StoryPartViewController.h"
#import "DataStore.h"

@interface StoryPartViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) DataStore *data;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation StoryPartViewController

- (void)setPageIndex:(NSUInteger)pageIndex
{
    _pageIndex = pageIndex;
    self.data = [[DataStore alloc] initWithFilename:[NSString stringWithFormat:@"%@%lu%@", @"audioData", pageIndex, @".m4a"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"Page #%lu", self.pageIndex + 1];
//    NSLog(@"%@",self.data.audioFileURL);
//    printf("%s", [self.data.audioFileURL description].UTF8String);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedPlay:)];
    [self.imageView addGestureRecognizer:tapGesture];
    self.imageView.userInteractionEnabled = YES;
}

# pragma mark - UIButton Methods

- (IBAction)photoButton:(UIButton *)sender
{
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //    {
    //        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    } else {
    pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    
    pickerView.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerView.sourceType];
    
    pickerView.delegate = self;
    
    [self presentViewController:pickerView animated:YES completion:nil];
}
- (IBAction)recordButton:(UIButton *)sender
{
    if (self.data.avRecorder.isRecording)
    {
        [self.data.avRecorder stop];
        self.imageView.userInteractionEnabled = YES;
        [sender setTitle:@"Record" forState:UIControlStateNormal];
    } else {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted)
            {
                [sender setTitle:@"Stop" forState:UIControlStateNormal];
                
                NSError *err = nil;
                self.data.avRecorder = [[AVAudioRecorder alloc] initWithURL:self.data.audioFileURL settings:@{AVFormatIDKey:@(kAudioFormatMPEG4AAC),                         AVSampleRateKey:@(44100),AVNumberOfChannelsKey:@(2)}
                                                                      error:&err];
                
                if (err != nil) {
                    NSLog(@"Couldn't create recorder: %@",
                          err.localizedDescription);
                    abort();
                }
                self.imageView.userInteractionEnabled = NO;
                [self.data.avRecorder record];
            } else {
                NSLog(@"No permission to recorder");
            }
        }];
    }
    
}

#pragma mark - Gesture Recognizer Methods

-(void)imageTappedPlay:(UITapGestureRecognizer*)sender
{
    if (self.data.avPlayer.isPlaying)
    {
        [self.recordButton setEnabled:YES];
        [self.data.avPlayer stop];
    } else {
        self.data.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.data.audioFileURL error:nil];
        self.data.avPlayer.delegate = self;
        //        self.data.avPlayer.currentTime = 0;
        [self.data.avPlayer play];
        if (self.data.avPlayer.isPlaying)
        {
            [self.recordButton setEnabled:NO];
        }
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", info);
    UIImage *pickedImage = info[@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AVAudioPlayer Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.recordButton setEnabled:YES];
}

@end
