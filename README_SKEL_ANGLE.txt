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
  -All angels for all ribs of all files in this folder will be calculated and average and standard deviation as well
  -This will be done for 3D and 2D where in 2D the Z-positions (anterior-posterior) won't be takin into account
