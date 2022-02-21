# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "SKOV3_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1348967","GSM1348965","GSM1348966","GSM1348954","GSM1348964","GSM1348955","GSM1348963","GSM1348962","GSM1348968","GSM2794657","GSM2794658","GSM2794659","GSM2794660","GSM2794661","GSM2794662","GSM2631741","GSM2631742","GSM2631743","GSM2631744","GSM2631745","GSM2631746","GSM2631747","GSM2631748","GSM3613426","GSM3613427","GSM3613428","GSM3613429","GSM3613430","GSM3613431","GSM2855461","GSM2855462",
"GSM2855463","GSM2855464","GSM3301707","GSM3301708","GSM3301709","GSM3301710","GSM3301711","GSM3301712","GSM3301713","GSM3301714","GSM3301715","GSM3301716","GSM3301717","GSM3301718","GSM4331054","GSM4331055","GSM4331056","GSM4331057","GSM4331058","GSM4331059","GSM4804211","GSM4804212","GSM4804213","GSM4804214","GSM4914631","GSM4914632","GSM4914633","GSM4914634","GSM4914635","GSM4914636",
"GSM3561110","GSM3561111","GSM3561112","GSM3561113","GSM3561114","GSM3561115","GSM3561116","GSM3561117","GSM3561118","GSM4117398","GSM4117399","GSM4117400","GSM4196438","GSM4196439","GSM4196440","GSM4196441","GSM5049693","GSM5049694","GSM5049695","GSM5049696","GSM5271159","GSM5271160","GSM5271161","GSM5271162","GSM5271163","GSM5271164","GSM5271165","GSM5271166","GSM5271167","GSM5399975",
"GSM5399976","GSM5399977","GSM5399978","GSM5399979","GSM5399981","GSM5399982","GSM5399983","")

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

