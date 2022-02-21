# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Oocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1160113","GSM1160114","GSM1160112","GSM1833282","GSM1833279","GSM1833280","GSM1833281","GSM1861611","GSM1861608","GSM1861606","GSM1861609","GSM1861610","GSM1861607","GSM2514771","GSM2514772","GSM2514773","GSM2514774","GSM2514775","GSM2514776","GSM2514777","GSM2514778","GSM2514779","GSM2514780","GSM2514781","GSM2514782","GSM2514783","GSM2514784","GSM2514785","GSM2514786","GSM2514787","GSM2514788",
"GSM2514789","GSM2514790","GSM3016986","GSM3016987","GSM3016988","GSM3016989","GSM3016990","GSM3016991","GSM2877811","GSM2877812","GSM2877813","GSM2877814","GSM2877815","GSM2877816","GSM2877817","GSM2877818","GSM2877819","GSM2877820","GSM2877821","GSM2877822","GSM2877823","GSM2877824","GSM2877825","GSM2877826","GSM2877827","GSM2877828","GSM2877829","GSM2877830","GSM2877831","GSM2877832",
"GSM2877833","GSM2877834","GSM2877835","GSM2877836","GSM2877837","GSM2877838","GSM2877839","GSM2877840","GSM2877841","GSM2877842","GSM2877843","GSM2877844","GSM2877845","GSM2877846","GSM2877847","GSM2877848","GSM2877849","GSM2877850","GSM2877851","GSM2877852","GSM2877853","GSM2877854","GSM2877855","GSM2877856","GSM2877857","GSM2877858","GSM2877859","GSM2877860","GSM2877861","GSM2877862",
"GSM2877863","GSM2877864","GSM2877865","GSM2877866","GSM2877867","GSM2877868","GSM2877869","GSM2877870","GSM2877871","GSM2877872","GSM2877873","GSM2877874","GSM2877875","GSM2877876","GSM2877877","GSM2877878","GSM2877879","GSM2877880","GSM2877881","GSM2877882","GSM2877883","GSM2877884","GSM2877885","GSM2877886","GSM2877887","GSM3568641","GSM3568642","GSM3568643","GSM3568644","GSM3568645",
"GSM3568646","GSM3425247","GSM3425249","GSM3928346","GSM3928349","GSM3928350","GSM3928351","GSM3928352","GSM3928353","GSM1941546","GSM1941547","GSM1941548","GSM1941549","GSM1941550","GSM1941551","GSM1941552","GSM1941553","GSM1941554","GSM1941555","GSM1941556","GSM1941557","GSM1941558","GSM1941559","GSM3928347","GSM3928354","GSM4696892","GSM4696894","GSM4696896","GSM4802479","GSM4802480",
"GSM4802482","GSM4802483","GSM4802484","GSM4802485","GSM4802486","GSM4802487","GSM4802488","GSM4802489","GSM4802490","GSM4802491","GSM4802493","GSM4802494","GSM4802496","GSM4802497","GSM4802498","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/samples/geo_accession")
genes = h5read(destination_file, "meta/genes/genes")

# Identify columns to be extracted
sample_locations = which(samples %in% samp)

# extract gene expression from compressed data
expression = t(h5read(destination_file, "data/expression", index=list(sample_locations, 1:length(genes))))
H5close()
rownames(expression) = genes
colnames(expression) = samples[sample_locations]

# Print file
write.table(expression, file=extracted_expression_file, sep="\t", quote=FALSE, col.names=NA)
print(paste0("Expression file was created at ", getwd(), "/", extracted_expression_file))

