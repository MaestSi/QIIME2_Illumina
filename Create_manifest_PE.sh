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

SAMPLE_METADATA=$1
READS_DIR=$2

echo -e sample-id"\t"forward-absolute-filepath"\t"reverse-absolute-filepath > manifest.txt

for s in $(cat $SAMPLE_METADATA | cut -f1 | tail -n +2); do
  #echo $s;
  R1=$(realpath $(find $READS_DIR | grep $s"_" | grep "R1" | grep "\\.fastq\\.gz"));
  R2=$(realpath $(find $READS_DIR | grep $s"_" | grep "R2" | grep "\\.fastq\\.gz"));
  echo -e $s"\t"$R1"\t"$R2 >> manifest.txt
done
