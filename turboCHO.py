print("Initializing program...")
print(r"""\
  _              _              ____ _   _  ___  
 | |_ _   _ _ __| |__   ___    / ___| | | |/ _ \ 
 | __| | | | '__| '_ \ / _ \  | |   | |_| | | | |
 | |_| |_| | |  | |_) | (_) | | |___|  _  | |_| |
  \__|\__,_|_|  |_.__/ \___/   \____|_| |_|\___/ 
                                                 """)

print("Importing libraries...")


import sys
import pandas as pd
import numpy as np
from keras.models import load_model
from multiprocessing.dummy import Pool as ThreadPool
import timeit
from sklearn.model_selection import train_test_split
from matplotlib import pyplot
from sklearn.metrics import r2_score
from itertools import groupby
from random import choices

### Fixed variables:
dataset_file=sys.argv[1]
secreted_genes=sys.argv[2]
n_samples=sys.argv[3]
output_file=sys.argv[4]

print("Initializing in-silico predictions...")
print("Importing RNAseq data...")
results=pd.read_csv(dataset_file,index_col=[0])
genes=results.index.values
samples=results.columns.values
print("Importing list of secretory genes...")
secretome=np.load(secreted_genes,allow_pickle=True).tolist()
print("Calculating Secretory Index...")
secreted_sum=pd.DataFrame(index=results.columns,data=results.loc[secretome,:].sum(axis=0),columns=["secreted"]) 

print("Pre-processing...")
#discard genes used as the score
results.drop(labels=secretome,axis=0,inplace=True)


# ### Discarding samples with medium secretory index

#keep top and low producers
top_percent=int(np.round(results.shape[1]*0.25))

keep_top=list(secreted_sum.sort_values(by="secreted",ascending=False).index[0:top_percent])
keep_bottom=list(secreted_sum.sort_values(by="secreted",ascending=False).index[-top_percent:])
keep=keep_top+keep_bottom


X=results[keep].copy()
X=X.T
y=secreted_sum.loc[keep].copy()

X_train, X_test, y_train, y_test=train_test_split(X,y,test_size=0.4,random_state=1)

print("Training nn model...")

from keras import Sequential
from keras.layers import Dense
def build_regressor():
    regressor = Sequential()
    regressor.add(Dense(units=X.shape[1], input_dim=X.shape[1], kernel_initializer='he_normal', activation='relu'))
    regressor.add(Dense(1,activation='linear'))
    regressor.compile(loss='mean_squared_error', optimizer='Adam')
    return regressor

from keras.wrappers.scikit_learn import KerasRegressor
#from keras.callbacks import ModelCheckpoint	#this holds the last best model
batch_size=500
#checkpointer=ModelCheckpoint(filepath="weights.hdf5", verbose=1, save_best_only=True)	#hold the last best model
regressor = KerasRegressor(build_fn=build_regressor, batch_size=batch_size, epochs=100)

#Start training

tic=timeit.default_timer()
history = regressor.fit(X_train, y_train, validation_data=(X_test, y_test))
toc=timeit.default_timer()
print("Training time: "+str((toc-tic)/60)+ " minutes")


# plot loss during training
pyplot.title('Loss / Mean Squared Error')
pyplot.plot(history.history['loss'], label='train')
pyplot.plot(history.history['val_loss'], label='test')
pyplot.xlabel("epochs")
pyplot.ylabel("Cost (mse)")
pyplot.ylim(0,1e12)
pyplot.xlim(0,100)
pyplot.legend()
pyplot.savefig("25P_1L_100E_Hen_500B_lc.png")

#Importing all results again to evaluate model on the whole dataset
X=results.copy()
X=X.T
y=secreted_sum.copy()

y_pred=regressor.predict(X)

##Ploting model evaluation
fig, ax = pyplot.subplots()
ax.scatter(y, y_pred)
ax.plot([y.min(), y.max()], [y.min(), y.max()], 'k--', lw=4)
ax.set_xlabel('Measured')
ax.set_ylabel('Predicted')
pyplot.savefig("25P_1L_100E_Hen_500B_accuracy.png")


print("Successful training!")
##Print r2 score
print("Global R2= "+str(r2_score(y,y_pred)))

print("Calculating residuals...")

##generating random list of samples
#samples=pd.read_csv(samples_file,header=None) #Uncomment if samples are given in a csv file
samples=choices(samples,k=int(n_samples))

def iterator(gene):
    sample_rna=X.iloc[X.index.get_loc(sample)].copy()
    y_pred_before=int(regressor.predict(np.array(sample_rna).reshape(1,-1)))
    gene_counts=X.iloc[X.index.get_loc(sample)].copy()
    gene_counts[gene]=gene_counts[gene]*10
    y_pred=regressor.predict(np.array(gene_counts).reshape(1,-1))
    residuals.append((gene,y_pred-y_pred_before))

# ### Calculating residuals, ranking candidate genes

#Generating a table of candidate genes predicted for each sample
tic=timeit.default_timer()
candidates=pd.DataFrame()
for sample in samples:
    residuals=[]
    pool=ThreadPool(processes=20)
    results_pool=pool.map(iterator,[gene for gene in X.columns.values])
    gene_score=pd.DataFrame(residuals,columns=["gene_name","residual"])
    sorted_genes=gene_score.sort_values(by="residual",ascending=False)[0:200].gene_name
    candidates[sample]=sorted_genes.values

print("Saving residuals file...")
#candidates.to_csv(output_candidates)
toc=timeit.default_timer()
print("Predicting time: "+str((toc-tic)/60)+ " minutes")


print("Calculating final scores...")

print("Generating set of unique genes...")
tic=timeit.default_timer()
#Generating sets of unique genes in the matrix
full_list=[]
for sample in samples:
    for gene in candidates[sample]:
        full_list.append(gene)
ulist=set(full_list)

#Generating scores for each candidate
print("Calculating gene frequencies...")
#Calculating frequencies of each gene
freq25 = {value: len(list(freq)) for value, freq in groupby(sorted(full_list))}

print("Calculating scores...")
score25=pd.DataFrame(index=ulist,columns=["score"])
for gene in ulist:
    score25["score"][gene]=0
    for sample in samples:
        if gene in candidates[sample].values:
            index=candidates[sample][candidates[sample]==gene].index[0]
            p_score=(200-index)/(20*int(len(samples)))
            score25["score"][gene]+=p_score*(freq25[gene]/int(len(samples)))
            
print("Saving final scores...")            
score25.sort_values(by="score",ascending=False).to_csv(output_file)

toc=timeit.default_timer()
print("Sorting time: "+str((toc-tic)/60)+ " minutes")

print("Prediction of candidates successful!") 
