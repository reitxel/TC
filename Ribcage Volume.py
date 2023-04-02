import json
import numpy as np
import os
from scipy.spatial import ConvexHull

#volume for patients with 4 ribs
def calculate_volume_from_json_all(folder_path, pattern):
    positions = []
    for i in range(1, 5):
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



#volume for patients with 3 ribs
def calculate_volume_from_json_three(folder_path, pattern):
    positions = []
    for i in range(1, 4):
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
for i in range(1, 8):
    control_folder_path = f'Landmarks_JSON/Control/Contr{i}'
    pattern = 'rib{}.mrk.json'
    volume = calculate_volume_from_json_all(control_folder_path, pattern)
    control_volumes.append(volume)

mean_volume = np.mean(control_volumes)

#patients with 4 ribs located
patient_volumes_four = []
for i in range(1, 4):
    preop_folder_path = f'Landmarks_JSON/preop_4/Preop{i}'
    postop_folder_path = f'Landmarks_JSON/postop_4/Postop{i}'
    pattern = 'rib{}.mrk.json'
    preop_volume = calculate_volume_from_json_all(preop_folder_path, pattern)
    postop_volume = calculate_volume_from_json_all(postop_folder_path, pattern)
    patient_volumes_four.append((preop_volume, postop_volume))
    
#patients with 3 ribs located
patient_volumes_three = []
for i in range(1, 5):
    preop_folder_path = f'Landmarks_JSON/preop_3/Preop{i}'
    postop_folder_path = f'Landmarks_JSON/postop_3/Postop{i}'
    pattern = 'rib{}.mrk.json'
    preop_volume = calculate_volume_from_json_three(preop_folder_path, pattern)
    postop_volume = calculate_volume_from_json_three(postop_folder_path, pattern)
    patient_volumes_three.append((preop_volume, postop_volume))

for i, (preop_volume, postop_volume) in enumerate(patient_volumes_four):
  ratio = postop_volume/preop_volume
  print(f' 4_ribs Patient {i+1}: Preop volume: {preop_volume:.2f} liters, Postop volume: {postop_volume:.2f} liters, postop/preop ratio: {ratio:.2f}, Mean control volume: {mean_volume:.2f} liters')

for i, (preop_volume, postop_volume) in enumerate(patient_volumes_three):
  ratio = postop_volume/preop_volume
  print(f' 3_ribs Patient {i+1}: Preop volume: {preop_volume:.2f} liters, Postop volume: {postop_volume:.2f} liters, postop/preop ratio: {ratio:.2f}, Mean control volume: {mean_volume:.2f} liters')