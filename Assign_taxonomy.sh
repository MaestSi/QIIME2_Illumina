#!/bin/bash

#
# Copyright 2021 Simone Maestri. All rights reserved.
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

CLASSIFIER=$1

qiime feature-classifier classify-sklearn \
  --i-classifier $CLASSIFIER \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza \
  --p-n-jobs -1

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv

qiime taxa collapse \
--i-table table.qza --i-taxonomy taxonomy.qza \
--p-level 7 \
--o-collapsed-table table_collapsed.qza

qiime tools export \
--input-path table_collapsed.qza \
--output-path .

mv feature-table.biom feature-table_absfreq.biom

biom convert \
-i feature-table_absfreq.biom \
-o feature-table_absfreq.tsv \
--to-tsv \
--table-type 'Taxon table'

qiime feature-table relative-frequency \
--i-table table_collapsed.qza \
--o-relative-frequency-table table_collapsed_relfreq.qza

qiime metadata tabulate  \
--m-input-file table_collapsed_relfreq.qza  \
--o-visualization table_collapsed_relfreq.qzv

qiime tools export \
--input-path table_collapsed_relfreq.qza \
--output-path .

mv feature-table.biom feature-table_relfreq.biom

biom convert \
-i feature-table_relfreq.biom \
-o feature-table_relfreq.tsv \
--to-tsv \
--table-type 'Taxon table'
