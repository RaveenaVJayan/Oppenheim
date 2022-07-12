*** Settings ***

Library  RequestsLibrary
Library     JSONLibrary
Library  Collections
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  OperatingSystem
Library  SeleniumLibrary

*** Variables ***

${base_url}=     http://localhost:8080


*** Test Cases ***

TC6: Normal Rounding of Tax Relief
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=.00  expected_status=200
     log to console  ${response.content}





