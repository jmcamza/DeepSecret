# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "SKBR3_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1240658","GSM1240657","GSM1240654","GSM1240655","GSM1240660","GSM1240659","GSM1240653","GSM1240656","GSM2123959","GSM2123954","GSM2123952","GSM2123955","GSM2123931","GSM2123956","GSM2123917","GSM2123958","GSM2123947","GSM2123929","GSM2123935","GSM2123934","GSM2123951","GSM2123921","GSM2123927","GSM2123949","GSM2123953","GSM2123933","GSM2123923","GSM2123925","GSM2123950","GSM2123957","GSM2123924",
"GSM2123918","GSM2123932","GSM2123948","GSM2123946","GSM2123926","GSM2123928","GSM2123919","GSM2123930","GSM2126065","GSM2126067","GSM2126066","GSM2126064","GSM2126068","GSM2126063","GSM2545245","GSM2545246","GSM2545247","GSM2545248","GSM2691345","GSM2691346","GSM2514518","GSM2514519","GSM2514520","GSM2514521","GSM2514522","GSM2514523","GSM2514524","GSM2514525","GSM2514526","GSM2514527",
"GSM2514528","GSM2514529","GSM2514530","GSM2514531","GSM2514532","GSM2514533","GSM2514534","GSM2514535","GSM3369579","GSM3369580","GSM3369581","GSM3369582","GSM3145240","GSM3685071","GSM3685072","GSM3685073","GSM4454632","GSM4454633","GSM4454634","GSM4454635","GSM4454636","GSM4454637","GSM4852352","GSM4852353","GSM4852354","GSM4852355","GSM4852356","GSM4852357","GSM4852358","GSM4852359",
"GSM4852360","GSM4852361","GSM4852362","GSM4852363","GSM4852543","GSM4852544","GSM4852545","GSM4852546","GSM3156514","GSM3156515","GSM3156516","GSM3156517","GSM3156518","GSM3156519","GSM3680589","GSM3680591","GSM3680593","GSM3680598","GSM4774643","GSM4774645","GSM4774646","GSM4774647","GSM4774648","GSM4774649","GSM4774650","")

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

