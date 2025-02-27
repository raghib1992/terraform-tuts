- To inherit parent terraform configuration file to child configuration file, we use include block
- It will process data from parent to child in current configuration file, if include block define
- terragrunt will process only one include block, it will throw error if additional block specified in files
- arguments 
    - name
    - path
    - expose
    - merge_strategy

```hcl
include "region" {
    name = region_data
    path = find_in_parent_folder("region.hcl")
    expose = true
    merge_strategy = "no_merge" # shallow(default), deep
}

```