*** Settings ***
Library  SeleniumLibrary
Library  DataDriver  ../TestData/UserData.csv

*** Variables ***



*** Test Cases ***
UploadCSV
    ${singlelist}=		Read CSV As Single List		UserData.csv
	log to console		${singlelist}








