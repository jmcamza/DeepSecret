# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Podocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2132128","GSM2132132","GSM2132130","GSM2132129","GSM2132133","GSM2132131","GSM2204047","GSM2204048","GSM2204049","GSM2204050","GSM2204051","GSM2204052","GSM2648047","GSM2648049","GSM2648050","GSM2648051","GSM2648052","GSM3048782","GSM3048783","GSM3048784","GSM3239685","GSM3239686","GSM3239689","GSM3239690","GSM3239691","GSM3239693","GSM3239694","GSM3839981","GSM3839982","GSM3839983","GSM3839984",
"GSM3348169","GSM3348170","GSM3348171","GSM3348172","GSM3348173","GSM3348174","GSM3348175","GSM3348176","GSM3348177","GSM3348178","GSM3348179","GSM3348180","GSM3733338","GSM3733339","GSM3733340","GSM3733341","GSM3733342","GSM3733343","GSM3933294","GSM3933295","GSM3933296","GSM3933297","GSM3933298","GSM3933299","GSM3933300","GSM3933301","GSM3933302","GSM3933303","GSM3933304","GSM3933305",
"GSM3724164","GSM3724165","GSM3724166","GSM3724167","GSM3724168","GSM3724169","GSM3724170","GSM3724171","GSM3724172","GSM3724173","GSM3724174","GSM3724175","GSM4579271","GSM4579272","GSM4579273","GSM4579274","GSM4579275","GSM4579276","GSM4579277","GSM4579278","GSM4579279","GSM4579280","GSM4579281","GSM4579282","GSM4579283","GSM4579284","GSM4579285","GSM4579286","GSM4579287","GSM4579288",
"GSM3314502","GSM4851997","GSM4851998","GSM4851999","GSM4852000","GSM4852001","GSM4852003","GSM4852004","GSM4852005","")

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

