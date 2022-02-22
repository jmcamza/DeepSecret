# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "A431_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1097787","GSM1470410","GSM1975775","GSM1470409","GSM1470407","GSM1470408","GSM1470398","GSM1470397","GSM1470396","GSM1470395","GSM1975774","GSM2112557","GSM2112551","GSM2112558","GSM2112554","GSM2112556","GSM2112555","GSM2112552","GSM2112553","GSM3728922","GSM3728923","GSM3728927","GSM3728928","GSM3728929","GSM3728930","GSM3728931","GSM3728932","GSM4007370","GSM4007371","GSM4007372","GSM4007373",
"GSM4007374","GSM4007375","GSM4767250","GSM4767251","GSM4767252","")

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

