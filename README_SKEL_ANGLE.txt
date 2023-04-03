Skeletonization code:
  -Used to make a skeletonization of the segmentated scans
  -Importing skeletonized images
  -Skeletonizes it to get midline of the structures
  -Exports those midlines in a skeleton-file

Angle code:
  -Used to calculate angle between reference landmark on the vertebra and landmarks on the rib
  -In the top of the code the landmark (1, 3, 6 or 8) on the rib can be entered
  -And the reference landmark (4, 5 or 7) on the vertebra
  -In folder line the folder can be changed from Postop, preop to control
  -The angle for all ribs of all files in this folder will be calculated and average and standard deviation as well
  -The important angles can be:
      -From landmark 6 or 8 to 4 to see the angle between how the rib leaves the spine compared to the direction from the            spine. For this the direction of the spine is taking into account by using landmark 4 of the rib above and below.
      -This can also be done with landmark 1 or 3 instead of 6 or 8
      -Also landmark 4 can be easily changed with 5 or 7 in the top of the script
  -This will be done for 3D and 2D where in 2D the Z-positions (anterior-posterior) won't be takin into account
