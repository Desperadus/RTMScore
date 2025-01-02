# RTMScore

RTMScore is a a novel scoring function based on residue-atom distance likelihood potential and graph transformer, for the prediction of protein-ligand interactions. 
<div align=center>
<img src="https://github.com/sc8668/RTMScore/blob/main/121.jpg" width="600px" height="300px">
</div> 

The proteins and ligands were first characterized as 3D residue graphs and 2D molecular graphs, respectively, followed by two groups of independent graph transformer layers to learn the node representations of proteins and ligands. Then all node features were concatenated in a pairwise manner, and input into an MDN to calculate the parameters needed for a mixture density model. Through this model, the probability distribution of the minimum distance between each residue and each ligand atom could be obtained, and aggregated into a statistical potential by summing all independent negative log-likelihood values.

### Requirements
Install project using conda from `environment.yml` file. Run:
```bash
conda env create -f environment.yml
```


However I advise one to use Docker as the optimal method. One can create the image by running:
```bash
docker build -t rtmscore .
```

The following commands should set up a working `conda` environment.

### Datasets
[PDBbind](http://www.pdbbind.org.cn)    
[CASF-2016](http://www.pdbbind.org.cn)    
[PDBbind-CrossDocked-Core](https://zenodo.org/record/5525936)      
[DEKOIS2.0](https://zenodo.org/record/6623202)       
[DUD-E](https://zenodo.org/record/6623202)

### Examples for using the trained model for prediction
```
cd example
```
___# input is protein (need to extract the pocket first)___
```
python rtmscore.py -p ./1qkt_p.pdb -l ./1qkt_decoys.sdf -rl ./1qkt_l.sdf -gen_pocket -c 10.0 -m ../trained_models/rtmscore_model1.pth
```
___# input is pocket___
```
python rtmscore.py -p ./1qkt_p_pocket_10.0.pdb -l ./1qkt_decoys.sdf -m ../trained_models/rtmscore_model1.pth
```
___# calculate the atom contributions of the score___
```
python rtmscore.py -p ./1qkt_p_pocket_10.0.pdb -l ./1qkt_decoys.sdf -ac -m ../trained_models/rtmscore_model1.pth
```
___# calculate the residue contributions of the score___
```
python rtmscore.py -p ./1qkt_p_pocket_10.0.pdb -l ./1qkt_decoys.sdf -rc -m ../trained_models/rtmscore_model1.pth
```


### Training

Files containing graphs for training can be found [here](https://zenodo.org/record/6859325#.Y0aU38hPoyg) (check [Issue 9](https://github.com/sc8668/RTMScore/issues/9)).
```
wget https://zenodo.org/record/6859325/files/graphs_for_pdbbind.zip
unzip graphs_for_pdbbind.zip -d graphs_for_pdbbind
```

Following https://discuss.pytorch.org/t/runtimeerror-unable-to-open-shared-memory-object-depending-on-the-model/116090/3 to fix ```RuntimeError: unable to open shared memory object``` error
```
conda activate rtmscore
ulimit -n 64000
```

Now start training
```
cd scripts/
CUDA_VISIBLE_DEVICES=1 python train_model.py
```



