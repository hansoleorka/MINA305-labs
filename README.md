# MINA305labs

List of labs:

1.  [Data sources](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/01_DataSources/01_datasources.nb.html)

2.  R crash course

3.  [Optical Satellite Imagery](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/03_OpticalSatelliteImagery/03_LabCode_OpticalSatelliteImagery.nb.html)

4.  [Point Clouds](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/04_PointClouds/04_PointClouds.nb.html)

5.  [Area-Based Approach (ABA)](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/05_AreaBasedApproach/05_LabCode_AreaBasedApproach.nb.html)

6.  [Individual Tree Crown Approach (ITC)](https://htmlpreview.github.io/?https://github.com/hansoleorka/MINA305-labs/blob/main/06_IndividualTreeCrownApproach/06_LabCode_IndividualTreeCrownApproach.nb.html)

## Setting up a lab as an RStudio project

Set up each lab as its own RStudio project. The lab code reads files with relative paths such as `"data/..."` and `"R/..."`, so it only works when R's working directory is the project folder.

1.  **Create the project.** In RStudio, choose *File → New Project… → New Directory → New Project*. Give the folder the name of the lab and click *Create Project*. RStudio makes the folder and a `.Rproj` file in it, and opens the project.

2.  **Download and unzip the data.** Download the zip file given in the data instructions at the top of the lab. Unzip it directly into the project folder. The zip file already contains the `data` folder (and an `R` folder with helper functions, if the lab has any), so you do not need to create these folders yourself. Check that `data/` sits directly in the project folder and not inside an extra folder (e.g. `<lab_name>/<zip_name>/data/`); if it does, move it up one level.

3.  **Get the lab code.** Download the lab's `.R` file from this repository and save it in the project folder itself, not in a subfolder.

4.  **Work in the project.** Always open the lab by double-clicking the `.Rproj` file (or *File → Open Project…*) so the working directory is set correctly. Check it with `getwd()`. Do not use `setwd()`.

The finished project should look like this:

```         
<lab_name>/
├── <lab_name>.Rproj
├── <lab_code>.Rmd
├── data/
│   └── ...        data files and folders (from the zip file)
└── R/
    └── ...        helper functions (from the zip file, if the lab has any)
```
