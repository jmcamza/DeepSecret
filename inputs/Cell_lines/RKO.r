# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "RKO_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1657080","GSM1665957","GSM1665953","GSM1657079","GSM1665949","GSM1657078","GSM1665955","GSM1665947","GSM1665964","GSM1665960","GSM1665961","GSM1665954","GSM1665962","GSM1665956","GSM1379557","GSM1665951","GSM1665963","GSM1665958","GSM1665959","GSM1665952","GSM1665948","GSM1665946","GSM1665966","GSM1665950","GSM1379556","GSM1665965","GSM2089695","GSM2089696","GSM2089694","GSM2089693","GSM2144413",
"GSM2515720","GSM2515721","GSM2515722","GSM2515723","GSM2414792","GSM2509517","GSM2509518","GSM2711785","GSM2711786","GSM2711787","GSM2711788","GSM2711789","GSM2711790","GSM2711791","GSM2711792","GSM2711793","GSM2711794","GSM2711795","GSM2711796","GSM2597672","GSM2597673","GSM3021854","GSM3021855","GSM3021856","GSM3021857","GSM3021858","GSM3021859","GSM3021860","GSM3021861","GSM3130652",
"GSM3130653","GSM3130654","GSM3130655","GSM3130656","GSM3130657","GSM3130658","GSM3130659","GSM2894015","GSM2894016","GSM2894017","GSM2894018","GSM2274666","GSM2274667","GSM3450588","GSM3450590","GSM3450592","GSM3450594","GSM3450596","GSM3450598","GSM3175550","GSM3175551","GSM3573091","GSM3573092","GSM3573093","GSM3573094","GSM3573095","GSM3573096","GSM3573097","GSM3573098","GSM3573099",
"GSM3573100","GSM3685744","GSM3685746","GSM4293580","GSM4293581","GSM4306640","GSM4306642","GSM4306643","GSM4763775","GSM4763776","GSM4763779","GSM4779281","GSM4779282","GSM4779283","GSM4779284","GSM4779285","GSM4779286","GSM4827150","GSM4827151","GSM4956188","GSM4956189","GSM4956190","GSM5114054","GSM5114055","GSM5114060","GSM5114061","GSM5114062","GSM5114063","GSM5114068","GSM5114070",
"GSM5114071","GSM5282926","GSM5403674","GSM5403675","GSM5403676","GSM5403677","GSM5403679","")

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

