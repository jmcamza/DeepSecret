# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "NHDF_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM984612","GSM1194812","GSM1194811","GSM977034","GSM1194813","GSM1194805","GSM1194806","GSM1194808","GSM1194810","GSM1194809","GSM1194807","GSM1194814","GSM2051884","GSM2051885","GSM1470717","GSM1470716","GSM979662","GSM1470724","GSM1470725","GSM1693009","GSM1693010","GSM1693011","GSM1693012","GSM1693013","GSM1693014","GSM2862286","GSM2862287","GSM3511297","GSM3511298","GSM3511299","GSM3511300",
"GSM3511301","GSM3511302","GSM3511303","GSM3511304","GSM3511305","GSM3511306","GSM3511307","GSM3511308","GSM3511309","GSM3511310","GSM3511311","GSM3511312","GSM3511313","GSM3511314","GSM3511315","GSM3511316","GSM3511317","GSM3511318","GSM3511319","GSM3511320","GSM3511321","GSM3511322","GSM3511323","GSM3511324","GSM3511325","GSM3511326","GSM3511327","GSM3511328","GSM3511329","GSM3511330",
"GSM3511331","GSM3511332","GSM3511333","GSM3511334","GSM3511335","GSM3496099","GSM4282810","")

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

