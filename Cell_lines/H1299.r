# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "H1299_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1091844","GSM1091843","GSM1321440","GSM2441392","GSM2441390","GSM2441391","GSM2441389","GSM2441385","GSM2441386","GSM2441381","GSM2441382","GSM1901032","GSM1901030","GSM1901019","GSM1901020","GSM1901029","GSM1901038","GSM1901021","GSM1901024","GSM1901034","GSM1901036","GSM1901018","GSM1901028","GSM1901025","GSM1901023","GSM1901027","GSM1901022","GSM1901035","GSM1901026","GSM1901037","GSM1901033",
"GSM1901031","GSM1901039","GSM2150341","GSM2150339","GSM2150336","GSM2150338","GSM2150345","GSM2150344","GSM2150337","GSM2150342","GSM2150340","GSM2150343","GSM2171222","GSM2171219","GSM2171217","GSM2171221","GSM2171223","GSM2171220","GSM2171218","GSM2171216","GSM2412402","GSM2412403","GSM2412404","GSM2412405","GSM2945854","GSM3100231","GSM3100232","GSM3100233","GSM3100234","GSM3100235",
"GSM3100236","GSM3100237","GSM3100238","GSM3100239","GSM3100240","GSM3386593","GSM3386594","GSM3386595","GSM3386596","GSM3386597","GSM3386598","GSM3386599","GSM3386600","GSM3386601","GSM3386602","GSM4161259","GSM4161260","GSM4161261","GSM4161262","GSM4161263","GSM4161264","GSM4161265","GSM4161266","GSM4161267","GSM4161268","GSM4161269","GSM4161270","GSM4161271","GSM4161272","GSM4161273",
"GSM4161274","GSM4161275","GSM4161276","GSM4161277","GSM4161278","GSM4161279","GSM4161280","GSM4161281","GSM4161282","GSM2097524","GSM3380342","GSM3380343","GSM3380344","GSM3380345","GSM3755458","GSM3755459","GSM3755460","GSM3755461","GSM4210790","GSM4210791","GSM4210792","GSM4210793","GSM4210794","GSM4210795","GSM4210796","GSM4210797","GSM4210798","GSM4210799","GSM4210800","GSM4210801",
"GSM4036764","GSM4036765","GSM4036766","GSM4036767","GSM4085032","GSM4085033","GSM4085034","GSM4085035","GSM4085036","GSM4085037","GSM4286770","GSM4477854","GSM4477855","GSM4477856","GSM4477857","GSM4477858","GSM4477859","GSM4477860","GSM4477861","GSM4477862","GSM4477863","GSM4477864","GSM4477865","GSM4477866","GSM4477867","GSM4477868","GSM4477869","GSM4477870","GSM4477871","GSM4477872",
"GSM4477873","GSM4477874","GSM4477875","GSM4568467","GSM4568468","GSM4568469","GSM4568470","GSM4568471","GSM4568472","GSM4568473","GSM4568474","GSM4568475","GSM3431173","GSM3431174","GSM3538113","GSM3538114","GSM3538115","GSM3538116","GSM3538117","GSM3538118","GSM3538119","GSM3538120","GSM3538121","GSM3538122","GSM3538123","GSM3538124","GSM3538125","GSM3538126","GSM3538127","GSM3538128",
"GSM3538129","GSM3538130","GSM3538131","GSM3538132","GSM3538133","GSM3538134","GSM3538135","GSM3538136","GSM3538137","GSM3538138","GSM3538139","GSM4193226","GSM4193227","GSM4477968","GSM4477969","GSM4477970","GSM4477971","GSM4477972","GSM4477973","GSM4477974","GSM4477975","GSM4477976","GSM4477977","GSM4477978","GSM4477979","GSM4477980","GSM4477981","GSM4477982","GSM4477983","GSM5022922",
"GSM5022923","GSM3716410","GSM3716411","GSM4285921","GSM4285922","GSM4285924","GSM4285925","GSM4285926","GSM4654571","GSM4654572","GSM4654573","GSM4654575","GSM4654577","GSM4654578","GSM4654579","GSM4654580","GSM4654581","GSM4654582","GSM4654584","GSM4654585","GSM4654587","GSM4654588","GSM4654589","GSM4654590","GSM4654591","GSM4990857","GSM4990858","GSM5050954","GSM5050955","GSM5050956",
"GSM5050957","GSM5050958","GSM5050959","GSM5050960","GSM5050961","GSM5050962","GSM5050963","GSM5050964","GSM5050965","GSM5258166","GSM5258167","GSM5258168","GSM5258169","GSM5258170","GSM5281771","GSM5281774","GSM5281775","GSM5281776","GSM5281779","GSM5281780","GSM5342781","GSM5342782","GSM5342783","GSM5342784","GSM5342785","GSM5342786","GSM5465816","GSM5481676","GSM5481677","GSM5481678",
"GSM5481679","GSM5481680","")

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

