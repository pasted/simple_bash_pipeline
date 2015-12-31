#Simple BASH Pipeline
============================

Alignment and analysis pipeline for NHS targeted sequencing

Only for historical interest. Original Bash pipeline for Exeter Molecular Genetics Lab circa 2012-2013

GATK Best practices pipeline with hard filtering on a given common sequencing artefacts and variants of no known clinical signficance. Since superceded by a Ruby based pipeline (after 2013).

##### Example format for the sample_list.csv
```
Capture number,MODY number,EX number,Gender,Analysis,Disease,Sample type,Comment
p5_8_001,MY0000XX01,EX0000001,Male,MODY,MODY,Whole blood,positive control (1) HNF1A c.872dup/N
p5_8_002,MY0000YY02,EX0000003,Female,MODY,MODY,Whole blood,positive control (2) HNF1B delex1-9/N
```
##### Licence

    Copyright (C) 2013 Garan Jones

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
