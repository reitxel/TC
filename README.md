# README

Pipeline for the processing of scoliotic and non-scoliotic images to assess rib cage deformations. Manual steps are explaine in a separated .pdf called 'Manual.pdf':
1. Visual inspection of images (see Manual.pdf)
2. Pre-processing of the images: performed with 'Preprocessing_images.ipynb'. This code pre-preocesses control and scoliotic NIFTI images.  All steps are performed automatically. The only required inputs are the paths to the images and, in case cropping is necessary, the image number and the bounds to follow.The pre-processing developed consists in 4 main steps:
  - Cropping (if neccessary): cropping is done to keep only the Region Of Interest (ROI). In this case, the ribcage. 
  Other structures like the head or the sacrum are not relevant for this study.
  - Pixel spacing adjustment for control images: the control images provided did not have a correct pixel spacing for 
  visualization. Their pixel spacing was 1 by default. This isue fixed in this step.
  - Denoising of scoliotic images: scoliotic images are filtered to avoid artifacts due to noise when performing the
  segmentations.
  - Registration (see parameters_affine2.txt for details): 
    - control images are registered to the first control image.
    - pre-operative scoliotic images are registered to the first pre-operative scolitoic images.
    - post-operative images are registered to their corresponding registered pre-operative image.
    
 3. Image segmentation (see Manual.pdf)
 4. Skeletonization, performed with 'skeletonization_code.ipynb':
   - Used to make a skeletonization of the segmentated scans
   - Importing skeletonized images
   - Skeletonizes it to get midline of the structures
   - Exports those midlines in a skeleton-file
 
 5. Landmark placement (see Manual.pdf)
 6. Metrics, the followings metrics were calculated:
  - Lung volumes calculation:The code loads the lung segmentations that we have obtained from the previous data analysis and calculates the total volume of the voxels    of the image. To visualize a quantifiable result, the postop/preop lung volume is displayed for each patient.

  - Ribcage volume calculation: To calculate the ribcage volume, we use the manually placed landmarks on the skeletonized segmentations of the ribcage. The landmarks     folder with a specific format to easily read all the points can be found here: https://github.com/reitxel/TC/tree/main/Landmarks_JSON.
  We placed landmarks on the 1st, 3rd, 4th and 7th rib. However, for some patients, the 7th rib was not completely visible after the segmentation and this is why         distinguish the volume calculation in patients with 3 ribs and patients with 4 ribs. The fact that we do not take into account the whole ribcage, results in volumes    smaller than anticipated. The postop/preop ratio is also displayed along with the absolute values so as to disregard the systematic error of the calculations. 

  - Angles, performed with 'Angles_calculation.py':
    - Used to calculate angle between reference landmark on the vertebra and landmarks on the rib
    - In the top of the code the landmark (1, 3, 6 or 8) on the rib can be entered
    - And the reference landmark (4, 5 or 7) on the vertebra
    - In folder line the folder can be changed from Postop, preop to control
    - The angle for all ribs of all files in this folder will be calculated and average and standard deviation as well
    - The important angles can be:
        - From landmark 6 or 8 to 4 to see the angle between how the rib leaves the spine compared to the direction from the spine. For this the direction of the spine          is taking into account by using landmark 4 of the rib above and below.
        - This can also be done with landmark 1 or 3 instead of 6 or 8
        - Also landmark 4 can be easily changed with 5 or 7 in the top of the script
    - This will be done for 3D and 2D where in 2D the Z-positions (anterior-posterior) won't be takin into account
    
  - Rib path interpolation and 3D visualization, enclosed areas between ribs, distances between landmarks and symmetry assessment between ribs. All the mentioned was     performed in 'main_spline.m'. This file depends on four Matlab functions:
    - 'spline_area_func.m': This function computes the area enclosed inside a set of interpolated points. In this case, it can be used for the whole enclosed area or         also the convex and concave areas of the desired rib.
    - 'spline_area_func_flip.m': This function flips the area of the convex side to the region of the concave. In this case, it can be used for the whole  enclosed           area or also the convex and concave areas of the desired rib.
    - 'spline_rib_func_flip.m': This function flips the convex rib to the region of the concave. It is flipped on the x-axis.
    - 'spline_rib_func_flip_dist.m': This function flips the convex rib to the region of the concave. It is flipped on the x-axis. Then computes the distances between landmarks 2,1,6,4 and landmarks 2,3,8,4 and creates a table. Then the distance between landmarks 1 and 3, and 6 and 8 specifically are displayed. Next, the distance between all the points in the interpolation was calculated and the mean value of this distance is displayed. Lastly and approximation of the area for the distances between the interpolated points of the ribs is also displayed
    
  

  




