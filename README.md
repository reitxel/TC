# TC

Lung volumes calculation:
The code loads the lung segmentations that we have obtained from the previous data analysis and calculates the total volume of the voxels of the image.
To visualize a quantifiable result, the postop/preop lung volume is displayed for each patient.

Ribcage volume calculation: To calculate the ribcage volume, we use the manually placed landmarks on the skeletonized segmentations of the ribcage. The landmarks folder with a specific format to easily read all the points can be found here: https://github.com/reitxel/TC/tree/main/Landmarks_JSON.
We placed landmarks on the 1st, 3rd, 4th and 7th rib. However, for some patients, the 7th rib was not completely visible after the segmentation and this is why distinguish the volume calculation in patients with 3 ribs and patients with 4 ribs. The fact that we do not take into account the whole ribcage, results in volumes smaller than anticipated. The postop/preop ratio is also displayed along with the absolute values so as to disregard the systematic error of the calculations. 

