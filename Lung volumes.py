import nibabel as nib
import os

# Set the directory where the lung segmentation images are stored
img_dir = 'lung_segmentations/'

# Loop over all preop and postop images
for i in range(1, 8):
    # Load the preop and postop lung segmentation images
    preop_filename = os.path.join(img_dir, f'{i}_preop_lung_seg.nii')
    postop_filename = os.path.join(img_dir, f'{i}_postop_lung_seg.nii')
    preop_img = nib.load(preop_filename)
    postop_img = nib.load(postop_filename)

    # Get voxel dimensions
    preop_voxel_dims = preop_img.header.get('pixdim')[1:4]
    postop_voxel_dims = postop_img.header.get('pixdim')[1:4]

    # Get voxel data
    preop_voxel_data = preop_img.get_fdata()
    postop_voxel_data = postop_img.get_fdata()

    # Calculate lung volume in mm^3
    preop_lung_volume_mm3 = (preop_voxel_data > 0).sum() * preop_voxel_dims[0] * preop_voxel_dims[1] * preop_voxel_dims[2]
    postop_lung_volume_mm3 = (postop_voxel_data > 0).sum() * postop_voxel_dims[0] * postop_voxel_dims[1] * postop_voxel_dims[2]

    # Convert to liters
    preop_lung_volume_liters = preop_lung_volume_mm3 / 1000000
    postop_lung_volume_liters = postop_lung_volume_mm3 / 1000000
    ratio =  postop_lung_volume_liters/preop_lung_volume_liters

    # Print the lung volumes for this image side by side
    print(f"Lung volume preop {i}: {preop_lung_volume_liters:.2f} liters\tLung volume postop {i}: {postop_lung_volume_liters:.2f} liters  postop/preop ratio: {ratio:.2f}")
