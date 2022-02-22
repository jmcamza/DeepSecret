# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "MDAMB231_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1193921","GSM1193928","GSM1202561","GSM1069747","GSM1193923","GSM1202564","GSM1193924","GSM1202566","GSM1193926","GSM1193922","GSM1193925","GSM929912","GSM1202562","GSM1193927","GSM1202563","GSM1202557","GSM1202556","GSM1202559","GSM1202554","GSM1202560","GSM1202555","GSM1202565","GSM1069748","GSM1202568","GSM1202553","GSM929913","GSM1202567","GSM1202558","GSM1904537","GSM1553461","GSM1666283",
"GSM1666286","GSM1435248","GSM2026522","GSM2048448","GSM1897366","GSM1399413","GSM1856022","GSM1897368","GSM1631313","GSM1631326","GSM2048445","GSM2048449","GSM1716865","GSM1904536","GSM1716866","GSM1856021","GSM1856025","GSM1716868","GSM1856023","GSM1943697","GSM1631327","GSM1943687","GSM1553464","GSM2048438","GSM2048444","GSM1631312","GSM1435251","GSM2048446","GSM2026524","GSM1666284",
"GSM1399412","GSM2048437","GSM2048440","GSM1553462","GSM1716869","GSM2048442","GSM1399414","GSM1435246","GSM1897365","GSM2048452","GSM2048443","GSM1399411","GSM1943696","GSM2026527","GSM1897364","GSM2048441","GSM1666282","GSM1435247","GSM1897363","GSM1435250","GSM2048433","GSM1904535","GSM1631315","GSM2026523","GSM2048439","GSM2048447","GSM1553463","GSM1856024","GSM1666287","GSM2026526",
"GSM1666285","GSM2048451","GSM1716867","GSM2026525","GSM2048434","GSM1864032","GSM1864035","GSM1864039","GSM1864036","GSM1864034","GSM1864037","GSM1864033","GSM1864038","GSM1399410","GSM1435249","GSM1546360","GSM1546358","GSM1546359","GSM1631314","GSM1716864","GSM1856020","GSM1897367","GSM1943695","GSM2048450","GSM2051450","GSM2051451","GSM2051449","GSM2051448","GSM2242131","GSM2242132",
"GSM2045596","GSM2045597","GSM1412525","GSM1412523","GSM1412521","GSM1412526","GSM1412524","GSM1412522","GSM2194106","GSM2194113","GSM2194109","GSM2194107","GSM2194112","GSM2194111","GSM2194110","GSM2194115","GSM2194108","GSM2194114","GSM2252626","GSM2284968","GSM2252627","GSM2252625","GSM2252624","GSM2284967","GSM2278029","GSM2278024","GSM2278026","GSM2278025","GSM2278028","GSM2278027",
"GSM2509538","GSM2509540","GSM2509539","GSM2509535","GSM2509536","GSM2509542","GSM2509541","GSM2509537","GSM2536971","GSM2536972","GSM2536973","GSM2536974","GSM2536975","GSM2536976","GSM2545265","GSM2545266","GSM2545267","GSM2545268","GSM2680456","GSM2680457","GSM2680458","GSM2680459","GSM2680460","GSM2680461","GSM2913913","GSM2913914","GSM2913915","GSM2913916","GSM2691347","GSM2691348",
"GSM1939621","GSM1939622","GSM1939623","GSM1939624","GSM1939625","GSM1939626","GSM1939627","GSM1939628","GSM1939629","GSM1939630","GSM1939631","GSM1939632","GSM2064544","GSM2064545","GSM2064546","GSM2064547","GSM2309404","GSM2309405","GSM2309406","GSM2309407","GSM2309408","GSM2309409","GSM2309410","GSM2309411","GSM2309412","GSM2309413","GSM2422575","GSM2422576","GSM2422577","GSM2422578",
"GSM2422579","GSM2422580","GSM2422581","GSM2422582","GSM2422583","GSM2422584","GSM2422585","GSM2422586","GSM2422631","GSM2422632","GSM2422633","GSM2422634","GSM2422635","GSM2422636","GSM2422637","GSM2422638","GSM2422639","GSM2422640","GSM2422641","GSM2422642","GSM2422643","GSM2422645","GSM2422646","GSM2422647","GSM2422652","GSM2422654","GSM2422658","GSM2422659","GSM2422660","GSM2422661",
"GSM2422662","GSM2422663","GSM2422664","GSM2422665","GSM2422666","GSM2422667","GSM2422668","GSM2422669","GSM2422713","GSM2422714","GSM2422715","GSM2422716","GSM2422717","GSM2422718","GSM2422719","GSM2422720","GSM2422721","GSM2422722","GSM2422723","GSM2422724","GSM2422731","GSM2422732","GSM2422733","GSM2422734","GSM2422735","GSM2422736","GSM2645630","GSM2645631","GSM2645632","GSM2645633",
"GSM2645634","GSM2645635","GSM2645636","GSM2645637","GSM2645638","GSM2645639","GSM2645640","GSM2645641","GSM2645642","GSM2645643","GSM2645644","GSM2645645","GSM2827171","GSM2827174","GSM2827175","GSM2827176","GSM2827177","GSM2827178","GSM2827179","GSM2827180","GSM2827181","GSM2844116","GSM2844117","GSM2844118","GSM2844119","GSM2844120","GSM2844121","GSM2844122","GSM2844123","GSM2844124",
"GSM2844125","GSM2844126","GSM2844127","GSM2572604","GSM2572605","GSM2572606","GSM2572607","GSM2572608","GSM2572609","GSM3071987","GSM3071988","GSM3071989","GSM3071990","GSM2684901","GSM2684902","GSM2684905","GSM2684906","GSM2684908","GSM2684912","GSM2862188","GSM2862189","GSM2862190","GSM2862191","GSM3373920","GSM3373921","GSM3373922","GSM3373923","GSM3373924","GSM3373925","GSM3384496",
"GSM3384497","GSM3384498","GSM3384499","GSM3384500","GSM3384501","GSM2736169","GSM2736170","GSM2736171","GSM2736172","GSM2736173","GSM2736174","GSM2736175","GSM2736176","GSM2736177","GSM2736178","GSM2736179","GSM2736180","GSM2736181","GSM2736182","GSM2736183","GSM2736184","GSM2736185","GSM2736186","GSM2736187","GSM2736188","GSM2736189","GSM3425916","GSM3425917","GSM3425918","GSM3425919",
"GSM3425920","GSM3425921","GSM3531639","GSM3531640","GSM3609630","GSM3609631","GSM3609632","GSM3070232","GSM3070233","GSM3070234","GSM3070235","GSM3070236","GSM3070237","GSM3070238","GSM3070239","GSM3070240","GSM3070241","GSM3070242","GSM3070243","GSM3070244","GSM3070245","GSM3070246","GSM3461347","GSM3461348","GSM3461349","GSM3461350","GSM3461351","GSM3461352","GSM3461353","GSM3461354",
"GSM3461355","GSM3489082","GSM3489083","GSM3489084","GSM3489085","GSM3168387","GSM2144039","GSM2144040","GSM2144041","GSM2144042","GSM2585548","GSM2585549","GSM2585550","GSM2585551","GSM2585552","GSM2585553","GSM2585554","GSM2585555","GSM2913943","GSM2913944","GSM2913945","GSM2913946","GSM2913947","GSM2913948","GSM2913949","GSM2913950","GSM2913951","GSM2913952","GSM2913953","GSM2913954",
"GSM3704351","GSM3704352","GSM3704353","GSM3704354","GSM3704355","GSM3704356","GSM3738657","GSM3738658","GSM3738659","GSM3738660","GSM3738661","GSM3738662","GSM3746015","GSM3746016","GSM3746017","GSM3746018","GSM3746019","GSM3746020","GSM3746021","GSM3746022","GSM3746023","GSM3746024","GSM3711753","GSM3711754","GSM3711755","GSM3711756","GSM3728402","GSM3728403","GSM3728404","GSM3728405",
"GSM3728406","GSM3728407","GSM3728408","GSM3728409","GSM3397280","GSM3397281","GSM3397282","GSM3397283","GSM3743619","GSM3743620","GSM3743621","GSM3743622","GSM4047566","GSM4047567","GSM4047568","GSM4047569","GSM3263572","GSM3263573","GSM3263574","GSM3263575","GSM3521304","GSM3521305","GSM3521306","GSM3521307","GSM3521308","GSM3521309","GSM3530750","GSM3530751","GSM4048679","GSM4048680",
"GSM4048681","GSM4048682","GSM4048683","GSM4048684","GSM4048685","GSM4048686","GSM4048687","GSM3727948","GSM3727949","GSM3727950","GSM3727951","GSM3727952","GSM3727953","GSM3727954","GSM3727955","GSM3727956","GSM3727957","GSM3727958","GSM3727959","GSM3727960","GSM3727961","GSM3727962","GSM4078695","GSM4078696","GSM4078697","GSM4078698","GSM4078699","GSM4078700","GSM4078701","GSM4078702",
"GSM4078703","GSM4078704","GSM4078705","GSM4078706","GSM4078707","GSM4078708","GSM4078709","GSM4078710","GSM4078711","GSM4078712","GSM3860393","GSM3860394","GSM3860395","GSM3860396","GSM3860397","GSM3860398","GSM3611064","GSM3427397","GSM3427398","GSM3427399","GSM3427400","GSM3427401","GSM3427402","GSM3463796","GSM3463797","GSM3463798","GSM3633016","GSM3633017","GSM3633018","GSM3633019",
"GSM3633020","GSM3633021","GSM3633022","GSM3633023","GSM3633024","GSM3633025","GSM3633026","GSM3633027","GSM3667691","GSM3667692","GSM3667693","GSM3667694","GSM3667695","GSM3667696","GSM3684256","GSM3684257","GSM3684258","GSM3684259","GSM3684260","GSM3684261","GSM3703784","GSM3703785","GSM3703786","GSM3703787","GSM3855654","GSM3855655","GSM3855656","GSM3855657","GSM3855658","GSM3855659",
"GSM3946056","GSM3946057","GSM3946058","GSM3946059","GSM3946060","GSM3946061","GSM3946062","GSM3946063","GSM3946064","GSM3946065","GSM3946066","GSM3946067","GSM3954684","GSM3954685","GSM3954686","GSM3954687","GSM3954688","GSM3954689","GSM3954690","GSM3954691","GSM4048800","GSM4048801","GSM4048802","GSM4100702","GSM4100703","GSM4100704","GSM4100705","GSM4100706","GSM4100707","GSM4100708",
"GSM4100709","GSM4100710","GSM4182605","GSM4182606","GSM4182607","GSM4182608","GSM4285004","GSM4285005","GSM4285006","GSM4285007","GSM4285008","GSM4285009","GSM4322277","GSM4322278","GSM4322279","GSM4322280","GSM4322282","GSM4395536","GSM4395537","GSM4395538","GSM4395539","GSM4395540","GSM4395541","GSM4395542","GSM4395543","GSM4395544","GSM4395545","GSM4395546","GSM4395547","GSM4471578",
"GSM4471579","GSM4471580","GSM4471581","GSM4471582","GSM4471583","GSM4471584","GSM4471585","GSM4471586","GSM4471587","GSM4471588","GSM4471589","GSM4546851","GSM4546852","GSM4546853","GSM4546854","GSM4546855","GSM4546856","GSM4576702","GSM4576703","GSM4576704","GSM4576705","GSM4576706","GSM4576707","GSM4576708","GSM4576709","GSM4576711","GSM4576712","GSM4576713","GSM4576714","GSM4576715",
"GSM4576716","GSM4576717","GSM4576718","GSM4576719","GSM4576720","GSM4576721","GSM4576722","GSM4576723","GSM4576724","GSM4576725","GSM4576726","GSM4576727","GSM4576728","GSM4576729","GSM4576730","GSM4576731","GSM4576732","GSM4576733","GSM4576734","GSM4576735","GSM4576737","GSM4576738","GSM4576739","GSM4576740","GSM4576741","GSM4576742","GSM4576743","GSM4576744","GSM4576745","GSM4576746",
"GSM4576747","GSM4576748","GSM4576749","GSM4576750","GSM4576751","GSM4576752","GSM4576753","GSM4576754","GSM4576755","GSM4576756","GSM4576757","GSM4576758","GSM4576759","GSM4576760","GSM4576761","GSM4576762","GSM4576763","GSM4576764","GSM4576765","GSM4576766","GSM4576767","GSM4576768","GSM4576769","GSM4576770","GSM4576771","GSM4576772","GSM4576773","GSM4576774","GSM4576775","GSM4576776",
"GSM4576777","GSM4576778","GSM4576779","GSM4576780","GSM4576781","GSM4576782","GSM4576783","GSM4576784","GSM4576785","GSM4576786","GSM4576787","GSM4576788","GSM4576789","GSM4576790","GSM4576791","GSM4576792","GSM4576793","GSM4576794","GSM4576795","GSM4585066","GSM4585067","GSM4585068","GSM4585069","GSM4585070","GSM4585071","GSM4585072","GSM4585073","GSM4585074","GSM4585075","GSM4585076",
"GSM4585077","GSM4585078","GSM4585079","GSM4585080","GSM4585081","GSM4590223","GSM4590224","GSM4590225","GSM4590226","GSM4590227","GSM4590228","GSM4608950","GSM4608951","GSM4608952","GSM4608953","GSM4608954","GSM4608955","GSM3019268","GSM3019269","GSM3532132","GSM3532133","GSM3532134","GSM3532135","GSM3532136","GSM3532137","GSM4138800","GSM4138801","GSM4138802","GSM4138803","GSM4322281",
"GSM4437055","GSM4437056","GSM4437057","GSM4437058","GSM4437059","GSM4437060","GSM4454622","GSM4454623","GSM4454624","GSM4454625","GSM4454626","GSM4454627","GSM4454628","GSM4454629","GSM4454630","GSM4454631","GSM4463326","GSM4463329","GSM4463332","GSM4512121","GSM4512122","GSM4512123","GSM4512124","GSM4512125","GSM4512126","GSM4512127","GSM4512128","GSM4572376","GSM4572377","GSM4572378",
"GSM4572379","GSM4572380","GSM4572381","GSM4572382","GSM4572383","GSM4572384","GSM4572386","GSM4572388","GSM4572389","GSM4572390","GSM4812000","GSM4812001","GSM4818246","GSM4818247","GSM4818248","GSM4818249","GSM3068940","GSM3068943","GSM3068946","GSM3156508","GSM3156509","GSM3156510","GSM3156513","GSM3704153","GSM3704154","GSM3704155","GSM3704156","GSM3704157","GSM3704158","GSM3704159",
"GSM3704160","GSM4042293","GSM4042294","GSM4042295","GSM4042296","GSM4042298","GSM4042300","GSM4042301","GSM4042302","GSM4042303","GSM4042304","GSM4042305","GSM4042308","GSM4042309","GSM4042310","GSM4117329","GSM4117331","GSM4147898","GSM4147899","GSM4147902","GSM4147903","GSM4147905","GSM4150665","GSM4150666","GSM4160691","GSM4160692","GSM4160693","GSM4160694","GSM4160695","GSM4160696",
"GSM4160697","GSM4160698","GSM4160699","GSM4160700","GSM4476221","GSM4476222","GSM4476223","GSM4476224","GSM4476225","GSM4476226","GSM4524443","GSM4684556","GSM4684557","GSM4684558","GSM4805339","GSM4805341","GSM4805342","GSM4805344","GSM4805345","GSM4859467","GSM4859468","GSM4859469","GSM4859470","GSM4859471","GSM4859472","GSM4859473","GSM4859474","GSM4859475","GSM4859476","GSM4886833",
"GSM4886834","GSM4886835","GSM4886854","GSM5068386","GSM5068387","GSM5068388","GSM5068389","GSM5068390","GSM5068391","GSM5173810","GSM5173813","GSM5174080","GSM5174081","GSM5174082","GSM5174083","GSM5174084","GSM5174085","GSM5219932","GSM5219933","GSM5219934","GSM5219935","GSM5219936","GSM5219938","GSM5219939","GSM5219940","GSM5243509","GSM5243510","GSM5243511","GSM5243512","GSM5257961",
"GSM5332606","GSM5332607","GSM5444444","GSM5444445","")

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
