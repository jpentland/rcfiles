#!/bin/bash
for a in {0..10}; do
	alias awk$a="awk '{print \$$a}'"
done
