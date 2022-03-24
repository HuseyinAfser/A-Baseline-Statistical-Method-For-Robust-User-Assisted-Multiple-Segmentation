# DGL-Based-Segmentation
A Baseline Statistical Method For Robust User-Assisted Multiple Segmentation
Author: Huseyin Afşer

This code implements DGL test-based multiple image segmentation method presented
in the paper "A Baseline Statistical Method For Robust User-Assisted Multiple Segmentation" by Huseyin Afşer. The paper is submitted to IEEE Signal Processing Letters and also available at https://arxiv.org/abs/2201.02779.

The code implements the proposed segmentation method for different types of user inputs (UI) and amounts for the
test images of BSDS500 image database. It calculates the accuracy in terms of intersection over union (IoU) by averaging it over multiple images and multiple ground truth annotations.  


### Environments ###
- Matlab 2016b. 
- Image Processing Toolbox
- Berkeley's BSDS500 image data set (test images and corresponding ground truths)

### How to Run ###
- The images must be located in the folder /data/images
- The ground truths must be located in the folder /data/groundTruth
- The output will be put in the folder /results, so this folder must be created before benchmarking.
- The code is implemented for all the test images in /data/images folder.
- Since Codeocean has a CPU quota we have only placed 2 test images in /data/images folder. For full benchmarking 200 test images in BSDS500 database and the ground truths must be placed in the corresponding folders.
- Running testbench.m creates the accuracy plot (Fig. 4 in the paper).
- Testing a single user input type and amount takes a few hours (this varies on the CPU and parallel
processing capabilities). Since there are 14 different tests in the paper, full benchmarking may take some time.  


### Functions ###

-  testbench.m : Generates the accuracy plot in Fig. 4 in the paper.

- testbench_UI_type_amount.m : Calculates the average accuracy (averaged over multiple images and multiple annotation for a chosen UI type and UI amount in the HS domain

 UI type 1 : a fraction of labeled pixels from ground truth masks
 UI type 2 : a number of seed points within ground truth masks
 UI type 3 : a fraction of labeled pixels from bounding boxes
 UI type 4 : pixels from randomly perturbed bounding boxes
 UI amount : {1,0.75,0.5,0.25} for UI type 1, 3
 UI amount : {10,15,20} for UI type 2
 UI amount : {5,10,15} for UI type 4

- DGL_Based_Robust_Segmentation.m: Calculates the accuracy of chosen BSDS image by averaging it multiple user annotations. 

- calc_Q_hat.m: Calculates the nominal distributions, Q_hat, in eq(5) from the user inputs with specified amount.

- DGLSegment_HS_domain.m : This function implements the DGL test, eq (6) and (7) in the paper, for the vector of pixels in a given superpixel.

- read_BSDS_image.m : Reads a BSDS image from corresponding folder and calculates the ground truth annotations where at least 90% of the pixels are covered. Calculates the number of regions for each ground truth annotation.

- Calc_A_HS_domain.m: Calculates the Borel sets, eq (6) in the paper, in the HS domain
 with equally spaced histogram bins.

- Prob_A_HS_domain.m: Calculates the probabilities of the Borel sets in eq (7) in the paper.

- Calc_mu_HS_domain.m: Calculates the test statistics mu_n(A) in eq (7).

- Calc_genie_aided_accuracy.m: Calculates the genie aided-accuracy (IoU) as explained in the paper.


### Remarks ###

- The complexity of the proposed method is quadratic in the number of image regions, M,. There exist some images in BSDS500 database with M>40 and segmenting these images may take some time. If fast benchmarking (a few hours) is required one can adaptively change the alphabet size (by changing the size_of_X parameter in DGL_Based_Robust_Segmentation.m) for these images.




