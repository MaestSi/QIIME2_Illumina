#!/bin/bash

#
# Copyright 2020 Simone Maestri. All rights reserved.
# Simone Maestri <simone.maestri@univr.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

FW_PRIMER=$1
RV_PRIMER=$2
DB_FASTA=$3
TAXONOMY_TSV=$4

DB=$(echo $(basename $DB_FASTA) | sed 's/\.f.*/.qza/')
TAXONOMY=$(echo $(basename $TAXONOMY_TSV) | sed 's/\.t.*/.qza/')
CLASSIFIER=$(echo $(basename $DB_FASTA) | sed 's/\.f.*/-nb-classifier.qza/')

qiime tools import \
--type FeatureData[Sequence] \
--input-format DNAFASTAFormat \
--input-path $DB_FASTA \
--output-path $DB

qiime tools import \
--type FeatureData[Taxonomy] \
--input-format HeaderlessTSVTaxonomyFormat \
--input-path $TAXONOMY_TSV \
--output-path $TAXONOMY

qiime feature-classifier extract-reads \
  --i-sequences $DB \
  --p-f-primer $FW_PRIMER \
  --p-r-primer $RV_PRIMER \
  --p-min-length 100 \
  --p-max-length 600 \
  --o-reads ref-seqs.qza

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ref-seqs.qza \
  --i-reference-taxonomy $TAXONOMY \
  --o-classifier $CLASSIFIER
