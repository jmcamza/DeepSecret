# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Myoblast_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1269281","GSM2068360","GSM1269305","GSM1269331","GSM2068367","GSM1269283","GSM1269289","GSM1531419","GSM1269298","GSM1269286","GSM1726428","GSM1269312","GSM2068361","GSM2068368","GSM1269295","GSM1269253","GSM1269310","GSM1269282","GSM1269252","GSM2068369","GSM1269280","GSM1269272","GSM1269267","GSM1269296","GSM1269309","GSM1269262","GSM1269261","GSM1726427","GSM1269269","GSM1269325","GSM1269302",
"GSM1269290","GSM1269266","GSM1269256","GSM1269285","GSM1269316","GSM1269263","GSM1269255","GSM1269311","GSM1269303","GSM1269330","GSM1531421","GSM1269314","GSM1269254","GSM1269288","GSM1269292","GSM1269257","GSM1269299","GSM1269259","GSM1269284","GSM1269313","GSM1269306","GSM1269323","GSM1726433","GSM1269287","GSM1269250","GSM1269307","GSM1269264","GSM1269328","GSM1269317","GSM1269268",
"GSM1269320","GSM1269318","GSM1269321","GSM1269248","GSM1269278","GSM1269327","GSM1269251","GSM1531422","GSM1269260","GSM1269275","GSM1269273","GSM1269301","GSM1269304","GSM1269277","GSM1269329","GSM1269291","GSM1269319","GSM1269322","GSM1531420","GSM2068359","GSM1269276","GSM1269308","GSM1269274","GSM1726431","GSM1269324","GSM1269079","GSM1269002","GSM1269021","GSM1269234","GSM1269242",
"GSM1269145","GSM1269127","GSM1269092","GSM1269084","GSM1269019","GSM1269100","GSM1269186","GSM1269031","GSM1269097","GSM1269140","GSM1269093","GSM1269052","GSM1269078","GSM1269015","GSM1269133","GSM1269155","GSM1269178","GSM1269003","GSM1268960","GSM1269024","GSM1268972","GSM1269243","GSM1268961","GSM1269137","GSM1269110","GSM1269120","GSM1269184","GSM1269032","GSM1269175","GSM1268970",
"GSM1269096","GSM1269246","GSM1269232","GSM1412728","GSM1269231","GSM1269228","GSM1268973","GSM1269129","GSM1269154","GSM1268995","GSM1268991","GSM1269070","GSM1269025","GSM1269171","GSM1269135","GSM1268962","GSM1269016","GSM1269132","GSM1269063","GSM1269230","GSM1269157","GSM1269223","GSM1269194","GSM1269081","GSM1269118","GSM1269094","GSM1269072","GSM1269247","GSM1269160","GSM1269014",
"GSM1269111","GSM1269167","GSM1268976","GSM1269087","GSM1269212","GSM1269088","GSM1268988","GSM1269187","GSM1269033","GSM1269104","GSM1269216","GSM1269161","GSM1269115","GSM1269151","GSM1269192","GSM1269057","GSM1269085","GSM1269055","GSM1269209","GSM1269030","GSM1269190","GSM1269058","GSM1269139","GSM1268969","GSM1269039","GSM1269173","GSM1269146","GSM1269162","GSM1269197","GSM1269122",
"GSM1269108","GSM1269235","GSM1269035","GSM1269221","GSM1269038","GSM1269201","GSM1269191","GSM1269182","GSM1269099","GSM1269073","GSM1269125","GSM1269130","GSM1269233","GSM1269013","GSM1269043","GSM1269026","GSM1268986","GSM1269218","GSM1412732","GSM1412730","GSM1269023","GSM1269068","GSM1269207","GSM1269131","GSM1269215","GSM1268994","GSM1268998","GSM1269214","GSM1412725","GSM1269105",
"GSM1269220","GSM1269069","GSM1269226","GSM1269101","GSM1269106","GSM1269059","GSM1269200","GSM1269203","GSM1269001","GSM1269244","GSM1269198","GSM1269076","GSM1269159","GSM1269168","GSM1269042","GSM1269050","GSM1268965","GSM1269107","GSM1269011","GSM1269153","GSM1269158","GSM1269061","GSM1269006","GSM1268983","GSM1268967","GSM1269204","GSM1269227","GSM1269012","GSM1269185","GSM1268966",
"GSM1269047","GSM1268990","GSM1269245","GSM1268979","GSM1269183","GSM1269225","GSM1412723","GSM1269008","GSM1269189","GSM1268971","GSM1269211","GSM1269238","GSM1269210","GSM1269065","GSM1269010","GSM1269074","GSM1269082","GSM1268968","GSM1269174","GSM1269170","GSM1269091","GSM1269007","GSM1269112","GSM1268978","GSM1269126","GSM1269219","GSM1268985","GSM1269166","GSM1269224","GSM1269181",
"GSM1269199","GSM1269156","GSM1268974","GSM1269134","GSM1269086","GSM1269237","GSM1269165","GSM1269236","GSM1269142","GSM1269222","GSM1269163","GSM1269062","GSM1269067","GSM1269056","GSM1269102","GSM1269119","GSM1269064","GSM1269188","GSM1269195","GSM1269004","GSM1269205","GSM1269123","GSM1269095","GSM1269213","GSM1269193","GSM1269071","GSM1269144","GSM1269208","GSM1269060","GSM1269048",
"GSM1412734","GSM1269000","GSM1269128","GSM1269152","GSM1269049","GSM1269034","GSM1268964","GSM1269040","GSM1269164","GSM1269045","GSM1268996","GSM1269075","GSM1269036","GSM1269009","GSM1269114","GSM1269124","GSM1269098","GSM1269054","GSM1268980","GSM1269196","GSM1269229","GSM1268997","GSM1268963","GSM1269022","GSM1269117","GSM1268977","GSM1269141","GSM1269180","GSM1269202","GSM1268989",
"GSM1269046","GSM1269177","GSM1269176","GSM1269240","GSM1269077","GSM1269169","GSM1269020","GSM1269172","GSM1269066","GSM1269017","GSM1269116","GSM1269241","GSM1269090","GSM1269028","GSM1269027","GSM1269089","GSM1269018","GSM1269239","GSM1269179","GSM1269206","GSM1269044","GSM1269138","GSM1268992","GSM1268984","GSM1269148","GSM1269080","GSM1269051","GSM1269279","GSM1269265","GSM1269258",
"GSM2449406","GSM2449407","GSM2449408","GSM2449405","GSM2072544","GSM2072543","GSM2072593","GSM2338122","GSM2338123","GSM2746670","GSM2746671","GSM2746672","GSM2746673","GSM2746674","GSM2746675","GSM2746676","GSM2746677","GSM2746678","GSM2746679","GSM2746680","GSM2746681","GSM2746682","GSM2746683","GSM2746684","GSM2746685","GSM2746686","GSM2746687","GSM2746688","GSM2746689","GSM2746690",
"GSM2746691","GSM2746692","GSM2746693","GSM2746694","GSM2746695","GSM2746696","GSM2384965","GSM2384966","GSM2384967","GSM2384968","GSM2384969","GSM2384970","GSM2384971","GSM2384972","GSM2384973","GSM2108328","GSM2108329","GSM2108330","GSM2108331","GSM2108332","GSM2108333","GSM2108334","GSM2108335","GSM2108336","GSM2108337","GSM2108338","GSM2108339","GSM2108340","GSM2108341","GSM2108342",
"GSM2108343","GSM2108344","GSM2108345","GSM2108346","GSM2108347","GSM2108348","GSM2108349","GSM2108350","GSM2108351","GSM2108352","GSM2108353","GSM2108354","GSM2108355","GSM2108356","GSM2108357","GSM2108358","GSM2108359","GSM2108360","GSM2108361","GSM2108362","GSM2108363","GSM2108364","GSM2108365","GSM2108366","GSM2108367","GSM2108368","GSM2108369","GSM2108370","GSM2108371","GSM2108372",
"GSM2108373","GSM2108374","GSM2108375","GSM2108376","GSM2108377","GSM2108378","GSM2108379","GSM2108380","GSM2108381","GSM2108382","GSM2108383","GSM2108384","GSM2108385","GSM2108386","GSM2108387","GSM2108388","GSM2108389","GSM2108390","GSM2108391","GSM2108392","GSM2108393","GSM2108394","GSM2108395","GSM2108396","GSM2108397","GSM2108398","GSM2108399","GSM2108400","GSM2108401","GSM2108402",
"GSM2108403","GSM2108405","GSM2108406","GSM2108408","GSM2108409","GSM2108410","GSM2108411","GSM2108412","GSM2108413","GSM2108414","GSM2108415","GSM2108416","GSM2108417","GSM2108418","GSM2108419","GSM2108420","GSM2108421","GSM2108422","GSM2108423","GSM2108424","GSM2108425","GSM2108426","GSM2108427","GSM2108428","GSM2108429","GSM2108430","GSM2108431","GSM2108432","GSM2108433","GSM2108434",
"GSM2108435","GSM2108436","GSM2108437","GSM2108439","GSM2108440","GSM2108441","GSM2108442","GSM2108443","GSM2108444","GSM2108445","GSM2108446","GSM2108447","GSM2108448","GSM2108449","GSM2108450","GSM2108451","GSM2108452","GSM2108453","GSM2108455","GSM2108456","GSM2108457","GSM2108458","GSM2108460","GSM2108461","GSM2108462","GSM2108464","GSM2108465","GSM2108466","GSM2108467","GSM2108469",
"GSM2108470","GSM2108471","GSM2108473","GSM2108474","GSM2108475","GSM2108476","GSM2108477","GSM2108478","GSM2108479","GSM2108481","GSM2108482","GSM2108483","GSM2108484","GSM2108485","GSM2108486","GSM2108487","GSM2108488","GSM2108489","GSM2108490","GSM2108491","GSM2108492","GSM2108493","GSM2108494","GSM2108495","GSM2108496","GSM2108497","GSM2108498","GSM2108499","GSM2108500","GSM2108501",
"GSM2108502","GSM2108503","GSM2108504","GSM2108505","GSM2108506","GSM2108507","GSM2108510","GSM2108511","GSM2108514","GSM2108517","GSM2108518","GSM2108521","GSM2108522","GSM2108523","GSM2108524","GSM2108525","GSM2108526","GSM2108527","GSM2108528","GSM2108529","GSM2108530","GSM2108531","GSM2108533","GSM2108534","GSM2108535","GSM2108536","GSM2108537","GSM2108538","GSM2108542","GSM2108543",
"GSM2108544","GSM2108545","GSM2108546","GSM2108548","GSM2108549","GSM2108550","GSM2108551","GSM2108552","GSM2108553","GSM2108554","GSM2108555","GSM2108556","GSM2108557","GSM2108558","GSM2108559","GSM2108561","GSM2108563","GSM2108564","GSM2108565","GSM2108566","GSM2108567","GSM2108568","GSM2108569","GSM2108570","GSM2108571","GSM2108573","GSM2108574","GSM2108575","GSM2108576","GSM2108577",
"GSM2108578","GSM2108579","GSM2108580","GSM2108581","GSM2787547","GSM2787548","GSM2787549","GSM2787550","GSM2787551","GSM2787552","GSM2787553","GSM2787554","GSM2787555","GSM2787556","GSM2288028","GSM2288029","GSM2288030","GSM2288031","GSM2288032","GSM2288033","GSM2288034","GSM2288035","GSM2288036","GSM2696922","GSM2696923","GSM2696924","GSM2696925","GSM2696926","GSM2267338","GSM2267339",
"GSM2267340","GSM2267341","GSM2267342","GSM2267343","GSM2267344","GSM2267345","GSM3416638","GSM3416639","GSM3416640","GSM3416641","GSM3416642","GSM3416643","GSM3416644","GSM3416645","GSM3416646","GSM3416647","GSM3416648","GSM3416649","GSM3305104","GSM3305105","GSM3305106","GSM3305107","GSM3504538","GSM3504539","GSM3504540","GSM3504541","GSM3504542","GSM3504543","GSM3504544","GSM3504545",
"GSM3504546","GSM3504547","GSM3504548","GSM3504550","GSM3504551","GSM3504552","GSM3504553","GSM3504554","GSM3504555","GSM3504556","GSM3504557","GSM3504558","GSM3504559","GSM3504560","GSM3504561","GSM3504562","GSM3504563","GSM3504564","GSM3504565","GSM3504566","GSM3504567","GSM3504568","GSM3504569","GSM3504570","GSM3504571","GSM3504572","GSM3504573","GSM3504574","GSM3504575","GSM3504576",
"GSM3504577","GSM3504578","GSM3504579","GSM3504580","GSM3504581","GSM3504582","GSM3504583","GSM3504584","GSM3504585","GSM3504586","GSM3504587","GSM3504588","GSM3504589","GSM3504590","GSM3504591","GSM3504592","GSM3504593","GSM3504594","GSM3504595","GSM3504596","GSM3504597","GSM3504598","GSM3504599","GSM3504600","GSM3057733","GSM3057735","GSM3057738","GSM3057741","GSM3633687","GSM3633688",
"GSM3633689","GSM3633690","GSM3633691","GSM3633692","GSM3633693","GSM3633694","GSM3272348","GSM3272349","GSM3272361","GSM3272362","GSM3293620","GSM3293621","GSM3293622","GSM3293623","GSM3293624","GSM3293625","GSM3293626","GSM3293627","GSM3293628","GSM3293629","GSM3293630","GSM3293631","GSM3293632","GSM3156526","GSM3156527","GSM3156528","GSM3156529","GSM3374176","GSM3374177","GSM3374178",
"GSM3374179","GSM3374180","GSM3374181","GSM3374182","GSM3374183","GSM3374184","GSM3374185","GSM3374186","GSM3374187","GSM3374188","GSM3374189","GSM3374190","GSM3741747","GSM3741748","GSM3741749","GSM3741750","GSM3741751","GSM3741752","GSM3741753","GSM3741754","GSM3741755","GSM3520098","GSM3520099","GSM3520100","GSM3520101","GSM4259678","GSM4259679","GSM4259680","GSM4259681","GSM4259682",
"GSM4259683","GSM4259684","GSM4259685","GSM4259686","GSM4259687","GSM4259688","GSM4259689","GSM4259690","GSM4259691","GSM4259692","GSM4259693","GSM4259694","GSM4259695","GSM4259696","GSM4259697","GSM4259698","GSM4259699","GSM4259700","GSM4259701","GSM4259702","GSM4259703","GSM4259704","GSM4259705","GSM4259706","GSM4259707","GSM4259708","GSM4259709","GSM4259710","GSM4259711","GSM4259712",
"GSM4259713","GSM4259714","GSM4259715","GSM4259716","GSM4259717","GSM4259718","GSM4259719","GSM4259720","GSM4259721","GSM4259722","GSM4259723","GSM4259724","GSM4259725","GSM4259726","GSM4259727","GSM4259728","GSM4259729","GSM4259730","GSM4259731","GSM4259732","GSM4259733","GSM4259734","GSM4259735","GSM4259736","GSM4259737","GSM4259738","GSM4259739","GSM4259740","GSM4259741","GSM4259742",
"GSM4259743","GSM4259744","GSM4259745","GSM4259746","GSM4259747","GSM4259748","GSM4259749","GSM4259750","GSM4259751","GSM4259752","GSM4259753","GSM4259754","GSM4259755","GSM4259756","GSM4259757","GSM4260435","GSM4260436","GSM4260437","GSM4260438","GSM4260439","GSM4260440","GSM4260441","GSM4260442","GSM4260443","GSM4260444","GSM4260445","GSM4260446","GSM4260447","GSM4260448","GSM4260449",
"GSM4260450","GSM4260451","GSM4260452","GSM4260453","GSM4260454","GSM4260455","GSM4260456","GSM4260457","GSM4260458","GSM4260459","GSM4260460","GSM4260461","GSM4260462","GSM4260463","GSM4260464","GSM4260465","GSM4260466","GSM4260467","GSM4260468","GSM4260469","GSM4260470","GSM4260471","GSM4260472","GSM4260473","GSM4260474","GSM4260475","GSM4260476","GSM4260477","GSM4260478","GSM4260479",
"GSM4260480","GSM4260481","GSM4260482","GSM4260483","GSM4260484","GSM4260485","GSM4260486","GSM4260487","GSM4260488","GSM4260489","GSM4260490","GSM4260491","GSM4260492","GSM4260493","GSM4260494","GSM4260495","GSM4260496","GSM4260497","GSM4260498","GSM4260499","GSM4260500","GSM4260501","GSM4260502","GSM4260503","GSM4260504","GSM4260505","GSM4260506","GSM4260507","GSM4260508","GSM4260509",
"GSM4260510","GSM4260511","GSM4260512","GSM4260513","GSM4260514","GSM4260515","GSM4260516","GSM4260517","GSM4260518","GSM4260519","GSM4260520","GSM4260521","GSM4260522","GSM4260523","GSM4260524","GSM4260525","GSM4260526","GSM4260527","GSM4260528","GSM4260529","GSM4260530","GSM4260531","GSM4260532","GSM4260533","GSM4260534","GSM4260535","GSM4260536","GSM4646469","GSM4646471","GSM4646473",
"GSM4646475","GSM4646477","GSM4646479","GSM4795431","GSM4795432","GSM4795433","GSM4795434","GSM4795435","GSM4795436","GSM4795437","GSM4795438","GSM4795439","GSM3687128","GSM3687129","GSM3687130","GSM3687131","GSM3687132","GSM3687133","GSM3687134","GSM3687135","GSM3687136","GSM3687137","GSM3687138","GSM3687139","GSM4058394","GSM4058396","GSM4058397","GSM4058399","GSM4058400","GSM4058401",
"GSM4117691","GSM4117693","GSM4975184","GSM4975185","GSM4975188","GSM4975189","GSM5264846","GSM5264847","GSM5264849","GSM5397153","GSM5397154","GSM5397155","GSM5397156","GSM5397157","GSM5397158","GSM5397159","GSM5397160","GSM5397161","GSM5397162","GSM5397163","GSM5397164","")

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
