# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "HNSCC_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1864263","GSM1864266","GSM1864247","GSM1864252","GSM1864255","GSM1864262","GSM1864251","GSM1864264","GSM1864253","GSM1864260","GSM1864258","GSM1864254","GSM1864248","GSM1864249","GSM1864259","GSM1864265","GSM1864256","GSM1864261","GSM1864250","GSM1864257","GSM1864245","GSM2199361","GSM2199362","GSM2199358","GSM2199363","GSM2199359","GSM2199360","GSM1864246","GSM1864267","GSM1587790","GSM1587789",
"GSM3120988","GSM3120989","GSM3120990","GSM3120991","GSM3120992","GSM3120993","GSM3120994","GSM3120995","GSM3120996","GSM3120997","GSM3120998","GSM3120999","GSM3121000","GSM3121001","GSM3121013","GSM3121014","GSM3121015","GSM3121016","GSM3121017","GSM3121018","GSM3121019","GSM3121020","GSM3121021","GSM3121022","GSM3121023","GSM3121024","GSM3121025","GSM3121026","GSM3121027","GSM3121028",
"GSM3121029","GSM3121030","GSM3121031","GSM3121032","GSM3121033","GSM3121034","GSM3121035","GSM3121036","GSM3121037","GSM3121038","GSM3121039","GSM3121040","GSM3121041","GSM3121042","GSM3121043","GSM3121044","GSM3121045","GSM3121046","GSM3121047","GSM3121048","GSM3121049","GSM3121050","GSM3121051","GSM3121052","GSM3121053","GSM3121054","GSM3121055","GSM3121056","GSM3121057","GSM3121058",
"GSM3121059","GSM3121060","GSM3121061","GSM3121062","GSM3121063","GSM3121064","GSM3121065","GSM3121066","GSM3121067","GSM3121068","GSM3121069","GSM3121070","GSM3121071","GSM3121072","GSM3121077","GSM3121078","GSM3121079","GSM3121080","GSM3121081","GSM3121082","GSM3121083","GSM3121084","GSM3121085","GSM3121087","GSM2559518","GSM2559519","GSM4017093","GSM4017094","GSM4017095","GSM4017096",
"GSM4017097","GSM4017098","GSM4017099","GSM4017100","GSM4017101","GSM4017102","GSM4017103","GSM4017104","GSM4017105","GSM4017106","GSM4017107","GSM4017108","GSM4017109","GSM4017110","GSM4080890","GSM4080891","GSM4080892","GSM4080893","GSM4080894","GSM4080895","GSM4080896","GSM4080897","GSM4080898","GSM4080899","GSM4080900","GSM4080901","GSM4982790","GSM4982792","GSM4763810","GSM4763811",
"GSM4763812","GSM4763813","GSM4763814","GSM4763815","")

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

