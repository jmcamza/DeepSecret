# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Alveolar_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1563135","GSM1586130","GSM1586131","GSM1876247","GSM1876246","GSM1706463","GSM1706458","GSM1706461","GSM1706470","GSM1706471","GSM1706460","GSM1706468","GSM1706467","GSM1706469","GSM1706459","GSM1706464","GSM1706465","GSM1706473","GSM1706466","GSM1706472","GSM1706462","GSM1370363","GSM1876245","GSM2267530","GSM2267531","GSM2267532","GSM2267533","GSM2267534","GSM2267535","GSM2717392","GSM2717393",
"GSM2717394","GSM2717395","GSM2717396","GSM2717397","GSM2431608","GSM2431609","GSM2431610","GSM2431611","GSM2431612","GSM2431613","GSM2431614","GSM2431615","GSM2431616","GSM2431617","GSM2431618","GSM2431619","GSM2431620","GSM2431621","GSM2431622","GSM2431623","GSM2431624","GSM2431625","GSM2431626","GSM2431627","GSM2431628","GSM2431629","GSM2431630","GSM2431631","GSM2431632","GSM2431633",
"GSM2431634","GSM2431635","GSM2431636","GSM2431637","GSM2431638","GSM2431639","GSM2431640","GSM2431641","GSM2431642","GSM2431643","GSM2431644","GSM2431645","GSM2431646","GSM2431647","GSM2431648","GSM2431649","GSM2431650","GSM2431651","GSM2431652","GSM2431653","GSM2431654","GSM2431655","GSM2431656","GSM2431657","GSM2431658","GSM2431659","GSM2431660","GSM2431661","GSM2431662","GSM2431663",
"GSM2431664","GSM2431665","GSM2431666","GSM2431667","GSM2431668","GSM2431669","GSM2431670","GSM2431671","GSM2431672","GSM2431673","GSM2431674","GSM2431675","GSM2431676","GSM2431677","GSM2431678","GSM2431679","GSM2431680","GSM2431681","GSM2431682","GSM2431683","GSM2431684","GSM2431685","GSM2431686","GSM2431687","GSM2431688","GSM2431689","GSM2431690","GSM2097611","GSM2097612","GSM2097613",
"GSM2097614","GSM2097615","GSM2097616","GSM2097617","GSM2097618","GSM2097619","GSM2097620","GSM2097621","GSM2608026","GSM2608027","GSM2608028","GSM2608029","GSM2608030","GSM2608031","GSM2608032","GSM2608033","GSM2608034","GSM2608035","GSM2608036","GSM2608037","GSM2894834","GSM3098012","GSM3098013","GSM3098014","GSM3098015","GSM3098016","GSM3098017","GSM3098018","GSM3098019","GSM3098020",
"GSM3098021","GSM3098022","GSM3098023","GSM3098024","GSM3098025","GSM3098026","GSM3098027","GSM3098028","GSM3098029","GSM3098030","GSM3098031","GSM3098032","GSM3098033","GSM3098034","GSM3098035","GSM3098036","GSM3098037","GSM3098038","GSM3098039","GSM3098040","GSM3098041","GSM3098042","GSM3098043","GSM3098044","GSM3098045","GSM3098046","GSM3098047","GSM3098048","GSM3098049","GSM3098050",
"GSM3098051","GSM3098052","GSM3098053","GSM3098054","GSM3098055","GSM3098056","GSM3098057","GSM3098058","GSM3098059","GSM3449203","GSM3449204","GSM3449205","GSM3449206","GSM3449207","GSM3449208","GSM3449209","GSM3449210","GSM2740395","GSM2740396","GSM2740397","GSM2740398","GSM2740399","GSM2740400","GSM3305112","GSM3305113","GSM3305114","GSM3305115","GSM3539242","GSM3539243","GSM3539244",
"GSM3539245","GSM3539246","GSM3539247","GSM3539248","GSM3539249","GSM3539250","GSM3539251","GSM3347404","GSM3347405","GSM3347396","GSM2232905","GSM2257989","GSM2257990","GSM2257991","GSM2257992","GSM2257994","GSM2257995","GSM2257996","GSM2257997","GSM2257998","GSM2257999","GSM2258000","GSM2258001","GSM2258002","GSM2258004","GSM2258005","GSM2258006","GSM2258007","GSM2258008","GSM4138191",
"GSM4138192","GSM4138193","GSM4138194","GSM4138195","GSM4138196","GSM4138197","GSM4138205","GSM4138206","GSM4138207","GSM4138208","GSM4138209","GSM4138210","GSM4138211","GSM4153673","GSM4153674","GSM4153675","GSM4153676","GSM4153677","GSM4153678","GSM4153679","GSM4153680","GSM4153682","GSM4153683","GSM4153684","GSM4286769","GSM4637294","GSM4637295","GSM4637296","GSM4637297","GSM4637298",
"GSM4637299","GSM4637300","GSM4637301","GSM4637302","GSM2257993","GSM2258003","GSM4153681","GSM4635981","GSM4923494","GSM4052323","GSM4052324","GSM4052325","GSM4052327","GSM4052328","GSM4052332","GSM4052333","GSM4052336","GSM4052337","GSM4052340","GSM4052341","GSM4052342","GSM4052344","GSM4052345","GSM4052347","GSM4052348","GSM4052349","GSM4052350","GSM4052351","GSM4052352","GSM4052353",
"GSM4052354","GSM4052355","GSM4052357","GSM4052358","GSM4052359","GSM4052360","GSM4052361","GSM4117476","GSM4117478","GSM4117479","GSM4117481","GSM4117661","GSM4117662","GSM4117663","GSM4291098","GSM4291099","GSM4291102","GSM4291103","GSM4291106","GSM4291107","GSM4291109","GSM4291110","GSM4291111","GSM4914637","GSM4914638","GSM4914639","GSM4914640","GSM4914641","GSM4914642","GSM4914643",
"GSM4914644","GSM4914645","GSM4914646","GSM4914647","GSM5048553","GSM5048555","GSM5048556","GSM5048557","GSM5048558","GSM5048559","GSM5048560","GSM5048561","GSM5048562","GSM5048563","GSM5048564","GSM5048565","GSM5048566","GSM5048567","GSM5048568","GSM5048569","GSM5048570","GSM5048571","GSM5048572","GSM5048573","GSM5048574","GSM5048575","GSM5048576","GSM5048577","GSM5048578","GSM5048579",
"GSM5048582","GSM5048583","GSM5048584","GSM5048585","GSM5048586","GSM5048588","GSM5048589","GSM5048590","GSM5048591","GSM5048592","GSM5048593","GSM5048594","GSM5048595","GSM5048598","GSM5048599","GSM5048600","GSM5048602","GSM5048603","GSM5048604","GSM5048605","GSM5048606","GSM5048608","GSM5048609","GSM5048610","GSM5048612","GSM5048613","GSM5048614","GSM5048617","GSM5048618","GSM5048619",
"GSM5048620","GSM5048621","GSM5048622","GSM5048623","GSM5048624","GSM5048625","GSM5048627","GSM5048628","GSM5048629","GSM5048630","GSM5048631","GSM5048632","GSM5048633","GSM5048634","GSM5048635","GSM5048636","GSM5048637","GSM5048640","GSM5048641","GSM5048642","GSM5048643","GSM5048644","GSM5048645","GSM5048646","GSM5048647","GSM5048648","GSM5048649","GSM5048650","GSM5048651","GSM5060505",
"GSM5060506","GSM5060507","GSM5060508","GSM5060509","GSM5060510","GSM5060511","GSM5060512","GSM5060534","GSM5060535","GSM5060536","GSM5060546","GSM5060547","GSM5224805","GSM5224808","GSM5224810","")

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
