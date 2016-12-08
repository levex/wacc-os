#!/bin/sh

rm sda.vdi
VBoxManage convertdd disk.img sda.vdi --format VDI --variant Fixed
