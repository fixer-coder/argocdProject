"""
 move content from one file to different files
"""

# istioctl manifest generate --filename istiocontrolplane.yaml  > <this file>

import os
import subprocess
import re
from pathlib import Path

path_to_file = "/Users/dosagie/dev/learning/argocd_projects/staging-cluster-services/istio-system/control-plane/testing/1-12-6/control_plane_generated.yaml"

TMP_FILENAME = "tmp.yaml"
SEARCH_NAME = "  name: "
SEARCH_KIND = "kind: "

COUNTER = 0


def get_file_content_with(filepath):
    """Get the content of file using with"""
    # return open(filepath, "r")
    with open(filepath) as f:
        content = f.read()
    return content


def get_index_of_divider(content):
    index_list = []
    for m in re.finditer('---', content):
        index_list.append(m.start(0))
    return index_list


def get_cat_out(path_file, search_wold):
    stdout_value = subprocess.Popen(
        f"cat {path_file} | grep '{search_wold}'  | head -1",
        shell=True,
        stdout=subprocess.PIPE,
    )
    subprocess_return = stdout_value.stdout.read()
    return subprocess_return.decode("utf-8")


def write_to_file(file_name, content, action="w"):
    with open(f"{file_name}", action) as f:
        f.write(content)


def make_sure_dir_exist(dir_name):
    Path(dir_name).mkdir(parents=True, exist_ok=True)


def generate_objects_to_it_folder(file_content):
    write_to_file(TMP_FILENAME, file_content)
    file_name = get_cat_out(TMP_FILENAME, SEARCH_NAME).split(SEARCH_NAME)
    file_kind = get_cat_out(TMP_FILENAME, SEARCH_KIND).split(SEARCH_KIND)
    dir_name = file_kind[1].strip()
    make_sure_dir_exist(dir_name)
    file_path_name = f"{file_name[1].strip()}.yaml"
    write_to_file(f"{dir_name}/{file_path_name}", file_content)
    create_update_kustomize_file_in_folders(file_path_name, dir_name)
    create_kustomize_file_in_root_folder(dir_name)


def create_update_kustomize_file_in_folders(filename, file_dir):
    kustomize_path = f"{file_dir}/kustomization.yaml"
    kustomize_content = "apiVersion: kustomize.config.k8s.io/v1beta1\n" \
                        "kind: Kustomization\n\n" \
                        "resources:\n"
    if not os.path.exists(kustomize_path):
        write_to_file(kustomize_path, kustomize_content)
    if not get_cat_out(kustomize_path, file_dir):
        write_to_file(kustomize_path, f"  - {filename}\n", action="a")


def create_kustomize_file_in_root_folder(file_dir):
    kust_name = "kustomization.yaml"
    kustomize_content = "apiVersion: kustomize.config.k8s.io/v1beta1\n" \
                        "kind: Kustomization\n\n" \
                        "resources:\n"
    if not os.path.exists(kust_name):
        write_to_file(kust_name, kustomize_content)

    # check if folder in kustomize already
    if not get_cat_out(kust_name, file_dir):
        write_to_file(kust_name, f"  - {file_dir}\n", action="a")


if __name__ == "__main__":
    content = get_file_content_with(path_to_file)
    index_list = get_index_of_divider(content)
    # Copy first crd before doing the others
    file_con_01 = content[0:index_list[0]]
    generate_objects_to_it_folder(file_con_01)
    # print(content[index_list[0]: index_list[1]])
    while len(index_list) > 1:
        file_con = content[index_list[0]:index_list[1]]
        generate_objects_to_it_folder(file_con)
        index_list.pop(0)
