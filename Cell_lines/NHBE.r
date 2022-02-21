# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "NHBE_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1964313","GSM1964314","GSM1964310","GSM1964312","GSM1964309","GSM1964311","GSM2267222","GSM2267223","GSM2267221","GSM2267220","GSM1517651","GSM1517652","GSM1517653","GSM1517654","GSM1517655","GSM1517656","GSM1517657","GSM1517658","GSM1517659","GSM1517660","GSM1517661","GSM1517662","GSM2454165","GSM2454166","GSM2454167","GSM2454168","GSM2454169","GSM2454170","GSM2454171","GSM2454172","GSM2454173",
"GSM2454174","GSM2454175","GSM2454176","GSM2454177","GSM2454178","GSM2454179","GSM2454180","GSM2454181","GSM2454182","GSM2454183","GSM2454184","GSM2454185","GSM2454186","GSM2454187","GSM2454188","GSM2454189","GSM2454190","GSM2454191","GSM2454192","GSM2454193","GSM2454194","GSM2454195","GSM2454196","GSM2454197","GSM2454198","GSM2454199","GSM2454200","GSM2454201","GSM2454202","GSM2454203",
"GSM2454204","GSM2454205","GSM2454206","GSM2454207","GSM2454208","GSM4432378","GSM4432379","GSM4432380","GSM4432381","GSM4432382","GSM4432383","GSM4462363","GSM4462364","GSM4462365","GSM4462366","GSM4462367","GSM4462368","GSM4462369","GSM4462370","GSM4462371","GSM4462372","GSM4462373","GSM4462374","GSM4462375","GSM4462376","GSM4462377","GSM4462378","GSM4462379","GSM4462380","")

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

