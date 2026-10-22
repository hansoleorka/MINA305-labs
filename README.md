# MINA305labs

List of labs:

1.  [Data sources](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/01_DataSources/01_datasources.nb.html)

2.  R crash course

3.  [Optical Satellite Imagery](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/03_OpticalSatelliteImagery/03_LabCode_OpticalSatelliteImagery.nb.html)

4.  [Point Clouds](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/04_PointClouds/04_PointClouds.nb.html)

5.  [Area-Based Approach (ABA)](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/05_AreaBasedApproach/05_LabCode_AreaBasedApproach.nb.html)

6.  [Individual Tree Crown Approach (ITC)](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/06_IndividualTreeCrownApproach/06_LabCode_IndividualTreeCrownApproach.nb.html)

## Setting up a lab as an RStudio project

Set up each lab as its own RStudio project. The lab code uses relative paths such as `"data/lab3.gpkg"` and `source("R/laser.colors.R")`, so it only works when R's working directory is the project folder.

1.  **Create the project.** In RStudio, choose *File → New Project… → New Directory → New Project*. Name the folder after the lab (e.g. `05_AreaBasedApproach`) and click *Create Project*. RStudio makes the folder and a `.Rproj` file in it, and opens the project.

2.  **Create the subfolders.** In the project folder, make a `data` folder and an `R` folder, either in the *Files* pane (*New Folder*) or from the R console:

    ``` r
    dir.create("data")
    dir.create("R")
    ```

3.  **Download the data.** Follow the *Data* / *Data download* instructions at the top of each lab and put the files in `data/`. If the download is a zip file, unzip it inside `data/` and keep the folder names (e.g. `data/frydenhaug/als2021.laz`, `data/vaaler/las/`).

4.  **Get the lab code.** Download the lab's `.Rmd` (or `.R`) file from this repository and save it in the project folder itself, not in a subfolder. If the lab has helper functions in an `R/` folder in this repository (e.g. `laser.colors.R` and `stdmetricsNOR.R` in lab 5), download those into your `R/` folder.

5.  **Work in the project.** Always open the lab by double-clicking the `.Rproj` file (or *File → Open Project…*) so the working directory is set correctly. Check it with `getwd()`. Do not use `setwd()`.

The finished project should look like this:

```
05_AreaBasedApproach/
├── 05_AreaBasedApproach.Rproj
├── 05_LabCode_AreaBasedApproach.Rmd
├── data/
│   ├── frydenhaug/
│   └── vaaler/
└── R/
    ├── laser.colors.R
    └── stdmetricsNOR.R
```
