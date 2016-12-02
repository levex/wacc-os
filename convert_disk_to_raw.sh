#!/bin/sh

rm disk.img
VBoxManage clonehd sda.vdi disk.img --format RAW
