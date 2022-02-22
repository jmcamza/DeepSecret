# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "NALM6_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1648606","GSM1648613","GSM1648610","GSM1648609","GSM1648604","GSM1648612","GSM1648608","GSM1648611","GSM1648605","GSM1648614","GSM1649154","GSM1648615","GSM1649153","GSM1648607","GSM1320482","GSM2494156","GSM2494157","GSM2494158","GSM2494159","GSM2494160","GSM2494161","GSM2494162","GSM2494163","GSM2494164","GSM3308820","GSM3308821","GSM3308822","GSM3308823","GSM3308824","GSM3308825","GSM3308826",
"GSM3308827","GSM3308828","GSM3308829","GSM3308830","GSM3308831","GSM3308832","GSM3308833","GSM3308834","GSM3308835","GSM3308836","GSM3308837","GSM3308838","GSM3308839","GSM3308840","GSM3308841","GSM3308842","GSM3308843","GSM3344631","GSM3344632","GSM3344633","GSM3344634","GSM3425394","GSM3425395","GSM3425396","GSM3425397","GSM3425398","GSM3425399","GSM3425400","GSM3425401","GSM3692513",
"GSM3177101","GSM3177102","GSM3177103","GSM3177104","GSM3177105","GSM3177106","GSM3177107","GSM3177108","GSM3177109","GSM3177110","GSM3177111","GSM3177112","GSM4454887","GSM4454888","GSM4454889","GSM4454890","GSM4454891","GSM4454892","GSM4454894","GSM4454895","GSM4454896","GSM4454897","GSM4454898","GSM4117207","GSM4117209","GSM4559448","GSM4559449","GSM4559450","GSM4559452","GSM4559453",
"GSM4880582","GSM4880583","GSM4880584","GSM4880585","GSM4880586","GSM4880587","GSM4880588","GSM4880589","GSM4880590","GSM4880591","GSM4880592","GSM4880593","GSM5093348","GSM5093350","GSM5093351","GSM5093352","GSM5093353","")

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

