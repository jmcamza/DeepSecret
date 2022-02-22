# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "SKNSH_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM973675","GSM973665","GSM973667","GSM973688","GSM973663","GSM973666","GSM973689","GSM981250","GSM973692","GSM981251","GSM981253","GSM973677","GSM1693119","GSM1693120","GSM1693122","GSM1693117","GSM1693118","GSM1693121","GSM1693123","GSM1693124","GSM979647","GSM979646","GSM979648","GSM2410323","GSM2410325","GSM2410324","GSM2410327","GSM2410326","GSM2410329","GSM2400229","GSM2400228",
"GSM2410328","GSM2400225","GSM2400224","GSM2400227","GSM2400226","GSM2410332","GSM2410330","GSM2410331","GSM2470063","GSM2470064","GSM2664404","GSM2664409","GSM2664410","GSM2664411","GSM2664412","GSM2664413","GSM3567446","GSM3567447","GSM3567448","GSM3567449","GSM3567450","GSM3567451","GSM3567452","GSM3567453","GSM4916133","GSM4916134","GSM4916135","GSM4916136","GSM4916137","GSM4916139",
"GSM4916140","GSM4916141","GSM4916142","GSM4916143","GSM4916144","GSM1006906","GSM1006907","GSM1006910","GSM3192005","GSM3192006","GSM3192007","GSM3192008","GSM3192009","GSM3192010","GSM3192011","GSM3192012","GSM3192013","GSM3192014","GSM3192015","GSM3192016","GSM3192017","GSM3192018","GSM3192019","GSM3192033","GSM4117243","GSM4117245","GSM5208095","GSM5208096","GSM5208099","GSM5208100",
"GSM5324079","GSM5324080","GSM5324081","GSM5324082","GSM5324083","GSM5324084","GSM5324085","GSM5324086","GSM5324087","")

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

