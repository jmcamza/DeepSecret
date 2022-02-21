# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Melanocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM819489","GSM819490","GSM1844562","GSM1844561","GSM1665987","GSM1844560","GSM1953864","GSM2072481","GSM2072482","GSM2072483","GSM2072484","GSM2459963","GSM2459965","GSM2459964","GSM2459960","GSM2459962","GSM2459961","GSM2664414","GSM2664415","GSM2664416","GSM2664417","GSM2664418","GSM2664419","GSM2664420","GSM2664421","GSM2664422","GSM2664423","GSM2664424","GSM2664425","GSM2664426","GSM2664427",
"GSM2664428","GSM2344965","GSM2344966","GSM2344967","GSM2464574","GSM2464575","GSM3191784","GSM3191785","GSM3191786","GSM4084032","GSM4084033","GSM4084046","GSM4084047","GSM3209079","GSM3703291","GSM3703292","GSM3703293","GSM3703294","GSM3703295","GSM3703296","GSM3703297","GSM3703298","GSM3703299","GSM3703300","GSM3703301","GSM3703302","GSM3703304","GSM3703305","GSM3703306","GSM3703307",
"GSM3703308","GSM3703309","GSM3703310","GSM3703311","GSM3703312","GSM3703314","GSM3703315","GSM3703316","GSM3703317","GSM4107646","GSM4107647","GSM4107648","GSM4107649","GSM4107650","GSM4692881","GSM4692882","GSM3703303","GSM3703313","GSM4491285","GSM4491286","GSM4491287","GSM4491288","GSM4491289","GSM4491290","GSM4491291","GSM4491292","GSM4491293","GSM4491294","GSM4491295","GSM4491296",
"GSM4498884","GSM4498885","GSM4498886","GSM4594203","GSM4594205","GSM4594206","GSM4594207","GSM4594208","GSM4594211","GSM4594212","GSM4594213","GSM4659019","GSM4659020","GSM4659021","GSM4659022","GSM4659023","GSM4659024","GSM4659025","GSM4659026","GSM4659027","GSM4659028","GSM4659029","GSM4659030","GSM4659031","GSM4659032","GSM4659033","GSM4659034","GSM4659035","GSM4659036","GSM4659037",
"GSM4659038","GSM4659039","GSM4659040","GSM4117557","GSM4117558","GSM4117559","GSM4117560","GSM4117561","GSM4117562","GSM4117563","GSM4117564","GSM4117565","GSM4117566","GSM4117567","GSM4117568","GSM5031682","GSM5031683","GSM5031684","GSM5031685","GSM5240147","GSM5240149","GSM5240150","GSM5240164","GSM5240165","GSM5240178","GSM5240179","GSM5240180","GSM5240181","GSM5293167","GSM5293168",
"GSM5293169","GSM5293170","GSM5293171","GSM5293172","GSM5293173","GSM5293174","GSM5293175","GSM5293176","GSM5293177","GSM5293178","")

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

