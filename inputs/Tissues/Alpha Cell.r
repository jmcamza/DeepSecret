# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Alpha Cell_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1093235","GSM1093236","GSM1649207","GSM1649201","GSM1649199","GSM1649206","GSM1649198","GSM1649205","GSM1649204","GSM1649208","GSM1649203","GSM1649200","GSM1649202","GSM2574469","GSM2574474","GSM2574480","GSM2574481","GSM2574482","GSM2574483","GSM2574485","GSM2574487","GSM2574489","GSM2574493","GSM2574496","GSM2574498","GSM2574500","GSM2574502","GSM2574503","GSM2574505","GSM2574510","GSM2574511",
"GSM2574513","GSM2574516","GSM2574517","GSM2574519","GSM2574520","GSM2574521","GSM2574523","GSM2574526","GSM2574527","GSM2574528","GSM2574529","GSM2574530","GSM2574531","GSM2574532","GSM2574533","GSM2574534","GSM2574540","GSM2574547","GSM2574550","GSM2574553","GSM2574554","GSM2574557","GSM2574559","GSM2574560","GSM2574561","GSM2574562","GSM2574575","GSM2574576","GSM2574580","GSM2574581",
"GSM2574582","GSM2574583","GSM2574585","GSM2574586","GSM2574587","GSM2574588","GSM2574591","GSM2574592","GSM2574593","GSM2574594","GSM2574595","GSM2574598","GSM2574599","GSM2574601","GSM2574602","GSM2574603","GSM2574604","GSM2574605","GSM2574607","GSM2574608","GSM2574613","GSM2574617","GSM2574618","GSM2574619","GSM2574620","GSM2574621","GSM2574622","GSM2574623","GSM2574625","GSM2574626",
"GSM2574627","GSM2574628","GSM2574629","GSM2574630","GSM2574631","GSM2574632","GSM2574633","GSM2574634","GSM2574635","GSM2574636","GSM2574638","GSM2574639","GSM2574640","GSM2574641","GSM2574642","GSM2574643","GSM2574644","GSM2574645","GSM2574646","GSM2574647","GSM2574648","GSM2574649","GSM2574650","GSM2574651","GSM2574652","GSM2574653","GSM2574655","GSM2574656","GSM2574657","GSM2574659",
"GSM2574660","GSM2574661","GSM2574662","GSM2574663","GSM2574664","GSM2574665","GSM2574673","GSM2574675","GSM2574686","GSM2574687","GSM3398188","GSM3398189","GSM3398190","GSM3398191","GSM3398192","GSM4118623","GSM4118624","GSM4118627","GSM4118628","GSM4118631","GSM4118632","")

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

