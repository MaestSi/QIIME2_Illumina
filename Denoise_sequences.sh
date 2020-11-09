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

TRIM_LEFT_F=$1
TRIM_LEFT_R=$2
TRUNC_LEN_F=$3
TRUNC_LEN_R=$4

qiime dada2 denoise-paired \
--i-demultiplexed-seqs sequences.qza \
--p-trim-left-f $TRIM_LEFT_F --p-trim-left-r $TRIM_LEFT_R --p-trunc-len-f $TRUNC_LEN_F --p-trunc-len-r $TRUNC_LEN_R \
--o-table table.qza --o-representative-sequences rep-seqs.qza --o-denoising-stats denoising-stats.qza \
--p-n-threads 0

qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv
