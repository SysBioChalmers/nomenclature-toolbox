# Nomenclature ModelSEED
Nomenclature Toolbox for semi-manual curation of a collection of GenomeScale Metabolic models. Nomenclature Toolbox can be used for:
* assigning a series of **Chemical Properties** to the metabolites and reactions in a Genome-Scale Metabolic model, such as:
  *  _Chemical Formula_
  * _DeltaG_
* assigning a series of **External Database Identifiers** to the metabolites and reactions in a Genome-Scale Metabolic model, such as:
  *  _KEGG_
  * _EC Numbers_
  * _ChEBI_
  * _InChI_
* performing a series of **Metabolic Tasks** to ensure that the Genome- Scale Metabolic models are simulation ready and solid, such asCheck for :
  * _Short Chain Fatty Acids_
  * _Amino Acids_
* assigning Genome References to models, such as:
  * _Uniprot accession numbers_

#### Functionality 
The Nomenclature Toolbox takes all the metabolites found in ModelSEED generated genome-scale metabolic model and assigns annotation from KEGG, EC, ChEBI and InChI databases based on their name or the components' chemical composition.
The script locates all the possible annotation identifiers that one can have given thesefeatures and on occasion demands user input when there are multiple cases of similar annotation for each component.

Furthermore, Nomenclature Toolbox converts The metabolite ids according to SysBio standards:
  * Minor conversion of the metabolite ids from _cpdxxxxx_c0_ to _cpdxxxxx_
  * Minor conversion of the reaction ids from _rxnxxxxx_c0_ to _rxnxxxxx_


## Installation
* *_PROGRAMMING LANGUAGE/Version_*:
  *  You need a functional Matlab installation of **Matlab_R_2011_Rb>=**
* Clone [Nomenclature_ModelSEED](git@github.com:SysBioChalmers/nomenclature-script) branch from [SysBioChalmers GitHub](https://github.com/SysBioChalmers)
* Add the folder *_nomenclature_ModelSEED_* to your Matlab path:
```matlab
addpath('/Users/.../Matlab/.../nomenclature_ModelSEED');
```

### Dependencies
- add **[cprintf](https://se.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-window)** Matlab Function to your Matlab path
- add **[cobratoolbox](https://github.com/opencobra/cobratoolbox)** Matlab Toolbox to your Matlab path
- add **[m2html](http://www.artefact.tk/software/matlab/m2html/)** Matlab Function to your Matlab path


#### Additional APIs
- **[ModelSEED](https://github.com/ModelSEED/ModelSEEDDatabase/tree/f92036b50c503e9ab950bfc6ac75f18a39213e3d)** database as a Git submodule
- **[bioservices](https://pythonhosted.org/bioservices/)** python package, more info [here](http://wiki.sysbio.chalmers.se/mediawiki/index.php/SysBio_Computational_lab_code_sharing_and_modelling_discussion_area)
- **[KBase](https://github.com/zertan/kbInterface)** interface, more info [here](http://wiki.sysbio.chalmers.se/mediawiki/index.php/SysBio_Computational_lab_code_sharing_and_modelling_discussion_area)

## Example Use-Cases and Tests
All tests and code example scripts can be found [here](git@github.com:SysBioChalmers/nomenclature-script/tree/nomenclature_ModelSEED/test) 
#### Loading a Model
- Load  a GEM model (compilation of other bacterial models) and correct annotation for metabolites and reactions
```matlab
setupModels;
```
#### Assigning Chemical Properties
- Assigning Chemical Formula to metabolites
```matlab
model = assignChemicalProperties(model, 'formula');
```
- Assigning DeltaG o metabolites and reactions
```matlab
model = assignChemicalProperties(model, 'deltaG');
```

#### Assigning Identifiers form external Databases to metabolites and Reactions
- Assigning **KEGG** Identifiers to metabolites and reactions
```matlab
model = assignExternalDbIds(model, 'KEGG');
```
- Assigning **Enzyme** Comission Numbers to reactions
```matlab
model = assignExternalDbIds(model, 'EC');
```
- Assigning **ChEBI** Identifiers to metabolites 
```matlab
model = assignExternalDbIds(model, 'ChEBI');
```
- Assigning **InChI** Identifiers to metabolites
```matlab
model = assignExternalDbIds(model, 'InChI');
```

#### Assigning Gene Identifiers using Bioservices
`findMapping` is a command which uses the Uniprot web services to convert between gene identifiers of different databases. First make sure that you have bioservices installed and accessible from matlab. Then for an inpit cell array 'aliases' of different gene idnetifiers (each gene can have many initial ids), the below command returns a new set of genes ids (in this case UniProt ids).

```matlab
[geneIds,geneMaps]=findMapping(aliases,'UniProtKB AC','Escherichia coli')
```
Please note that this command uses online services and can take a while to finnish. Supported database identifier strings can be found like so:

```matlab
load 'mapping/uniprotIdMap.mat'
keys(dbStr)
```

#### Metabolic Tasks
- Checking for **Short Chain Fatty Acid Production**
```matlab
production = metabolicChecks(model, 'scfa');
```
- Checking for **Amino Acid Production**
```matlab
production = metabolicChecks(model, 'aa');
```

## Contributors
- [Dimitra Lappa](http://www.chalmers.se/en/staff/Pages/lappa.aspx), Chalmers University of Technology, Gothenburg Sweden
- [Daniel Hermansson](http://www.chalmers.se/en/staff/Pages/hedani.aspx), Chalmers University of Technology, Gothenburg Sweden
- [Seyedeh Shaghayegh](http://www.chalmers.se/en/staff/Pages/shaghayegh-hosseini.aspx) Hosseini, Chalmers University of Technology, Gothenburg Sweden

## License
The MIT License (MIT)

> Copyright (c) 2016 Systems and Synthetic Biology
>
> Chalmers University of Technology Cothenburg, Sweden
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
