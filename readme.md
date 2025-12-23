# Automated Tissue Layer Detection in Medical Imaging

## GUI Usage
- Load image button: Click to open a file browser and then select a dicom image (Only accepts Dicom images, no other formats.)
- Save image button: Click to save the current processed image in the app as a png.
- Min Angle Field input: The minimum angle a split between tissue can be curved for our detection to recognize it. (Min 85, max 95)
- Max Angle Field input:  The maximum angle a split between tissue can be curved for out detection to recognize it. (Min 85, max 95)

- Image axes: allows basic operations on your processed image. Buttons are located in the top right. (Zooming, panning, showing coords)

## Compiling and running
The app is compiled using the Matlab compiler for standalone desktop release. \
The release in this repo was compiled using a Windows 11 machine on MATLAB R2025a.