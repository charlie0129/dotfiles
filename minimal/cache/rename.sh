#!/bin/bash

for i in *; do mv $i ${i/https-COLON--SLASH--SLASH-github.com-SLASH-/}; done
for i in *; do mv $i ${i/-SLASH-/_}; done
