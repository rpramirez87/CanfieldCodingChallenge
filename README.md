# Canfield Coding Challenge.     

#### Constraints.    
Confirm that the image captured is indeed a face.    
The subject id is alphanumeric.    
The subject id written into the image needs to be in a white font on a black rectangular background.     
The core image filter to be applied is a CIUnsharpMask with an input radius of 11 and an input intensity of 0.5.     
The workflow of the app is: Enter subject id – capture image – review image – process image – display result image.     
Display result image view needs to have a save button which will cause the displayed image to be saved to the camera roll.     
 
#### Extra Credit.      
Display a custom spinner that you have written in the center of the screen while the image is being processed. It is understood that the processing time will be minimal. Feel free to add a 1-2 second delay.

# Solution

#### iOS SDK
Vision - Use to detect faces within images.       
CoreImage - Use to apply required filter within images.




