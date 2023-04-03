import json
import numpy as np
import os
from scipy.spatial import ConvexHull

def calculate_volume_from_json(folder_path, pattern):
    positions = []
    nums = [1, 3, 5]
    rib7_folder_path = os.path.join(folder_path, pattern.format(7))
    if os.path.exists(rib7_folder_path):
        nums.append(7)
    for i in nums:
        file_path = os.path.join(folder_path, pattern.format(i))
        with open(file_path) as f:
            data = json.load(f)
        for markup in data['markups']:
            for control_point in markup["controlPoints"]:
                positions.append(control_point["position"][0])
                positions.append(control_point["position"][1])
                positions.append(control_point["position"][2])
    coords = np.array(positions).reshape(-1, 3)
    hull = ConvexHull(coords)
    volume = hull.volume
    vol_in_lt = volume/1000000
    return vol_in_lt



control_volumes = []
nums1 = [1,2,3,4,5,7,8]
for i in nums1:
    control_folder_path = f'Landmarks_JSON/Control/Contr{i}'
    pattern = 'Contr{i}_rib{}.mrk.json'
    volume = calculate_volume_from_json(control_folder_path, pattern)
    control_volumes.append(volume)



mean_volume = np.mean(control_volumes)

patient_volumes = []
nums2 = [1,2,3,4,5,7,9]
for i in nums2:
    preop_folder_path = f'Landmarks_JSON/preop/Preop{i}'
    postop_folder_path = f'Landmarks_JSON/postop/Postop{i}'
    pattern1 = 'Postop{i}_rib{}.mrk.json'
    pattern2 = 'Preop{i}_rib{}.mrk.json'
    preop_volume = calculate_volume_from_json(preop_folder_path, pattern1)
    postop_volume = calculate_volume_from_json(postop_folder_path, pattern2)
    patient_volumes.append((preop_volume, postop_volume))
    


for i, (preop_volume, postop_volume) in enumerate(patient_volumes):
  ratio = postop_volume/preop_volume
  print(f' 4_ribs Patient {i+1}: Preop volume: {preop_volume:.2f} liters, Postop volume: {postop_volume:.2f} liters, postop/preop ratio: {ratio:.2f}, Mean control volume: {mean_volume:.2f} liters')

